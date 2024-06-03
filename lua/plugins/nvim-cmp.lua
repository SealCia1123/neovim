---@diagnostic disable: missing-fields
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "lukas-reineke/cmp-under-comparator",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua",
        "lukas-reineke/cmp-rg",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        {
            "onsails/lspkind-nvim",
            config = function()
                require("lspkind").init()
            end,
        },
    },

    require("cmp").setup({
        sources = {
            { name = "nvim_lsp_signature_help" },
        },
    }),
    config = function()
        local cmp = require("cmp")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local cmp_kinds = {
            Text = " ",
            Method = " ",
            Function = " ",
            Constructor = " ",
            Field = " ",
            Variable = " ",
            Class = " ",
            Interface = " ",
            Module = " ",
            Property = " ",
            Unit = " ",
            Value = " ",
            Enum = " ",
            Keyword = " ",
            Snippet = " ",
            Color = " ",
            File = " ",
            Reference = " ",
            Folder = " ",
            EnumMember = " ",
            Constant = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
        }
        local fixed_width = 35
        cmp.setup({
            preselect = cmp.PreselectMode.None,

            view = {
                docs = {
                    auto_open = false,
                },
                entries = { name = "custom", selection_order = "near_cursor" },
            },

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                -- { name = "nvim_lsp_signature_help" },
            }, {
                { name = "luasnip" },
                { name = "buffer" },
            }),
            formatting = {
                fields = { "abbr", "menu", "kind" },
                format = function(entry, item)
                    -- Define menu shorthand for different completion sources.
                    local menu_icon = {
                        nvim_lsp = "NLSP",
                        nvim_lua = "NLUA",
                        luasnip = "LSNP",
                        buffer = "BUFF",
                        path = "PATH",
                    }
                    -- Set the menu "icon" to the shorthand for each completion source.
                    item.menu = menu_icon[entry.source.name]

                    -- Set the fixed width of the completion menu to 60 characters.
                    -- fixed_width = 20

                    -- Set 'fixed_width' to false if not provided.
                    fixed_width = fixed_width or false

                    -- Get the completion entry text shown in the completion window.
                    local content = item.abbr

                    -- Set the fixed completion window width.
                    if fixed_width then
                        vim.o.pumwidth = fixed_width
                    end

                    -- Get the width of the current window.
                    local win_width = vim.api.nvim_win_get_width(0)

                    -- Set the max content width based on either: 'fixed_width'
                    -- or a percentage of the window width, in this case 20%.
                    -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
                    local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

                    -- Truncate the completion entry text if it's longer than the
                    -- max content width. We subtract 3 from the max content width
                    -- to account for the "..." that will be appended to it.
                    if #content > max_content_width then
                        item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
                    else
                        item.abbr = content .. (" "):rep(max_content_width - #content)
                    end
                    return item
                end,
            },
            -- formatting = {
            --     fields = { "abbr", "kind", "menu" },
            --
            --     format = function(entry, item)
            --         local menu_icon = {
            --             nvim_lsp = "NLSP",
            --             luasnip = "LSNP",
            --             buffer = "BUFF",
            --             path = "PATH",
            --             -- nvim_lua = "NLUA",
            --         }
            --         item.menu = menu_icon[entry.source.name]
            --         item.kind = cmp_kinds[item.kind] or ""
            --         fixed_width = fixed_width or false
            --         local content = item.abbr
            --         if fixed_width then
            --             vim.o.pumwidth = fixed_width
            --         end
            --         local win_width = vim.api.nvim_win_get_width(0)
            --         local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)
            --         if #content > max_content_width then
            --             item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
            --         else
            --             item.abbr = content .. (" "):rep(max_content_width - #content)
            --         end
            --         return item
            -- expandable_indicator = false,
            --     end,
            -- },

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = {
                    side_padding = 0,
                },
                documentation = {
                    max_width = 30,
                    max_height = 15,
                },
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-g>"] = cmp.mapping.open_docs(),
            }),
        })
        -- Set configuration for specific filetype.
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
                { name = "buffer" },
            }),
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
