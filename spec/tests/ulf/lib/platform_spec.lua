require("ulf.util.debug")._G()
describe("#ulf.lib.platform", function()
	-- local TestDoubles = require("spec.helpers.test_doubles")

	describe("Windows checks", function()
		---@type ulf.lib.platform
		local platform
		local uv = vim and vim.uv or require("luv")
		---@type uv
		local uv_orig
		---@type jitlib
		local jit_orig

		before_each(function()
			---@type any
			package.loaded["ulf.lib.platform"] = nil

			jit_orig = jit
			jit.os = "Windows"
			uv_orig = uv
			uv.os_uname = function()
				return {
					sysname = "Windows_NT",
				}
			end

			platform = require("ulf.lib.platform")
		end)
		after_each(function()
			uv = uv_orig
			jit = jit_orig
		end)

		it("should correctly detect the operating system", function()
			assert.is_true(platform.iswin)
			assert.same(platform.os, "Windows")
		end)
		describe("Path separators", function()
			it("should provide correct path and environment variable separators", function()
				assert.same(platform.path_sep, "\\")
				assert.same(platform.pathvar_sep, ";")
			end)
		end)

		describe("get_path_joiner", function()
			it("should return a function that joins paths correctly", function()
				local joiner = platform.get_path_joiner()
				assert.is_function(joiner)
				local result = joiner("home", "user", "project")
				local expected = "home\\user\\project"
				assert.same(result, expected)
			end)
		end)
	end)

	describe("Linux checks", function()
		---@type ulf.lib.platform
		local platform
		local uv = vim and vim.uv or require("luv")
		---@type uv
		local uv_orig
		---@type jitlib
		local jit_orig
		local stub = require("luassert.stub")
		local st = {}

		before_each(function()
			package.loaded["ulf.lib.platform"] = nil

			jit_orig = jit
			jit.os = "Linux"
			uv_orig = uv
			uv.os_uname = function()
				return {
					sysname = "Linux",
				}
			end

			platform = require("ulf.lib.platform")
		end)
		after_each(function()
			uv = uv_orig
			jit = jit_orig
		end)

		it("should correctly detect the operating system", function()
			assert.is_false(platform.iswin)
			assert.same(platform.os, "Linux")
		end)

		describe("Path separators", function()
			it("should provide correct path and environment variable separators", function()
				assert.same(platform.path_sep, "/")
				assert.same(platform.pathvar_sep, ":")
			end)
		end)

		describe("get_path_joiner", function()
			it("should return a function that joins paths correctly", function()
				local joiner = platform.get_path_joiner()
				assert.is_function(joiner)
				local result = joiner("home", "user", "project")
				local expected = "home/user/project"
				assert.same(result, expected)
			end)
		end)
	end)

	describe("Generic checks", function()
		---@type ulf.lib.platform
		local platform
		local st = {}

		local uv = vim and vim.uv or require("luv")
		before_each(function()
			---@type any
			package.loaded["ulf.lib.platform"] = nil

			platform = require("ulf.lib.platform")
		end)
		after_each(function() end)

		describe("get_path_joiner", function()
			it("should allow overriding the separator", function()
				local joiner = platform.get_path_joiner(":")
				assert.is_function(joiner)
				local result = joiner("home", "user", "project")
				assert.same(result, "home:user:project")
			end)
		end)
		describe("Platform architecture", function()
			it("should return a valid architecture name", function()
				assert.is_string(platform.arch)
				assert.truthy(platform.arch:match("x86") or platform.arch:match("x64") or platform.arch:match("arm"))
			end)
		end)

		describe("Luv runtime", function()
			it("should provide access to the uv runtime", function()
				assert.is_table(platform.uv)
				assert.same(platform.uv, uv) -- Ensure `uv` is the same Luv instance
			end)
		end)
	end)
end)
