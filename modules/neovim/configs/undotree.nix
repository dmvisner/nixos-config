{ config, lib, pkgs, ... }:
{
  plugins = [ pkgs.vimPlugins.undotree ];

  luaConfig = ''
    vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
  '';
}
