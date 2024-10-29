local fs = require("ulf.test.lib.fs")
require("ulf.test.busted.helper").new({
	---FIXME: this breaks if you work on the single repo
	project_root = fs.joinpath(fs.git_root(), "deps", "ulf.lib"),
})
