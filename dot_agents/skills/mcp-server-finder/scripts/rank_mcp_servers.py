#!/usr/bin/env python3
"""Rank MCP server candidates deterministically.

Input: JSON array of candidate objects.
Output: ranked JSON and optional markdown table.
"""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any


def _to_float(v: Any, default: float = 0.0) -> float:
    try:
        if v is None:
            return default
        return float(v)
    except (TypeError, ValueError):
        return default


def _to_bool(v: Any) -> bool:
    if isinstance(v, bool):
        return v
    if isinstance(v, str):
        return v.strip().lower() in {"1", "true", "yes", "y"}
    if isinstance(v, (int, float)):
        return v != 0
    return False


def _as_list(v: Any) -> list[str]:
    if v is None:
        return []
    if isinstance(v, list):
        return [str(x).strip() for x in v if str(x).strip()]
    s = str(v).strip()
    if not s:
        return []
    return [x.strip() for x in s.split(",") if x.strip()]


def _norm_stars(stars: float) -> float:
    # log-scale to avoid domination by very large repos
    return min(1.0, math.log10(max(1.0, stars + 1)) / 4.0)


def _freshness(days: float, half_life_days: float) -> float:
    if days < 0:
        days = 0
    return math.exp(-days / max(1.0, half_life_days))


def _license_score(license_name: str) -> float:
    l = (license_name or "").strip().lower()
    if not l:
        return 0.2
    permissive = {
        "mit",
        "apache-2.0",
        "bsd-2-clause",
        "bsd-3-clause",
        "isc",
        "mpl-2.0",
    }
    weak = {"lgpl", "lgpl-2.1", "lgpl-3.0", "gpl-2.0", "gpl-3.0", "agpl-3.0"}
    if l in permissive:
        return 1.0
    if any(x in l for x in permissive):
        return 0.9
    if l in weak or any(x in l for x in weak):
        return 0.35
    return 0.6


def _transport_match(candidate_transports: list[str], required: set[str]) -> bool:
    if not required:
        return True
    ct = {t.lower() for t in candidate_transports}
    return required.issubset(ct)


def score_candidate(c: dict[str, Any]) -> tuple[float, dict[str, float], float]:
    stars = _to_float(c.get("stars"), 0.0)
    last_commit_days = _to_float(c.get("last_commit_days"), 9999.0)
    release_age_days = _to_float(c.get("release_age_days"), 9999.0)
    fit_score = max(0.0, min(5.0, _to_float(c.get("fit_score"), 3.0))) / 5.0

    has_quickstart = _to_bool(c.get("has_quickstart"))
    has_examples = _to_bool(c.get("has_examples"))
    has_ci = _to_bool(c.get("has_ci"))
    has_tests = _to_bool(c.get("has_tests"))
    has_security_policy = _to_bool(c.get("has_security_policy"))
    has_signed_releases = _to_bool(c.get("has_signed_releases"))

    maintenance = 0.6 * _freshness(last_commit_days, 90) + 0.4 * _freshness(
        release_age_days, 120
    )
    adoption = _norm_stars(stars)
    docs = (0.55 if has_quickstart else 0.0) + (0.45 if has_examples else 0.0)
    engineering = (0.5 if has_ci else 0.0) + (0.5 if has_tests else 0.0)
    security = 0.4 * _license_score(str(c.get("license", "")))
    security += 0.35 * (1.0 if has_security_policy else 0.0)
    security += 0.25 * (1.0 if has_signed_releases else 0.0)

    weights = {
        "maintenance": 0.22,
        "adoption": 0.12,
        "docs": 0.16,
        "engineering": 0.16,
        "security": 0.14,
        "fit": 0.20,
    }

    components = {
        "maintenance": maintenance,
        "adoption": adoption,
        "docs": docs,
        "engineering": engineering,
        "security": security,
        "fit": fit_score,
    }

    score = sum(weights[k] * components[k] for k in weights) * 100.0

    # Confidence from evidence completeness
    evidence_fields = [
        c.get("stars"),
        c.get("last_commit_days"),
        c.get("release_age_days"),
        c.get("license"),
        c.get("transport"),
        c.get("auth"),
    ]
    completeness = sum(1 for v in evidence_fields if v not in (None, "", [], {})) / len(
        evidence_fields
    )
    confidence = min(1.0, 0.5 * completeness + 0.5 * (0.6 + 0.4 * docs))

    return score, components, confidence


def to_markdown(rows: list[dict[str, Any]]) -> str:
    hdr = (
        "| Rank | Name | Score | Confidence | Sources | Last Commit (days) | Stars | License | "
        "Transport | Auth | Docs/Examples | CI/Tests | Notes |\n"
        "|---:|---|---:|---:|---|---:|---:|---|---|---|---|---|---|"
    )
    lines = [hdr]
    for r in rows:
        docs = f"{'Y' if r.get('has_quickstart') else 'N'}/{'Y' if r.get('has_examples') else 'N'}"
        ci = f"{'Y' if r.get('has_ci') else 'N'}/{'Y' if r.get('has_tests') else 'N'}"
        line = (
            f"| {r['rank']} | {r.get('name', '')} | {r['score']:.1f} | {r['confidence']:.2f} | "
            f"{', '.join(_as_list(r.get('sources')))} | {int(_to_float(r.get('last_commit_days'), 9999))} | "
            f"{int(_to_float(r.get('stars'), 0))} | {r.get('license', '')} | "
            f"{', '.join(_as_list(r.get('transport')))} | {', '.join(_as_list(r.get('auth')))} | "
            f"{docs} | {ci} | {str(r.get('notes', '')).replace('|', '/')} |"
        )
        lines.append(line)
    return "\n".join(lines) + "\n"


def main() -> None:
    p = argparse.ArgumentParser(description="Rank MCP server candidates")
    p.add_argument("--input", required=True, help="Path to candidates JSON array")
    p.add_argument("--json", default="ranked.json", help="Output ranked JSON path")
    p.add_argument("--markdown", default="", help="Output markdown table path")
    p.add_argument("--top", type=int, default=20, help="Top N results")
    p.add_argument(
        "--require-transport",
        default="",
        help="Comma-separated required transports (e.g. stdio,http)",
    )
    p.add_argument(
        "--require-license", default="", help="Comma-separated allowed licenses"
    )
    args = p.parse_args()

    candidates = json.loads(Path(args.input).read_text())
    if not isinstance(candidates, list):
        raise SystemExit("Input must be a JSON array")

    required_transport = {
        x.strip().lower() for x in args.require_transport.split(",") if x.strip()
    }
    required_license = {
        x.strip().lower() for x in args.require_license.split(",") if x.strip()
    }

    ranked: list[dict[str, Any]] = []
    for c in candidates:
        if not isinstance(c, dict):
            continue
        transports = _as_list(c.get("transport"))
        if not _transport_match(transports, required_transport):
            continue
        lic = str(c.get("license", "")).strip().lower()
        if required_license and lic not in required_license:
            continue

        score, components, confidence = score_candidate(c)
        row = dict(c)
        row["score"] = round(score, 2)
        row["confidence"] = round(confidence, 3)
        row["score_components"] = {k: round(v, 3) for k, v in components.items()}
        ranked.append(row)

    ranked.sort(
        key=lambda x: (
            -_to_float(x.get("score")),
            -_to_float(x.get("confidence")),
            _to_float(x.get("last_commit_days"), 9999),
            -_to_float(x.get("stars"), 0),
            str(x.get("name", "")).lower(),
        )
    )

    ranked = ranked[: max(1, args.top)]
    for i, r in enumerate(ranked, start=1):
        r["rank"] = i

    Path(args.json).write_text(json.dumps(ranked, indent=2))
    if args.markdown:
        Path(args.markdown).write_text(to_markdown(ranked))

    print(f"Wrote {len(ranked)} ranked candidates to {args.json}")
    if args.markdown:
        print(f"Wrote markdown table to {args.markdown}")


if __name__ == "__main__":
    main()
