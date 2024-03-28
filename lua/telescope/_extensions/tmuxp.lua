local tmuxp = require("tmuxp")
local ok, telescope = pcall(require, "telescope")

if not ok then
	error("Install nvim-telescope/telescope.nvim to use mrlys/tmuxp.nvim.")
end

return require("telescope").register_extension({
	setup = function(ext_config, config)
		print("setting up telescope extension")
	end,
	exports = {
		list = function()
			tmuxp.list()
		end,
	},
})
