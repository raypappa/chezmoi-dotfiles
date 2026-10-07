return {
  'msvechla/yaml-companion.nvim',
  branch = 'kubernetes_crd_detection',
  ft = { 'yaml' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function(_, opts)
    require('yaml-companion').setup(opts)
    require('telescope').load_extension('yaml_schema')
  end,
}
