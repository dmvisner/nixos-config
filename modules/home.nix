{ config, pkgs, lib, home-manager, ... }:
{
  home = {
    username = "derek";
    homeDirectory = "/home/derek";
  }; 

  programs = {
    home-manager.enable = true;
    
    ripgrep.enable = true;

    nix-direnvv.enable = true;

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
    };
  };

  
}
