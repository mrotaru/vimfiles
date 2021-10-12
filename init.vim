set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath . ',~/.vim/pack/nvim/opt'
packadd lspconfig
packadd completion
packadd nim
packadd lsp_signature.nvim

set guifont=Noto\ Mono:h11

" neovide config - hardware-accelerated neovim GUI wrapper
let g:neovide_cursor_animation_length=0.05
let g:neovide_cursor_trail_length=0.4
let g:neovide_cursor_vfx_mode = "sonicboom"
let g:neovide_remember_window_size = v:true
"let g:neovide_fullscreen=v:true

lua <<EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require'completion'.on_attach()
  require 'lsp_signature'.setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
                 -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                   -- set to 0 if you DO NOT want any API comments be shown
                   -- This setting only take effect in insert mode, it does not affect signature help in normal
                   -- mode, 10 by default

    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

    floating_window_above_cur_line = false, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested
    fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🐼 ",  -- Panda for parameter
    hint_scheme = "String",
    use_lspsaga = false,  -- set to true if you want to use lspsaga popup
    hi_parameter = "Search", -- how your parameter will be highlight
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                     -- to view the hiding contents
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    transpancy = 10, -- set this value if you want the floating windows to be transpant (100 fully transpant), nil to disable(default)
    handler_opts = {
      border = "shadow"   -- double, single, shadow, none
    },

    trigger_on_newline = false, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    -- deprecate !!
    -- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    debug = false, -- set to true to enable debug logging
    log_path = "debug_log_file_path", -- debug log path

    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  })
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'nimls', 'pylsp', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" completion
set completeopt=menuone,noinsert
let g:completion_enable_auto_popup = 1 " the scratch win ?
let g:completion_trigger_keyword_length = 1 " default = 1
let g:completion_confirm_key = "\<Tab>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Up>"

source ~/.vim/vimrc
