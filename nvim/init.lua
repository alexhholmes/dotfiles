vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.termguicolors = true

vim.diagnostic.config({ virtual_lines = true })
vim.opt.showtabline = 0
vim.opt.laststatus = 3

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#777777" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", fg = "#444444" })
vim.api.nvim_set_hl(0, "SLMode", { bg = "#425262", fg = "#ffffff" })

-- Tabs and indenting
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true
vim.opt.hidden = true

-- System clipboard
vim.opt.clipboard = 'unnamed'

-- Disable auto-wrapping
vim.opt.formatoptions:remove('t')

-- NvimTree: remove ~ on blank lines
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'NvimTree',
    callback = function()
        vim.opt_local.fillchars = { eob = " " }
    end,
})

-- Git commit: subject 50 chars, body 72 chars
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    callback = function()
        vim.opt_local.textwidth = 72
        vim.opt_local.colorcolumn = '50,72'
    end,
})

-- Close NvimTree before session save so it doesn't restore broken
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        require("nvim-tree.api").tree.close_in_all_tabs()
    end,
})

-- On session restore, open a fresh NvimTree
vim.api.nvim_create_autocmd("SessionLoadPost", {
    callback = function()
        vim.schedule(function()
            local api = require("nvim-tree.api")
            api.tree.close_in_all_tabs()
            api.tree.open()
        end)
    end,
})

--
--

-- LSP
if vim.fn.executable("gopls") == 1 then
    vim.lsp.config("gopls", {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
    })
    vim.lsp.enable("gopls")
end

if vim.fn.executable("lua-language-server") == 1 then
    vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    })
    vim.lsp.enable("lua_ls")
end

--
--

-- <C-i>: insert single character
vim.keymap.set('n', '<C-i>', 'i_<Esc>r')

vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>',  { desc = "New tab" })
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<CR>', { desc = "Close tab" })


-- Undo tree (built-in opt pack, nvim 0.12+)
vim.cmd("packadd nvim.undotree")
local _undotree_path = vim.api.nvim_get_runtime_file("lua/undotree.lua", false)[1]
if _undotree_path then
    package.preload["undotree"] = function() return dofile(_undotree_path) end
end
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Undo tree" })

-- Disable yank on delete
vim.keymap.set({ 'n', 'v' }, 'd', '"_d')
vim.keymap.set({ 'n', 'v' }, 'D', '"_D')

--
--

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "folke/persistence.nvim",
            event = "BufReadPre",
            opts = {},
            keys = {
                { "<leader>qs", function() require("persistence").load() end,                desc = "Load session" },
                { "<leader>qS", function() require("persistence").select() end,              desc = "Select session" },
                { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
                { "<leader>qd", function() require("persistence").stop() end,                desc = "Stop session saving" },
            },
        },
        {
            "folke/ts-comments.nvim",
            opts = {},
            event = "VeryLazy",
            enabled = vim.fn.has("nvim-0.10.0") == 1,
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                preset = modern,
                filter = function(mapping)
                    return mapping.desc and mapping.desc ~= ""
                end,
                expand = 1,
                win = {
                    border = "rounded",
                },
                spec = {
                    { "<leader>e", group = "explorer" },
                    { "<leader>f", group = "find" },
                    { "<leader>h", group = "git hunks" },
                    { "<leader>l", group = "lsp" },
                    { "<leader>q", group = "session" },
                    { "<leader>t", group = "tabs" },
                },
                icons = {
                    mappings = false,
                    keys = {
                        Esc = "Esc",
                        BS = "BS",
                        Space = "Space",
                        Tab = "Tab",
                        CR = "CR",
                        NL = "NL",
                        Up = "Up",
                        Down = "Down",
                        Left = "Left",
                        Right = "Right",
                        C = "C-",
                        M = "M-",
                        D = "D-",
                        S = "S-",
                        ScrollWheelDown = "ScrollDn",
                        ScrollWheelUp = "ScrollUp",
                    },
                },
            },
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                cmp.setup({
                    snippet = {
                        expand = function(args) luasnip.lsp_expand(args.body) end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-e>"] = cmp.mapping.abort(),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "nvim_lsp_signature_help" },
                        { name = "nvim_lua" },
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "path" },
                    }),
                })

                -- Completion in / search
                cmp.setup.cmdline("/", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = { { name = "buffer" } },
                })

                -- Completion in : command mode
                cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources(
                        { { name = "path" } },
                        { { name = "cmdline" } }
                    ),
                })
            end,
        },
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPre", "BufNewFile" },
            opts = {
                current_line_blame = false,
                on_attach = function(bufnr)
                    local gs = require("gitsigns")
                    local function map(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end, "Next hunk")
                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end, "Prev hunk")

                    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
                    map("n", "<leader>hd", gs.diffthis, "Diff this")
                    map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                    map("n", "<leader>b", gs.toggle_current_line_blame, "Toggle inline blame")

                    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                        "Stage hunk (visual)")
                    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                        "Reset hunk (visual)")
                    map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
                end,
            },
        },
        {
            "nvim-telescope/telescope.nvim",
            version = "*",
            event = "VeryLazy",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
            config = function()
                local telescope    = require("telescope")
                local builtin      = require("telescope.builtin")
                local actions      = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                telescope.setup({
                    defaults = {
                        vimgrep_arguments = {
                            "rg", "--color=never", "--no-heading", "--with-filename",
                            "--line-number", "--column", "--smart-case",
                        },
                        file_ignore_patterns = { "%.git/", "node_modules/", "vendor/" },
                    },
                    extensions = {
                        fzf = {
                            fuzzy = true,
                            override_generic_sorter = true,
                            override_file_sorter = true,
                            case_mode = "smart_case",
                        },
                    },
                })
                telescope.load_extension("fzf")

                local map = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { desc = desc })
                end

                local add_to_buflist = function(prompt_bufnr)
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    for _, entry in ipairs(picker:get_multi_selection()) do
                        vim.cmd("badd " .. entry.path)
                    end
                    actions.close(prompt_bufnr)
                end

                map("<leader>ff", function()
                    builtin.find_files({
                        attach_mappings = function(_, map_action)
                            map_action("i", "<C-b>", add_to_buflist)
                            map_action("n", "<C-b>", add_to_buflist)
                            return true
                        end,
                    })
                end, "Find files")
                map("<leader>fg", builtin.live_grep, "Live grep")
                map("<leader>fb", builtin.buffers, "Buffers")
                map("<leader>fo", builtin.oldfiles, "Recent files")
                map("<leader>lr", builtin.lsp_references, "LSP references")
                map("<leader>ls", builtin.lsp_document_symbols, "LSP document symbols")
                map("<leader>lw", builtin.lsp_dynamic_workspace_symbols, "LSP workspace symbols")
                map("<leader>ld", function() builtin.diagnostics({ bufnr = 0 }) end, "Diagnostics (buffer)")
                map("<leader>lD", builtin.diagnostics, "Diagnostics (workspace)")
            end,
        },
        {
            "nvim-tree/nvim-tree.lua",
            keys = {
                { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File explorer" },
            },
            opts = {
                tab = {
                    sync = {
                        open  = true,
                        close = true,
                    },
                },
                filters = { dotfiles = false },
                git = { enable = true, ignore = false },
                renderer = {
                    icons = {
                        show = {
                            file = false,
                            folder = false,
                            folder_arrow = true,
                            git = true,
                        },
                        glyphs = {
                            folder = { arrow_closed = "▸", arrow_open = "▾" },
                            git = {
                                unstaged  = "~",
                                staged    = "+",
                                unmerged  = "!",
                                renamed   = "»",
                                untracked = "?",
                                deleted   = "-",
                                ignored   = "◌",
                            },
                        },
                    },
                },
            },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            main = "nvim-treesitter.config",
            opts = {
                ensure_installed = {
                    "go", "lua", "python", "bash", "json", "yaml",
                    "html", "css", "javascript", "typescript", "tsx",
                    "toml", "dockerfile", "markdown", "markdown_inline",
                    "sql", "regex", "git_config", "git_commit", "gitignore",
                    "hcl", "terraform", "latex", "proto",
                },
                highlight = { enable = true },
                indent = { enable = true },
            },
        },
        {
            "stevearc/conform.nvim",
            event = "BufWritePre",
            opts = {
                formatters_by_ft = {
                    go              = { "goimports", "gofmt" },
                    typescript      = { "prettier" },
                    typescriptreact = { "prettier" },
                    javascript      = { "prettier" },
                    javascriptreact = { "prettier" },
                    terraform       = { "terraform_fmt" },
                    tf              = { "terraform_fmt" },
                    lua             = { "stylua" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
            },
        },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = function()
                local autopairs = require("nvim-autopairs")
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                local cmp = require("cmp")

                autopairs.setup({ check_ts = true })
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end,
        },
    },
    checker = { enabled = true },
    rocks = { hererocks = false },
    install = { colorscheme = {} },
    ui = {
        icons = {
            cmd = "[cmd]",
            config = "[cfg]",
            event = "[event]",
            ft = "[ft]",
            init = "[init]",
            keys = "[keys]",
            plugin = "[plugin]",
            runtime = "[rt]",
            require = "[req]",
            source = "[src]",
            start = "[start]",
            task = "[task]",
            lazy = "[lazy]",
            close = "x",
            back = "<",
        },
    },
})

--
--

-- Statusline
local modes = {
    ["n"]   = "NORMAL",
    ["no"]  = "NORMAL",
    ["v"]   = "VISUAL",
    ["V"]   = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["i"]   = "INSERT",
    ["ic"]  = "INSERT",
    ["R"]   = "REPLACE",
    ["Rv"]  = "V-REPLACE",
    ["c"]   = "COMMAND",
    ["s"]   = "SELECT",
    ["S"]   = "S-LINE",
    ["\19"] = "S-BLOCK",
    ["t"]   = "TERMINAL",
}

local function sl_mode()
    local m = vim.api.nvim_get_mode().mode
    return "%#SLMode# " .. (modes[m] or m) .. " %#StatusLine#"
end

local function sl_filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
    if fpath == "" or fpath == "." then return " " end
    return string.format(" %%<%s/", fpath)
end

local function sl_filename()
    local fname = vim.fn.expand("%:t")
    if fname == "" then return "" end
    return fname .. " "
end


local function sl_git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then return "" end
    local added   = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
    local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
    local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
    if git_info.added == 0 then added = "" end
    if git_info.changed == 0 then changed = "" end
    if git_info.removed == 0 then removed = "" end
    return table.concat({
        " ", added, changed, removed, " ",
        "%#GitSignsAdd# ", git_info.head, " %#StatusLine#",
    })
end

local function sl_filetype()
    local ft = vim.bo.filetype
    if ft == "" then return "" end
    return string.format(" %s ", ft:upper())
end

local function sl_lineinfo()
    return " %P %l:%c "
end

Statusline = { _last = "" }

function Statusline.active()
    if vim.bo.filetype == "NvimTree" then
        return Statusline._last
    end
    Statusline._last = table.concat({
        sl_mode(),
        sl_filepath(),
        sl_filename(),
        "%=",
        sl_git(),
        sl_filetype(),
        sl_lineinfo(),
    })
    return Statusline._last
end

function Statusline.inactive()
    return table.concat({
        " %F ",
        "%=",
        sl_filetype(),
        sl_lineinfo(),
    })
end

vim.api.nvim_exec2([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    augroup END
]], {})

-- Winbar (per-window tab display, skips NvimTree)
function Winbar()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = nil
        for _, b in ipairs(buflist) do
            if vim.bo[b].filetype ~= "NvimTree" then
                bufnr = b
                break
            end
        end
        if not bufnr then goto continue end
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
        if name == "" then name = "[No Name]" end
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel# " .. name .. " "
        else
            s = s .. "%#TabLine# " .. name .. " "
        end
        ::continue::
    end
    return s .. "%#TabLineFill#"
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        if vim.bo.filetype == "NvimTree" then
            vim.opt_local.winbar = ""
        else
            vim.opt_local.winbar = "%!v:lua.Winbar()"
        end
    end,
})
