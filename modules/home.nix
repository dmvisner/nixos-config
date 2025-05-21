{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./neovim
  ];
  home = {
    username = "derek";
    stateVersion = "25.05";
    
    #file = {
      #".config/nvim" = {
        #source = inputs.nvim-config;
        #recursive = true;
      #};
    #};

    packages = with pkgs; [
      lua5_1
      lua51Packages.luarocks
    ];
  }; 

  slopNvim.enable = true;

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
        update = "sudo nixos-rebuild switch --flake /etc/nixos";
        config = "sudo vim /etc/nixos";
      };
    }; 

    git = {
      enable = true;
      userName = "dvisner";
      userEmail = "dvisner@netjets.com";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    ssh = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };
  };
}
