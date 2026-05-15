return {
  { -- Highlight, edit, and navigate code
    'arborist-ts/arborist.nvim',
    opts = {
      install_popular = true,
      prefer_wasm = true,
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'vim',
        'vimdoc',
        'gitcommit',
        'markdown_inline',
        'yaml',
        'awk',
        'go',
        'groovy',
        'hcl',
        'helm',
        'jq',
        'json',
        'json5',
        'mermaid',
        'terraform',
        'ssh_config',
        'tmux',
        'typescript',
      },
    },
    config = function(opts)
      require('arborist').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
