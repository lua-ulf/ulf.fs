local git_root = require("ulf.lib.git.root").get()

if false then
	describe("#ulf.lib.mt", function()
		local lazy_require = require("ulf.lib.mt.lazy_require")
		local testmod1 = require("spec.fixtures.mt.testmod1")

		describe("lazy_require", function()
			it("works", function()
				print("test start>>>>>>>>>>>>>>>>>>>>>")
				assert(lazy_require)
				assert.Table(testmod1)
				assert.Table(testmod1.sub1)
				-- assert.Table(testmod1.sub1.sub1_a)
				local sub1_a = testmod1.sub1.sub1_a
				local sub1_a_mod1 = testmod1.sub1.sub1_a.sub1_a_mod1
				P(testmod1)
				P(sub1_a)
				P(sub1_a_mod1)
				print("test end<<<<<<<<<<<<<<<<<<<<<<<")
			end)
		end)
	end)
end
