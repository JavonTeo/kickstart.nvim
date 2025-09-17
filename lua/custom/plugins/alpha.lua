return {
    'goolord/alpha-nvim',
    dependencies = {
        -- 'echasnovski/mini.icons',
        'nvim-tree/nvim-web-devicons',
        'MaximilianLloyd/ascii.nvim', -- use ascii.nvim for nice ascii header graphics
    },

    -- uncomment the theme you want to use

    -- startify theme
    -- config = function()
    -- 	local startify = require 'alpha.themes.startify'
    -- 	-- available: devicons, mini, default is mini
    -- 	-- if provider not loaded and enabled is true, it will try to use another provider
    -- 	startify.file_icons.provider = 'devicons'
    -- 	require('alpha').setup(startify.config)
    -- end,

    -- theta theme
    config = function()
        local alpha = require 'alpha'
        local theta = require 'alpha.themes.theta'
        local ascii = require 'ascii'

        -- THIS IS NOT WORKING
        -- overwrite header
        theta.config.layout[1].val = ascii.art.planets.earth
        -- theta.header.val = ascii.art.planets.earth

        alpha.setup(theta.config)
    end,

    -- -- dashboard theme
    -- config = function()
    --     require('alpha').setup(require('alpha.themes.dashboard').config)
    -- end,
}
