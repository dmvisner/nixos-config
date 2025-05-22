{ config, lib, pkgs, ... }: 
{
  plugins = with pkgs.vimPlugins; [
    lualine-nvim
  ];

  luaConfig = theme: ''
    ${lib.optionalString (theme == "palenight") ''
    local palenight = require("lualine.themes.palenight")

    require("lualine").setup({
      options = { theme = palenight },
    })
    ''}
  '';
}
