{ config, lib, pkgs, ... }:
{
  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    nvim-cmp
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-cmdline
    luasnip
    cmp_luasnip
    friendly-snippets
    fidget-nvim
  ];

  packages = languages: with pkgs; []
    ++ (lib.lists.optionals (builtins.elem "nix" languages) [ nixd ])
    ++ (lib.lists.optionals (builtins.elem "lua" languages) [ lua-language-server ]);
  

  luaConfig = languages: ''

  ${lib.optionalString (builtins.elem "nix" languages) ''
     vim.lsp.enable("nixd")
  ''}

  ${lib.optionalString (builtins.elem "lua" languages) ''
     vim.lsp.enable("lua_ls")
  ''}

  ${lib.optionalString (builtins.elem "typescript" languages) ''
     vim.lsp.enable('ts_ls')
  ''}

  local cmp = require("cmp")  
  local cmp_lsp = require("cmp_nvim_lsp")  
  local luasnip = require("luasnip")  
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
  )
  
  require("luasnip.loaders.from_vscode").lazy_load()
  require("fidget").setup({})

  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
      ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
      ["<C-y>"] = cmp.mapping.confirm({
        select = true,
	behavior = cmp.ConfirmBehavior.Insert,
      }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item(cmp_select)
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(cmp_select)
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      
    sources = cmp.config.sources({
      { name = "luasnip", keyword_length = 2 },
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "nvim_lsp_signature_help" },
      { name = "buffer", keyword_length = 2 },
    }),

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    formatting = {
	fields = { "menu", "abbr", "kind" },
	format = function(entry, item)
	    local menu_icon = {
		nvim_lsp = "λ",
		luasnip = "⋗",
		buffer = "Ω",
		path = "🖫",
	    }
	    item.menu = menu_icon[entry.source.name]
	    return item
	end,
     },
   })
  '';

}

