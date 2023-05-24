local M = { }

local config = {
	use_symbols = true,
	symbols = {
		['c'] = '',
		['cs'] = '',
		['cuda'] = '',
		['cr'] = '',
		['crystal'] = '',
		['s'] = '',
		['S'] = '',
		['asm'] = '',
		['md'] = '',
		['go'] = '',
		['rs'] = '',
		['rust'] = '',
		['cpp'] = '',
		['lua'] = '',
		['py'] = '',
		['java'] = '',
		['ruby'] = '󰴭',
		['css'] = '',
		['hs'] = '',
		['js'] = '',
		['html'] = '',
		['htm'] = '',
		['d'] = '',
		['kotlin'] = ''
	},
	sep_left = '',
	sep_right ='',
	ro_symbol = "", --Default VIM on but done here to allow to be customised
	rw_symbol = "", --Again default vim to not show anything but give as a config option 

	colors = {
		ro_color = "red",
		rw_color = "green",
		left_seg_bg = "purple",
		left_seg_fg = "#f8f8f2",
		mid_seg_bg = "purple",
		mid_seg_fg = "#f8f8f2",
		right_seg_bg = "purple",
		right_seg_fg = "#f8f8f2",
	}
}

local function highlight(group, fg, bg) 
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

local function merge_configs(user_config) 
	config = vim.tbl_deep_extend("force", config, config, user_config)	
end

local function status_get_file_name() 
	local output = vim.api.nvim_buf_get_name(0) 
	
	if output == nil or output == "" then
		output = "No Name"
	end

	return "%t " 
end

local function status_buf_file_symbol() 
	local buf = vim.api.nvim_get_current_buf()
	if config.use_symbols == true and 
		vim.bo[buf].filetype and 
		config.symbols[string.lower(vim.bo[buf].filetype)] then 
		return config.symbols[string.lower(vim.bo[buf].filetype)]
  	end
	 
  	return vim.bo[buf].filetype
end

local function table_has_value(table, val)
	for index, value in ipairs(table) do 
		if value == val then 
			return true 
		end
	end
	return false
	
end

local function status_get_current_buf_lsp() 
	---------
	--HACK: TODO look at nvim.lsp more as this current method is kinda gross maybe there is a better way?
	--Cat 
	---------
	local buf = vim.api.nvim_get_current_buf() 
	local servers = vim.lsp.get_active_clients()
	for t in pairs(servers) do	
		local buffers = vim.lsp.get_buffers_by_client_id(servers[t].id) 
		if table_has_value(buffers, buf) then
			return servers[t].name
		end
	end

	return "None"
end

local function status_buf_is_readonly() 
	local buf = vim.api.nvim_get_current_buf() 
	if vim.bo[buf].readonly then
		return "%#KstatusRO#" .. config.ro_symbol .. "%#KstatusLeft#"
	else 
		return "%#KstatusRW#" .. config.rw_symbol .. "%#KstatusLeft#"
	end
end

local function status_buf_get_fileformat() 
	if config.use_symbols then
		if vim.bo.fileformat == "unix" then 
			return ''
		elseif vim.bo.fileformat == "mac" then
			return ''
		elseif vim.bo.fileformat == "dos" then
			return ''
		end
	end
	return vim.bo.fileformat
	
end

function create_status_string() 
	local statusline = "%#KstatusLeft#" .. status_get_file_name() .. "" .. status_buf_is_readonly() .. "%m %#KstatusLeftEnd#" ..  config.sep_left .. " " .. status_buf_get_fileformat() .. "%=" .. config.sep_right .. "%#KstatusMid# " .. status_buf_file_symbol() .. " Language Server: " .. status_get_current_buf_lsp() .. " %#KstatusMidEnd#" .. config.sep_left ..  "%=" .. config.sep_right .."%#KstatusRight# [%c,%l] %p%% "

	return statusline
end

local function status_setup(user_config)
	merge_configs(user_config)

	highlight("KstatusLeft", config.colors.left_seg_fg, config.colors.left_seg_bg)
	highlight("KstatusRO", config.colors.ro_color, config.colors.left_seg_bg)
	highlight("KstatusRW", config.colors.rw_color, config.colors.left_seg_bg)
	highlight("KstatusLeftEnd", config.colors.left_seg_bg, "NONE")
	highlight("KstatusMid", config.colors.mid_seg_fg, config.colors.left_seg_bg)
	highlight("KstatusMidEnd", config.colors.mid_seg_bg, "NONE")
	highlight("KstatusRight", config.colors.right_seg_fg, config.colors.left_seg_bg)
	highlight("KstatusRightEnd", config.colors.right_seg_bg, "NONE")
	
	vim.o.statusline = "%!luaeval('create_status_string()')"
end

M = {
	setup = status_setup,
}


return M
