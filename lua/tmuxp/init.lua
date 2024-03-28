local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local sorters = require("telescope.sorters")

local function get_cmd()
	return "tmuxp shell -c \"[print((w.name, w.id, s['name'])) for s in [{'name': session.name, 'session': session}  for session in server.sessions] for w in s['session'].list_windows()]\""
end

local function parse_line(line)
	local name, id, session = line:match("%('([^']+)', '([^']+)', '([^']+)'%)")
	return { name = name, id = id, session = session, index = id }
end

local M = {}
M.switch_to_window = function(window_name)
	-- [(w.name, w.id, s[1].name) for s in [(session.name, session) for session in server.sessions] for w in s[1].list_windows()]
	vim.cmd("!tmuxp shell -c \"server.cmd('switch', '-t', '" .. window_name .. "')\"")
end

local entry_maker = function(entry)
	return { value = entry, index = entry.index, display = entry.name, ordinal = vim.inspect(entry) }
end

M.list = function()
	local opts = {}
	opts.entry_maker = entry_maker
	pickers
		.new(opts, {
			prompt_title = "Tmux Sessions & Windows",
			finder = finders.new_table({
				results = M.list_windows(),
				entry_maker = opts.entry_maker,
			}),
			sorter = sorters.get_fzy_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					M.switch_to_window(selection.value.id)
				end)
				return true
			end,
		})
		:find()
end

M.list_windows = function()
	local result
	local handle = io.popen(get_cmd())
	if handle == nil then
		print("handle is nil")
		return
	else
		result = handle:read("*a")
		handle:close()
	end
	local lines = vim.split(result, "\n")

	-- Function to parse each line

	-- Create the desired structure
	result = {}
	for i, line in ipairs(lines) do
		if line ~= "" then
			table.insert(result, parse_line(line, i))
		end
	end
	return result
end
return M
