return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_after_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				-- Enable format_after_save lsp_fallback only for specific filetypes
				local only_filetypes = { "markdown" }
				if vim.tbl_contains(only_filetypes, vim.bo[bufnr].filetype) then
					return { timeout_ms = 1000, lsp_format = "fallback" }
				end
			end,
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "c", "cpp" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				svelte = { "biome" },
				python = { "ruff" },
				markdown = { "markdown-toc", "markdownlint", "mdformat" },
				json = { "jq" },
				yaml = { "yamlfmt" },
				go = { "goimports", "golines" },
				toml = { "taplo" },
				terraform = { "terraform_fmt", "tflint" },
				terragrunt = { "terragrunt_hclfmt" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "biome", "prettier" } },
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
