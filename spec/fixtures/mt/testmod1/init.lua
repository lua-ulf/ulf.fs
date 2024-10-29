require("ulf.util.debug")._G()

local lazy_require = require("ulf.lib.mt.lazy_require").lazy_require
local M = {

	sub1 = lazy_require("spec.fixtures.mt.testmod1.sub1"),
	sub2 = lazy_require("spec.fixtures.mt.testmod1.sub2"),
}

return M
