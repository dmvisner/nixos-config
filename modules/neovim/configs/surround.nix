{ config, lib, pkgs, ... }: 
{
  plugins = [ surround-nvim ];

  luaConfig = ''
  require("nvim-surround").setup({})
  '';
}
