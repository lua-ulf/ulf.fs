local types = require("ulf.lib.types")
local dict = require("ulf.lib.obj.dict")

describe("#ulf.lib.types", function()
	it("types.is_array", function()
		assert.True(types.is_array({}))
		assert.True(types.is_array({ "a", "b", "c" }))
		assert.False(types.is_array(dict.empty_dict()))
		assert.False(types.is_array({ "a", "32", a = "hello", b = "baz" }))
		assert.False(types.is_array({ 1, a = "hello", b = "baz" }))
		assert.False(types.is_array({ a = "hello", b = "baz", 1 }))
		assert.False(types.is_array({ 1, 2, nil, a = "hello" }))
		assert.True(types.is_array({ 1, 2, nil, 4 }))
		assert.True(types.is_array({ nil, 2, 3, 4 }))
		assert.False(types.is_array({ 1, [1.5] = 2, [3] = 3 }))
	end)

	it("types.is_list", function()
		assert.True(types.is_list({}))
		assert.True(types.is_list({ "a", "b", "c" }))
		assert.False(types.is_list(dict.empty_dict()))
		assert.False(types.is_list({ "a", "32", a = "hello", b = "baz" }))
		assert.False(types.is_list({ 1, a = "hello", b = "baz" }))
		assert.False(types.is_list({ a = "hello", b = "baz", 1 }))
		assert.False(types.is_list({ 1, 2, nil, a = "hello" }))
		assert.False(types.is_list({ 1, 2, nil, 4 }))
		assert.False(types.is_list({ nil, 2, 3, 4 }))
		assert.False(types.is_list({ 1, [1.5] = 2, [3] = 3 }))
	end)

	it("types.is_callable", function()
		assert.True(types.is_callable(function() end))
		assert.True((function()
			local meta = { __call = function() end }
			local function new_callable()
				return setmetatable({}, meta)
			end
			local callable = new_callable()
			return types.is_callable(callable)
		end)())

		assert.same(
			{ false, false },
			(function()
				local meta = { __call = {} }
				assert(meta.__call)
				local function new()
					return setmetatable({}, meta)
				end
				local not_callable = new()
				return { pcall(function()
					not_callable()
				end), types.is_callable(not_callable) }
			end)()
		)

		assert.same(
			{ false, false },
			(function()
				local function new()
					return { __call = function() end }
				end
				local not_callable = new()
				assert(not_callable.__call)
				return { pcall(function()
					not_callable()
				end), types.is_callable(not_callable) }
			end)()
		)
		assert.same(
			{ false, false },
			(function()
				local meta = setmetatable(
					{ __index = { __call = function() end } },
					{ __index = { __call = function() end } }
				)
				assert(meta.__call)
				local not_callable = setmetatable({}, meta)
				assert(not_callable.__call)
				return { pcall(function()
					not_callable()
				end), types.is_callable(not_callable) }
			end)()
		)
		assert.same(
			{ false, false },
			(function()
				local meta = setmetatable({
					__index = function()
						return function() end
					end,
				}, {
					__index = function()
						return function() end
					end,
				})
				assert(meta.__call)
				local not_callable = setmetatable({}, meta)
				assert(not_callable.__call)
				return { pcall(function()
					not_callable()
				end), types.is_callable(not_callable) }
			end)()
		)
		assert.False(types.is_callable(1))
		assert.False(types.is_callable("foo"))
		assert.False(types.is_callable({}))
	end)
end)
