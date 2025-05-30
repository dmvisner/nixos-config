{ config, lib, pkgs, ... }:
{
  plugins = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
  ];

  luaConfig = ''
    require("telescope").setup({
      extensions = {
        fzf = {
	  fuzzy = true,
	  override_generic_sorter = true,
	  override_file_sorter = true,
	  case_mode = "smart_case",
	}
      }
    })

    require("telescope").load_extension("fzf")

    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
    vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols, {})

    vim.keymap.set("n", "<leader>gr", builtin.lsp_references)
    vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations)
    vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions)
    vim.keymap.set("n", "<leader>gt", builtin.treesitter)
  '';
}
