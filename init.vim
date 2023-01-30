set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set runtimepath+=~/.vim/plugin
let &packpath = &runtimepath . ',~/.vim/pack/nvim/opt'
packadd lspconfig

try
  packadd nim " https://github.com/alaviss/nim.nvim
  packadd lsp_signature.nvim " https://github.com/ray-x/lsp_signature.nvim
catch
endtry

set guifont=Noto\ Mono:h11

nmap <F8> :LspStop<CR>
nmap <F9> :LspStart<CR>

lua <<EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n',  '<S-Enter>', '<cmd> lua vim.lsp.buf.references()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n',  '<leader>D', '<cmd> lua vim.diagnostic.open_float()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use LSP as the handler for formatexpr.
  --    See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- For plugins with an `on_attach` callback, call them here. For example:
  -- require('completion').on_attach()


--  local opts = { buffer = bufnr }
--  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
--  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
--  vim.keymap.set('n', '<leader>wl', function() vim.inspect(vim.lsp.buf.list_workspace_folders()) end, opts)
--  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
--  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--  -- vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts) -- no telescope
--  vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
--  -- vim.api.nvim_buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--
--  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
--  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
--  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
--  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
--  -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'nimls', 'pylsp', 'tsserver', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
      }
    }
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable signs
    signs = false,
    --underline = false,
  }
)

EOF

" completion
" related: https://stackoverflow.com/q/35837990
set completeopt+=menuone,noselect,noinsert " don't insert text automatically
inoremap . .<C-x><C-o>
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

source ~/.vim/vimrc
source ~/.vim/init.lua
