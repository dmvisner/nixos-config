{ config, lib, pkgs, ... }:
{
  plugins = languages: with pkgs.vimPlugins; [
    nvim-treesitter
    nvim-treesitter-textobjects
  ] ++ (lib.lists.optionals (builtins.elem "typescript" languages) [ nvim-treesitter-parsers.typescript ])
    ++ (lib.lists.optionals (builtins.elem "nix" languages) [ nvim-treesitter-parsers.nix ])
    ++ (lib.lists.optionals (builtins.elem "lua" languages) [ nvim-treesitter-parsers.lua ]);

  luaConfig = languages: ''
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = true,
	additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
	  lookahead = true,
	  keymaps = {
	    ["af"] = "@function.outer",
	    ["if"] = "@function.inner",
	  }
	},
      },
    })
  '';
}
