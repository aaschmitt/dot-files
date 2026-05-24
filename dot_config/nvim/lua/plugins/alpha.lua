return {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.startify")

        alpha.setup(dashboard.opts)
    end,
}
