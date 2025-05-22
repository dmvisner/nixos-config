{ config, lib, pkgs, ... }:
{
  plugins = theme: with pkgs.vimPlugins; []
    ++ (lib.lists.optionals (theme == "gruvbox") [ gruvbox-nvim ])
    ++ (lib.lists.optionals (theme == "catppuccin") [ catppuccin-nvim ])
    ++ (lib.lists.optionals (theme == "tokyonight") [ tokyonight-nvim ]);

  luaConfig = theme: ''

    ${lib.optionalString (theme == "gruvbox") ''
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd("colorscheme gruvbox")
    ''}

    ${lib.optionalString (theme == "catppuccin") ''
      require("catppuccin").setup({
        flavour = "auto",
      })
      vim.cmd("colorscheme catppuccin")
    ''}

    ${lib.optionalString (theme == "tokyonight") ''
      require("tokyonight").setup({
        style = "moon",
      })
      vim.cmd("colorscheme tokyonight")
    ''}

  '';
}
