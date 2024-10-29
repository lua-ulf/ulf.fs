require("ulf.util.debug")._G()

local validator = {}

---comment
---@param got {handler_was_called:boolean,msg:string}
---@param expect {handler_was_called:boolean,msg_pattern:string,stack_trace_pattern:string}
validator.error_with_stack_trace = function(got, expect) end

describe("#ulf.fs", function()
	---@type ulf.lib.fs
	local fs
	---@type uv
	local uv

	before_each(function()
		uv = vim and vim.uv or require("luv")
		package.loaded["ulf.fs"] = nil ---@diagnostic disable-line: no-unknown
		local platform_mock = {
			path_sep = "/",
			pathvar_sep = ":",
			iswin = false,
		}
		platform_mock.get_path_joiner = function(sep)
			sep = sep or platform_mock.path_sep
			local function joinpath(...)
				return (table.concat({ ... }, sep):gsub(sep .. sep .. "+", sep))
			end

			return joinpath
		end
		UlfTest.test_doubles.module.add("uv", uv)
		UlfTest.test_doubles.setup({
			stubs = {
				uv = {
					os_homedir = {
						returns = { "/home/test" },
					},
				},
			},
		})

		package.loaded["ulf.lib.platform"] = platform_mock
		fs = require("ulf.fs")
	end)

	after_each(function()
		UlfTest.test_doubles.tear_down()
	end)

	describe("norm", function()
		it("returns a normalized path", function()
			local path = "~/somefile"
			assert.equal("/home/test/somefile", fs.norm(path))
		end)
	end)
	describe("basename", function()
		it("returns the basename of a file or dir", function()
			local path = "/home/nobody/somefile"
			assert.equal("somefile", fs.basename(path))
		end)
	end)
	describe("dirname", function()
		it("returns the directory name of a path", function()
			local path = "/home/nobody/somefile"
			assert.equal("/home/nobody", fs.dirname(path))
		end)
	end)
	describe("joinpath", function()
		it("joins one or more paths elements and returns a path", function()
			assert.equal("a", fs.joinpath("a"))
			assert.equal("a/b", fs.joinpath("a", "b"))
		end)
	end)
	describe("joinpathvar", function()
		it("joins one or more paths elements in a path environment variable", function()
			assert.equal("a", fs.joinpathvar("a"))
			assert.equal("a:b", fs.joinpathvar("a", "b"))
		end)
	end)

	describe("dir_exists", function()
		it("returns true if a directory exists and the path is absolute", function()
			UlfTest.test_doubles.setup({
				stubs = {
					uv = {
						os_homedir = {
							returns = { "/home/test" },
						},
						fs_stat = {
							on_call_with = { args = { "/some_dir" }, returns = { type = "directory" } },
						},
					},
				},
			})

			assert(fs.dir_exists("/some_dir"))
		end)

		it("returns false if a directory is invalid and the path is absolute", function()
			UlfTest.test_doubles.setup({
				stubs = {
					uv = {
						os_homedir = {
							returns = { "/home/test" },
						},
						fs_stat = {
							on_call_with = { args = { "/invalid_dir" }, returns = { type = "invalid" } },
						},
					},
				},
			})

			assert(not fs.dir_exists("/invalid_dir"))
		end)

		describe("file_exists", function()
			it("returns true if a file exists and the path is absolute", function()
				UlfTest.test_doubles.setup({
					stubs = {
						uv = {
							os_homedir = {
								returns = { "/home/test" },
							},
							fs_stat = {
								on_call_with = { args = { "/some_file" }, returns = { type = "file" } },
							},
						},
					},
				})

				assert(fs.file_exists("/some_file"))
			end)

			it("returns false if a file is invalid and the path is absolute", function()
				UlfTest.test_doubles.setup({
					stubs = {
						uv = {
							os_homedir = {
								returns = { "/home/test" },
							},
							fs_stat = {
								on_call_with = { args = { "/invalid_file" } },
							},
						},
					},
				})

				assert(not fs.file_exists("/invalid_file"))
			end)
		end)
	end)
end)
