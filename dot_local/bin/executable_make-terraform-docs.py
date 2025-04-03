#!/usr/bin/env python3
"""Generate Terraform Docs."""
import argparse
import logging
import os
import shlex
import subprocess
from typing import Dict, Generator

logging.basicConfig(level=logging.INFO)


def parse_args() -> Dict[str, str]:
    """Parse CLI Arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--args", "-a", help="Arguments for terraform-docs", required=True
    )
    args = vars(parser.parse_args())
    return args


def find_files(dir: str = ".") -> Generator[str, None, None]:
    """Traverse directory and yield files."""
    for root, _dirs, files in os.walk(dir):
        for filename in files:
            yield os.path.join(root, filename)


def only_tf_files(filename: str) -> bool:
    """Files which are Terraform related."""
    return filename.endswith(".tf") or filename.endswith(".tfvars")


def main() -> None:
    """Entrypoint for Script."""
    args = parse_args()
    tf_files = filter(only_tf_files, find_files())
    tf_dirs = map(os.path.dirname, tf_files)
    dirs = sorted(set(tf_dirs))
    for dirname in dirs:
        cmd = shlex.split("terraform-docs " + args["args"] + " " + dirname)
        logging.info(cmd)
        subprocess.run(cmd)


if __name__ == "__main__":
    main()
