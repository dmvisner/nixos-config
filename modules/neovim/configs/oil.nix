{ config, lib, pkgs, ... }:
{
  plugins = with pkgs.vimPlugins; [
    oil-nvim
    nvim-web-devicons
  ];

  luaConfig = ''
     vim.keymap.set("n", "<leader>fv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  '';
}
