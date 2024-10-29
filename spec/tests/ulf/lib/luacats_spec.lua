-- local helpers = require("spec.helpers")

describe("#ulf.lib.luacats", function()
	local git_root = UlfTest.fs.git_root()
	local luacats = require("ulf.lib.luacats")
	local test_files = {
		test_obj1 = UlfTest.fs.joinpath(git_root, "deps", "ulf.lib", "spec", "fixtures", "luacats", "test_obj.lua"),
	}

	describe("parse", function()
		it("parses a lua file and returns annotations", function()
			local results = {}
			results.test_obj1 = luacats.parse(test_files.test_obj1)
			assert.table(results.test_obj1["test.ulf.lib.luacats.BaseObject"])

			assert.same(results.test_obj1["test.ulf.lib.luacats.BaseObject"], {
				fields = {
					{
						kind = "field",
						name = "id",
						type = "string",
					},
				},
				kind = "class",
				module = ".Users.al.dev.projects.ulf.deps.ulf.lib.spec.fixtures.luacats.test_obj.lua",
				name = "test.ulf.lib.luacats.BaseObject",
			})

			assert.same(results.test_obj1["test.ulf.lib.luacats.Object"], {
				desc = "Some wonderful Object.\n\n\nThis Object is a fake!\n",
				fields = {
					{
						kind = "field",
						name = "handlers",
						type = "test.ulf.lib.luacats.handler_map",
					},
					{
						kind = "field",
						name = "new",
						type = "fun(self:test.ulf.lib.luacats.Object,...:any):test.ulf.lib.luacats.Object",
					},
					{
						desc = "Initializes a new Emitter instance.",
						name = "initialize",
						type = "fun(self: test.ulf.lib.luacats.Object, error_sink: table?)",
					},
					{
						desc = "Returns a clone of this object\n",
						name = "clone",
						type = "fun(self: test.ulf.lib.luacats.Object, flag: {strict:boolean?}?)",
					},
					{
						desc = "Returns a copy of this object",
						name = "_copy",
						type = "fun(self: test.ulf.lib.luacats.Object)",
					},
				},
				kind = "class",
				module = ".Users.al.dev.projects.ulf.deps.ulf.lib.spec.fixtures.luacats.test_obj.lua",
				name = "test.ulf.lib.luacats.Object",
				parent = "test.ulf.lib.luacats.BaseObject",
				see = { {
					desc = "SomeLink",
				} },
			})
			assert.same(results.test_obj1["test.ulf.lib.luacats.SomeOption"], {
				fields = {},
				kind = "class",
				module = ".Users.al.dev.projects.ulf.deps.ulf.lib.spec.fixtures.luacats.test_obj.lua",
				name = "test.ulf.lib.luacats.SomeOption",
				nodoc = true,
			})
		end)
	end)
end)
