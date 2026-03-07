return {

  {
    'milanglacier/minuet-ai.nvim',
    dependencies = {
      { 'saghen/blink.cmp' },
    },
    config = function()
      require('minuet').setup {
        -- Your configuration options here
      }
      require('blink.cmp').add_source_provider('minuet', {
        enabled = true,
        name = 'minuet',
        module = 'minuet.blink',
        score_offset = 100,
      })
      local keymap = require 'blink.cmp.keymap'
      local config = require 'blink.cmp.config'
      table.insert(config.sources.default, 'minuet')
      local mappings = keymap.get_mappings(config.keymap, 'default')
      keymap.merge_mappings(mappings, {
        ['<A-y>'] = {
          function(cmp)
            cmp.show { providers = { 'minuet' } }
          end,
        },
      })
    end,
  },
}
