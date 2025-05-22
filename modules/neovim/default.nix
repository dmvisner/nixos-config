{ config, lib, pkgs, ... }: 

with lib;

let
  cfg = config.slopNvim;

  themeConfig = import ./configs/theme.nix { inherit config lib pkgs; };
  lspConfig = import ./configs/lsp.nix { inherit config lib pkgs; };

in {
  options.slopNvim = {
    enable = mkEnableOption "Neovim config";     

    lsp = {
      enable = mkOption {
        type = types.bool;
	default = true;
	description = "Enable LSP configuration";
      };

      languages = mkOption {
        type = types.listOf (types.enum [ "typescript" "javascript" "nix" "lua" ]);
	default = [ "nix" "lua" ];
      };
    };

    enableTelescope = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Telescope fuzzy finder";
    };

    enableTreesitter = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Treesitter syntax highlighting";
    };

    theme = mkOption {
      type = types.enum [ "gruvbox" "catppuccin" "tokyonight" ];
      default = "catppuccin";
      description = "Color theme to use";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
	nvim-web-devicons
      ] ++ (lib.optionals (cfg.theme == "gruvbox") [ gruvbox-nvim ])
        ++ (lib.optionals (cfg.theme == "catppuccin") [ catppuccin-nvim ])
        ++ (lib.optionals (cfg.theme == "tokyonight") [ tokyonight-nvim ])

        ++ (lspConfig.plugins cfg.lsp.languages);


#	telescope-nvim
	#surround-nvim
        #nvim-treesitter
	#lualine-nvim
	#lazygit-nvim
	#undotree
	#which-key-nvim
	#rainbow-delimiters-nvim
	#nvim-lspconfig
      #];

      extraLuaConfig = ''
        ${themeConfig.luaConfig cfg.theme}
      ''; 

      extraPackages = with pkgs; [
        lua5_1 
        lua51Packages.luarocks
      ];

      defaultEditor = true;      
      viAlias = true;    
      vimAlias = true;    
    };
  };
}
