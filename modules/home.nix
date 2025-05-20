{ config, pkgs, lib, inputs, ... }:
{
  home = {
    username = "derek";
    stateVersion = "25.05";
    
    file = {
      ".config/nvim" = {
        source = inputs.nvim-config;
        recursive = true;
      };
    };
  }; 

  programs = {
    home-manager.enable = true;
    
    ripgrep.enable = true;

    direnv.nix-direnv.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        update = "sudo nixos-rebuild switch --flake .";
      };
    }; 

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };
}
