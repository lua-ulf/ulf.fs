require("ulf.util.debug")._G()

local validator = {}

---comment
---@param got {handler_was_called:boolean,msg:string}
---@param expect {handler_was_called:boolean,msg_pattern:string,stack_trace_pattern:string}
validator.error_with_stack_trace = function(got, expect) end

describe("#ulf.lib.git", function()
	---@type ulf.lib.fs
	local git
	before_each(function()
		---@type any
		package.loaded["ulf.lib.git"] = nil

		UlfTest.test_doubles.module.add("io", io)
		UlfTest.test_doubles.setup({
			stubs = {
				io = {
					popen = {
						on_call_with = {
							args = { "git rev-parse --show-toplevel 2>/dev/null" },
							returns = {

								read = function()
									return "/projects/one"
								end,

								close = function() end,
							},
						},
					},
				},
			},
		})
		git = require("ulf.lib.git")
	end)
	after_each(function()
		UlfTest.test_doubles.tear_down()
	end)
	describe("root.get()", function()
		it("returns the git root", function()
			assert.equal("/projects/one", git.root.get())
		end)
	end)
end)
