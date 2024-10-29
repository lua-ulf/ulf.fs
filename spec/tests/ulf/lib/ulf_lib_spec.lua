require("ulf.util.debug")._G()

local instanceof = require("ulf.lib.obj.instanceof").instanceof

---@alias ulf.test.dsl.ExportsTable {[string]:ulf.test.dsl.Exports}

---@class ulf.test.dsl.Exports
---@field type? 'function'|'table'|'string'|'boolean'|'number'|'thread'
---@field exports? {[string]:ulf.test.dsl.Exports}

---@type ulf.test.dsl.Exports
local WantedExports = {
	type = "table",
	exports = {

		lib = {
			type = "table",

			exports = {

				-- ArgParser = { type = "table" },
				-- Emitter = { type = "table" },
				-- Object = { type = "table" },
				-- empty_dict = { type = "function" },
				-- empty_dict_mt = { type = "table" },
				pathvar_sep = { type = "string" },
				path_sep = { type = "string" },
				-- isvim = { type = "function" },
				-- iswin = { type = "function" },

				-- sub modules
				obj = {
					exports = {
						Emitter = { type = "table" },
						Object = { type = "table" },
						empty_dict = { type = "function" },
						empty_dict_mt = { type = "table" },
						instanceof = { type = "function" },
					},

					type = "table",
				},

				string = {
					exports = {
						split = { type = "function" },
						gsplit = { type = "function" },
						escape = { type = "function" },
						pesc = { type = "function" },
						title = { type = "function" },
						startswith = { type = "function" },
						endswith = { type = "function" },
						trim = { type = "function" },
					},

					type = "table",
				},
				types = {
					exports = {
						is_callable = { type = "function" },
						is_list = { type = "function" },
						is_array = { type = "function" },
					},

					type = "table",
				},
				git = {
					exports = {
						root = { type = "table", exports = {
							get = { type = "function" },
						} },
					},
					type = "table",
				},
				table = {
					exports = {
						-- compat names
						tbl_contains = { type = "function" },
						tbl_count = { type = "function" },
						tbl_deep_extend = { type = "function" },
						tbl_extend = { type = "function" },
						tbl_filter = { type = "function" },
						tbl_get = { type = "function" },
						tbl_isempty = { type = "function" },
						tbl_keys = { type = "function" },
						tbl_map = { type = "function" },
						tbl_values = { type = "function" },

						-- better names
						contains = { type = "function" },
						count = { type = "function" },
						deep_equal = { type = "function" },
						deep_extend = { type = "function" },
						deepcopy = { type = "function" },
						extend = { type = "function" },
						filter = { type = "function" },
						get = { type = "function" },
						isempty = { type = "function" },
						keys = { type = "function" },
						list_contains = { type = "function" },
						list_extend = { type = "function" },
						list_slice = { type = "function" },
						map = { type = "function" },
						spairs = { type = "function" },
						validate = { type = "function" },
						values = { type = "function" },
					},
					type = "table",
				},
			},
		},
	},
}

local validator = {}
local f = string.format

---Validates each node of module `mod`. The structure of spec and mod is the same
---so that mod[key] == spec[key]
---
---@param mod table
---@param parent string[]
---@param spec ulf.test.dsl.Exports
validator.module_exports = function(mod, parent, spec)
	local parent_path = table.concat(parent, ".")
	for symbol_name, symbol_spec in pairs(spec.exports) do
		local desc = f("exports %s.%s as type '%s'", parent_path, symbol_name, symbol_spec.type)
		it(desc, function()
			assert(mod[symbol_name])
		end)

		if symbol_spec.type == "table" and symbol_spec.exports then
			-- Create a new path for child nodes. Copy not REF!
			local child_nodes = { table.unpack(parent) }
			table.insert(child_nodes, symbol_name)
			validator.module_exports(mod[symbol_name], child_nodes, symbol_spec)
		end
	end
end

describe("#ulf.lib", function()
	local ulf = {}
	ulf.lib = require("ulf.lib")

	describe("module", function()
		validator.module_exports(ulf, { "ulf" }, WantedExports)
	end)
end)
