{ config, lib, pkgs, ... }:

{
    networking = {
	hostName = "nixos-wsl";
	nameservers = [ "8.8.8.8" "8.8.4.4" ];
    };

    nix = {
      settings = {
	experimental-features = [ "nix-command" "flakes" ];
	substituters = [ 
	  "https://cache.nixos.org"
	];
	trusted-public-keys = [
	  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="	
	];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    security.pki.certificates = [
	(builtins.readFile ./certs/ZscalerRootCertificate-2048-SHA256.crt)
    ];

    environment.systemPackages = with pkgs; [
	git
	vim
	wget
	curl
	htop
	gcc
    ];

    time.timeZone = "America/New_York";

    users = {
	groups = {
	  nixconfig = {};
	};
	users = {
	  derek = {
		isNormalUser = true;
		extraGroups = [ "wheel" "nixconfig" ];
		initialPassword = "password";
	  };
	};	
    };

    # Add a systemd service to change ownership of /etc/nixos to derek
    systemd.services.fix-nixos-permissions = {
      description = "Set ownership of /etc/nixos to derek";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/chown -R derek /etc/nixos";
        RemainAfterExit = true;
      };
    };

    system.stateVersion = "24.11"; # Did you read the comment?
}
