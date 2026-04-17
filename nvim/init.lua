-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
local opt = vim.opt

opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.signcolumn     = "yes"

opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

opt.hlsearch       = false
opt.incsearch      = true
opt.ignorecase     = true
opt.smartcase      = true

opt.termguicolors  = true
opt.background     = "dark"
opt.splitright     = true
opt.splitbelow     = true

opt.swapfile       = false
opt.backup         = false
opt.undofile       = true
opt.undodir        = vim.fn.expand("~/.vim/undodir")

opt.updatetime     = 50
opt.timeoutlen     = 300
opt.completeopt    = { "menuone", "noselect", "preview" }

opt.clipboard      = "unnamedplus"

-- Cursor shapes
-- Insert  -> thin vertical bar  (|)
-- Visual  -> full block         (█)
-- Normal  -> block
opt.guicursor = table.concat({
  "n-o:block",
  "i-ci:ver25-blinkwait700-blinkoff400-blinkon250",
  "v:block",
  "r-cr:hor20",
  "sm:block",
}, ",")

-- Colorscheme
-- All highlights are wrapped in a function and re-applied via
-- the ColorScheme autocmd so they survive any colorscheme reset.
local function apply_highlights()
  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Background / UI chrome
  hi("Normal",       { bg = "#0d0d0d", fg = "#c0caf5" })
  hi("NormalNC",     { bg = "#0d0d0d" })
  hi("NormalFloat",  { bg = "#161616" })
  hi("LineNr",       { fg = "#3b4261" })
  hi("CursorLineNr", { fg = "#7aa2f7", bold = true })
  hi("CursorLine",   { bg = "#1a1b26" })
  hi("SignColumn",   { bg = "#0d0d0d" })
  hi("ColorColumn",  { bg = "#1a1b26" })
  hi("VertSplit",    { fg = "#1a1b26" })
  hi("WinSeparator", { fg = "#1a1b26" })
  hi("StatusLine",   { bg = "#1a1b26", fg = "#7aa2f7" })
  hi("StatusLineNC", { bg = "#1a1b26", fg = "#3b4261" })
  hi("EndOfBuffer",  { fg = "#0d0d0d" })

  -- Syntax
  hi("Comment",      { fg = "#565f89", italic = true })
  hi("Keyword",      { fg = "#ff007c", bold = true })    -- hot magenta
  hi("Conditional",  { fg = "#ff007c", bold = true })
  hi("Repeat",       { fg = "#ff007c", bold = true })
  hi("Statement",    { fg = "#ff007c", bold = true })
  hi("Exception",    { fg = "#ff007c", bold = true })
  hi("Label",        { fg = "#ff007c", bold = true })
  hi("Function",     { fg = "#7aa2f7" })                 -- blue
  hi("Identifier",   { fg = "#c0caf5" })
  hi("Type",         { fg = "#2ac3de", italic = true })  -- teal italic
  hi("StorageClass", { fg = "#2ac3de", italic = true })  -- int, static, const
  hi("Structure",    { fg = "#2ac3de", italic = true })  -- struct, enum, class
  hi("Typedef",      { fg = "#2ac3de", italic = true })
  hi("String",       { fg = "#9ece6a" })                 -- green
  hi("Number",       { fg = "#ff9e64" })                 -- orange
  hi("Float",        { fg = "#ff9e64" })
  hi("Boolean",      { fg = "#ff9e64" })
  hi("Constant",     { fg = "#ff9e64" })
  hi("Operator",     { fg = "#73daca" })                 -- green
  hi("Delimiter",    { fg = "#73daca" })
  hi("Special",      { fg = "#ff9e64" })
  hi("PreProc",      { fg = "#bb9af7" })
  hi("Include",      { fg = "#7aa2f7" })
  hi("Define",       { fg = "#bb9af7" })
  hi("Error",        { fg = "#f7768e" })
  hi("Todo",         { fg = "#e0af68", bg = "NONE", bold = true })
  hi("WarningMsg",   { fg = "#e0af68" })
  hi("ErrorMsg",     { fg = "#f7768e" })

  -- Popup menu
  hi("Pmenu",        { bg = "#1a1b26", fg = "#c0caf5" })
  hi("PmenuSel",     { bg = "#364a82", fg = "#c0caf5" })
  hi("PmenuSbar",    { bg = "#1a1b26" })
  hi("PmenuThumb",   { bg = "#3b4261" })

  -- Search / Visual
  hi("Search",       { bg = "#3d59a1", fg = "#c0caf5" })
  hi("IncSearch",    { bg = "#ff9e64", fg = "#0d0d0d" })
  hi("Visual",       { bg = "#283457" })
end

-- Re-apply every time any colorscheme loads (prevents resets)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_highlights,
})

-- Load base colorscheme, then immediately apply our overrides
vim.cmd("colorscheme habamax")
apply_highlights()

-- Operator / punctuation colours
-- Match operator characters and colour them green.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("CustomOperator", [==[[-+*/%^&|~<>=!?.,:;@#]+]==])
  end,
})
vim.api.nvim_set_hl(0, "CustomOperator", { fg = "#73daca" })

-- Built-in file explorer (netrw)
vim.g.netrw_banner       = 0   -- no banner
vim.g.netrw_liststyle    = 3   -- tree view
vim.g.netrw_winsize      = 25  -- 25% width
vim.g.netrw_browse_split = 4   -- open files in the right window
vim.g.netrw_altv         = 1

-- Auto-open netrw on the LEFT, empty buffer on the RIGHT
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      -- Open the explorer on the left
      vim.cmd("Lexplore " .. arg)
      -- Open a new empty window on the right for editing
      vim.cmd("wincmd l")
      vim.cmd("enew")
    end
  end,
})

-- Toggle file explorer
vim.keymap.set("n", "<leader>e", ":Lexplore<CR>", { silent = true, desc = "Toggle file explorer" })

-- Autocompletion (buffer words + visible popup box)
opt.complete    = { ".", "b", "u" }  -- current buf, loaded bufs, unloaded bufs
opt.pumheight   = 12                 -- max rows shown in popup
opt.pumwidth    = 30                 -- min width of popup
-- noinsert: don't insert until confirmed — lets you see the box first
-- noselect: don't auto-highlight first item
opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Trigger popup once per keystroke (InsertCharPre fires exactly
-- once when a character is pressed, never on idle/timers).
vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    -- Don't trigger if popup is already open
    if vim.fn.pumvisible() == 1 then return end

    -- Only trigger on word characters (letters, digits, underscore)
    if not vim.v.char:match("[%w_]") then return end

    -- Skip if inside a comment or string syntax region
    local col = vim.fn.col(".")
    local syn = vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), col, 1), "name"):lower()
    if syn:match("comment") or syn:match("string") then return end

    vim.schedule(function()
      if vim.fn.pumvisible() == 0 then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<C-n>", true, false, true),
          "n", false
        )
      end
    end)
  end,
})

-- Arrow keys navigate the popup (fall through when popup is closed)
vim.keymap.set("i", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true, silent = true })

vim.keymap.set("i", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true, silent = true })

-- Tab / S-Tab also cycle through items
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, silent = true })

-- Enter confirms, Esc dismisses without inserting
vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, silent = true })

vim.keymap.set("i", "<Esc>", function()
  return vim.fn.pumvisible() == 1 and "<C-e>" or "<Esc>"
end, { expr = true, silent = true })

-- Keymaps
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<C-h>", "<C-w>h",           "Move to left window")
map("n", "<C-j>", "<C-w>j",           "Move to lower window")
map("n", "<C-k>", "<C-w>k",           "Move to upper window")
map("n", "<C-l>", "<C-w>l",           "Move to right window")

map("v", "J", ":m '>+1<CR>gv=gv",    "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv",    "Move selection up")

map("n", "<C-d>", "<C-d>zz",          "Scroll down centred")
map("n", "<C-u>", "<C-u>zz",          "Scroll up centred")
map("n", "n",     "nzzzv",            "Next search centred")
map("n", "N",     "Nzzzv",            "Prev search centred")

map("n", "Y", "y$",                   "Yank to EOL")

map("n", "<leader>w", ":w<CR>",       "Save")
map("n", "<leader>q", ":q<CR>",       "Quit")
map("n", "<leader>Q", ":qa!<CR>",     "Force quit all")

map("n", "<Esc>", ":nohlsearch<CR>",  "Clear highlights")
