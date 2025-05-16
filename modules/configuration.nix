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

    systemd.tmpfiles.rules = [
	"d /etc/nixos 0775 root nixconfig - -"
    ];

    system.stateVersion = "24.11"; # Did you read the comment?
}
