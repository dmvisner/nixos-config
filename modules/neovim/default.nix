{ config, lib, pkgs, ... }: 

with lib:

let
  cfg = config.slopNvim;
in {
  options.slopNvim = {
    enable = mkEnableOption "Neovim config";     
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
	catppuccin-nvim
	telescope-nvim
	surround-nvim
        nvim-treesitter
	lualine-nvim
	lazygit-nvim
	undotree
	which-key-nvim
      ];
    };
  };
}
