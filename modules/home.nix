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

      extraConfig = ''
        bind -n M-c new-window
        bind -n M-n next-window
        bind -n M-p previous-window
        bind -n M-w choose-window
        bind -n M-0 select-window -t 0
        bind -n M-a select-window -t 0
        bind -n M-1 select-window -t 1
        bind -n M-s select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-d select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-f select-window -t 3
     	bind -n M-k kill-server
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
	  plugin = dracula;
	  extraConfig = ''
	    set -g @dracula-plugins "cpu-usage ram-usage time"
	    set -g @dracula-show-left-icon "#h"
	    set -g @dracula-military-time true
	    set -g @dracula-show-timezone false
	    set -g @dracula-refresh-rate 5
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
        config = "vim /etc/nixos";
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
