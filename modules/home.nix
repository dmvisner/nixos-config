{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./neovim
  ];

  home = {
    username = "derek";
    stateVersion = "25.05";

    packages = with pkgs; [
      nodejs_24
      typescript
      typescript-language-server
      amazon-q-cli
    ];
  }; 

  slopNvim = {
    enable = true;

    theme = "tokyonight";

    lsp = {
      enable = true;
      languages = [ "typescript" "nix" "lua" ];
    };

    lualine = {
      enable = true;
      theme = "palenight";
    };

    enableTelescope = true;

    enableTreesitter = true;
  };

  programs = {
    home-manager.enable = true;
    
    ripgrep.enable = true;

    fd.enable = true;

    tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      tmuxinator.enable = true;

      plugins = with pkgs.tmuxPlugins; [
        {
	  plugin = dracula;
	  extraConfig = ''
	    set -g @dracula-plugins "cpu-usage ram-usage"
	    set -g @dracula-refresh-rate 10
	  '';
	}
      ];
    };

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
  };
}
