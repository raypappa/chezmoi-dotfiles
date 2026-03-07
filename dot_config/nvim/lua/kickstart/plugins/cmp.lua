return {
  'saghen/blink.cmp',
  lazy = false,
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
    },
    cmdline = { enabled = false },
    sources = {
      default = {
        'lsp',
        'path',
        'buffer',
        'snippets',
        'omni',
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
