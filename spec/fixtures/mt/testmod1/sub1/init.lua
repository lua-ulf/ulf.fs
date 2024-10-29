require("ulf.util.debug")._G()

local lazy_require = require("ulf.lib.mt.lazy_require").lazy_require
local M = {

	id = "sub1_init",
	sub1_a = lazy_require("spec.fixtures.mt.testmod1.sub1_a"),
	sub2_b = lazy_require("spec.fixtures.mt.testmod1.sub1_b"),
}

return M
