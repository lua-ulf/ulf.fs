local str = require("ulf.lib.string")

local t = require("spec.testutil")
local eq = t.eq
local matches = t.matches
local pcall_err = t.pcall_err

describe("#ulf.lib.string", function()
	it("escape", function()
		assert.are.equal(str.escape("plain", {}), "plain")
		assert.are.equal(str.escape("plain\\", {}), "plain\\\\")
		assert.are.equal(str.escape('plain\\"', {}), 'plain\\\\"')
		assert.are.equal(str.escape('pla"in', { '"' }), 'pla\\"in')
		assert.are.equal(str.escape('call("")', { '"' }), 'call(\\"\\")')
	end)
	it("str.pesc", function()
		assert.equal("foo%-bar", str.pesc("foo-bar"))
		assert.equal("foo%%%-bar", str.pesc(str.pesc("foo-bar")))
		-- pesc() returns one result. #20751
		assert.same({ "x" }, { str.pesc("x") })

		-- Validates args.
		matches(
			"s: expected string, got number",
			pcall_err(function()
				return str.pesc(2) ---@diagnostic disable-line:param-type-mismatch
			end)
		)
	end)
	it("str.startswith", function()
		assert.True(str.startswith("123", "1"))
		assert.True(str.startswith("123", ""))
		assert.True(str.startswith("123", "123"))
		assert.True(str.startswith("", ""))

		assert.False(str.startswith("123", " "))
		assert.False(str.startswith("123", "2"))
		assert.False(str.startswith("123", "1234"))

		matches(
			"prefix: expected string, got nil",
			pcall_err(function()
				return str.startswith("123", nil) ---@diagnostic disable-line:param-type-mismatch
			end)
		)
		matches(
			"s: expected string, got nil",
			pcall_err(function()
				return str.startswith(nil, "123") ---@diagnostic disable-line:param-type-mismatch
			end)
		)
	end)

	it("str.endswith", function()
		assert.True(str.endswith("123", "3"))
		assert.True(str.endswith("123", ""))
		assert.True(str.endswith("123", "123"))
		assert.True(str.endswith("", ""))

		assert.False(str.endswith("123", " "))
		assert.False(str.endswith("123", "2"))
		assert.False(str.endswith("123", "1234"))

		matches(
			"suffix: expected string, got nil",
			pcall_err(function()
				return str.endswith("123", nil) ---@diagnostic disable-line:param-type-mismatch
			end)
		)
		matches(
			"s: expected string, got nil",
			pcall_err(function()
				return str.endswith(nil, "123") ---@diagnostic disable-line:param-type-mismatch
			end)
		)
	end)

	it("vim.gsplit, vim.split", function()
		local tests = {
			--                            plain  trimempty
			{ "a,b", ",", false, false, { "a", "b" } },
			{ ":aa::::bb:", ":", false, false, { "", "aa", "", "", "", "bb", "" } },
			{ ":aa::::bb:", ":", false, true, { "aa", "", "", "", "bb" } },
			{ "aa::::bb:", ":", false, true, { "aa", "", "", "", "bb" } },
			{ ":aa::bb:", ":", false, true, { "aa", "", "bb" } },
			{ "/a/b:/b/\n", "[:\n]", false, true, { "/a/b", "/b/" } },
			{ "::ee::ff:", ":", false, false, { "", "", "ee", "", "ff", "" } },
			{ "::ee::ff::", ":", false, true, { "ee", "", "ff" } },
			{ "ab", ".", false, false, { "", "", "" } },
			{ "a1b2c", "[0-9]", false, false, { "a", "b", "c" } },
			{ "xy", "", false, false, { "x", "y" } },
			{ "here be dragons", " ", false, false, { "here", "be", "dragons" } },
			{ "axaby", "ab?", false, false, { "", "x", "y" } },
			{ "f v2v v3v w2w ", "([vw])2%1", false, false, { "f ", " v3v ", " " } },
			{ "", "", false, false, {} },
			{ "", "", false, true, {} },
			{ "\n", "[:\n]", false, true, {} },
			{ "", "a", false, false, { "" } },
			{ "x*yz*oo*l", "*", true, false, { "x", "yz", "oo", "l" } },
		}

		for _, q in ipairs(tests) do
			eq(q[5], str.split(q[1], q[2], { plain = q[3], trimempty = q[4] }), q[1])
		end

		-- Test old signature
		-- eq({ 'x', 'yz', 'oo', 'l' }, vim.split('x*yz*oo*l', '*', true))

		local loops = {
			{ "abc", ".-" },
		}

		for _, q in ipairs(loops) do
			-- matches('Infinite loop detected', pcall_err(str.split, q[1], q[2]))
		end

		-- Validates args.
		eq(true, pcall(str.split, "string", "string"))
		matches("s: expected string, got number", pcall_err(str.split, 1, "string"))
		matches("sep: expected string, got number", pcall_err(str.split, "string", 1))
		matches("opts: expected table, got number", pcall_err(str.split, "string", "string", 1))
	end)

	it("vim.trim", function()
		-- local trim = function(s)
		-- 	return exec_lua("return vim.trim(...)", s)
		-- end

		local trims = {
			{ "   a", "a" },
			{ " b  ", "b" },
			{ "\tc", "c" },
			{ "r\n", "r" },
		}

		for _, q in ipairs(trims) do
			assert(q[2], str.trim(q[1]))
		end

		-- Validates args.
		matches("s: expected string, got number", pcall_err(str.trim, 2))
	end)
end)
