{ config, lib, pkgs, ... }: 

with lib;

let
  cfg = config.slopNvim;

  themeConfig = import ./configs/theme.nix { inherit config lib pkgs; };
  lspConfig = import ./configs/lsp.nix { inherit config lib pkgs; };
  telescopeConfig = import ./configs/telescope.nix { inherit config lib pkgs; };
  remapConfig = import ./configs/remap.nix { inherit config lib pkgs; };
  setConfig = import ./configs/set.nix { inherit config lib pkgs; };
  lualineConfig = import ./configs/lualine.nix { inherit config lib pkgs; };
  treesitterConfig = import ./configs/treesitter.nix { inherit config lib pkgs; };
  surroundConfig = import ./configs/surround.nix { inherit config lib pkgs; };
  undotreeConfig = import ./configs/undotree.nix { inherit config lib pkgs; };

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
      default = "tokyonight";
      description = "Color theme to use";
    };

    lualine = {
      enable = mkOption {
        type = types.bool;
	default = true;
	description = "Enable lualine";
      };

      theme = mkOption {
        type = types.enum [ "palenight" ];
	default = [ "palenight" ];
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
	nvim-web-devicons
	which-key-nvim
      ] ++ (lists.optionals (cfg.theme == "gruvbox") [ gruvbox-nvim ])
        ++ (lists.optionals (cfg.theme == "catppuccin") [ catppuccin-nvim ])
        ++ (lists.optionals (cfg.theme == "tokyonight") [ tokyonight-nvim ])

        ++ (lists.optionals (cfg.lsp.enable) lspConfig.plugins)
        ++ (lists.optionals (cfg.enableTelescope) telescopeConfig.plugins)
        ++ (lists.optionals (cfg.lualine.enable) lualineConfig.plugins)
        ++ (lists.optionals (cfg.enableTreesitter) (treesitterConfig.plugins cfg.lsp.languages))
        ++ (surroundConfig.plugins)
        ++ (undotreeConfig.plugins);

      extraLuaConfig = ''
        ${themeConfig.luaConfig cfg.theme}
	${remapConfig.luaConfig}
	${setConfig.luaConfig}
	${surroundConfig.luaConfig}
	${undotreeConfig.luaConfig}
	${strings.optionalString (cfg.lsp.enable) (lspConfig.luaConfig cfg.lsp.languages)}
	${strings.optionalString (cfg.enableTelescope) (telescopeConfig.luaConfig)}
	${strings.optionalString (cfg.lualine.enable) (lualineConfig.luaConfig cfg.lualine.theme)}
	${strings.optionalString (cfg.enableTreesitter) (treesitterConfig.luaConfig cfg.lsp.languages)}
      ''; 

      extraPackages = with pkgs; [
        lua5_1 
        lua51Packages.luarocks
      ] ++ (lspConfig.packages cfg.lsp.languages);

      defaultEditor = true;      
      viAlias = true;    
      vimAlias = true;    
    };
  };
}
