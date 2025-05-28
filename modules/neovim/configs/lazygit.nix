{ config, lib, pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.lazygit-nvim
  ];

  luaConfig = ''
    vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { desc = "LazyGit" })
  '';
}
