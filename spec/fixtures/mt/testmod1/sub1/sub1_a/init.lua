require("ulf.util.debug")._G()

local lazy_require = require("ulf.lib.mt.lazy_require").lazy_require
local M = {

	id = "sub1_a_init",
	sub1_a_mod1 = lazy_require("spec.fixtures.mt.testmod1.sub1.sub1_a_mod1"),
	sub1_a_mod2 = lazy_require("spec.fixtures.mt.testmod1.sub1.sub1_a_mod2"),
}

return M
