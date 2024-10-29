---@type table
local luacache = (_G.__luacache or {}).cache ---@diagnostic disable-line:undefined-field

local function delete_module(mod)
	package.loaded["ulf.lib.types.type_lib"] = nil ---@diagnostic disable-line: no-unknown
	if luacache then
		luacache["ulf.lib.types.type_lib"] = nil ---@diagnostic disable-line: no-unknown
	end
end

describe("#ulf.lib.module.reloader", function()
	describe("reload.unload", function()
		it("unloads a loaded module", function()
			local reload = require("ulf.lib.module.reloader")

			delete_module("ulf.lib.types.type_lib")
			assert.Nil(package.loaded["ulf.lib.types.type_lib"])

			if luacache then
				assert.Nil(luacache["ulf.lib.types.type_lib"])
			end

			require("ulf.lib.types.type_lib")
			assert(package.loaded["ulf.lib.types.type_lib"])
			reload.unload("ulf.lib.types.type_lib")
			assert.Nil(package.loaded["ulf.lib.types.type_lib"])

			if luacache then
				assert.Nil(luacache["ulf.lib.types.type_lib"])
			end
		end)

		it("calls reload.matcher_fact", function()
			local reload = require("ulf.lib.module.reloader")
			-- stub(reload, "matcher_fact")
			local spy_matcher_fact = spy.on(reload, "matcher_fact")

			reload.unload("ulf.lib.types.type_lib")
			assert.spy(spy_matcher_fact).was.called_with("ulf.lib.types.type_lib", true)
			spy_matcher_fact:clear()

			reload.unload("ulf.lib.types.type_lib", true)
			assert.spy(spy_matcher_fact).was.called_with("ulf.lib.types.type_lib", true)
			spy_matcher_fact:clear()

			reload.unload("ulf.lib.types.type_lib", false)
			assert.spy(spy_matcher_fact).was.called_with("ulf.lib.types.type_lib", false)
		end)

		-- it("calls _string.pesc", function()
		-- 	delete_module("ulf.lib.module.reloader")
		-- 	delete_module("ulf.lib.string.escape")
		-- 	local escape = require("ulf.lib.string.escape")
		-- 	local spy_pesc = spy.on(escape, "pesc")
		-- 	-- P({
		-- 	-- 	"!!!!!!!!!!!!!!!!!!",
		-- 	-- 	escape = escape,
		-- 	-- 	spy_pesc = spy_pesc,
		-- 	-- })
		-- 	-- local reload = require("ulf.lib.module.reloader")
		-- 	-- --
		-- 	-- reload.unload("ulf.lib.types", true)
		-- 	-- assert.spy(spy_pesc).was.called_with("ulf.lib.types")
		-- end)
		--
		-- it("calls reload.del_module", function()
		-- 	delete_module("ulf.lib.module.reloader")
		-- 	local reload = require("ulf.lib.module.reloader")
		-- 	local spy_matcher_fact = spy.on(reload, "matcher_fact")
		-- 	local spy_del_module = spy.on(reload, "del_module")
		--
		-- 	local matcher = reload.matcher_fact("ulf.lib.types", true)
		-- 	reload.unload("ulf.lib.types", true)
		-- 	local returnvals = spy_del_module.returnvals
		-- 	P({
		-- 		"!!!!!!!!!!!!!!!!!!!!!!!!!!!",
		-- 		-- spy_del_module = spy_del_module,
		-- 		spy_matcher_fact = spy_matcher_fact,
		-- 		matcher = matcher,
		-- 		returnvals_1 = returnvals[1],
		-- 	})
		-- 	--
		-- 	local matcher = returnvals[1].refs[1]
		-- 	assert.spy(spy_del_module).was.called_with(matcher, nil)
		-- end)
	end)

	describe("reload.reload", function()
		it("reload.reload", function()
			-- P(package.loaded["ulf.lib.types.type_lib"])
			delete_module("ulf.lib.types.type_lib")
			assert.Nil(package.loaded["ulf.lib.types.type_lib"])

			local reload = require("ulf.lib.module.reloader")
			require("ulf.lib.types.type_lib")
			assert(package.loaded["ulf.lib.types.type_lib"])
			package.loaded["ulf.lib.types.type_lib"].PATCHED = 1
			assert(package.loaded["ulf.lib.types.type_lib"].PATCHED)
			reload.reload("ulf.lib.types.type_lib")
			assert(package.loaded["ulf.lib.types.type_lib"])
			assert.Nil(package.loaded["ulf.lib.types.type_lib"].PATCHED)
		end)
	end)
end)
