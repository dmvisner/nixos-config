{ config, lib, pkgs, ... }: 
{
  plugins = [ pkgs.vimPlugins.nvim-surround ];

  luaConfig = ''
  require("nvim-surround").setup({})
  '';
}
