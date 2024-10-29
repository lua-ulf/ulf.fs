require("ulf.util.debug")._G()

local lazy_require = require("ulf.lib.module.lazy_require").lazy_require

---@module "ulf.fs.nvim_lib""
local _nvim_lib = lazy_require("ulf.fs.nvim_lib")

---@class ulf.fs : ulf.PackageSpec
local M = {

	meta = require("ulf.lib.package"),
	config = {},

	root = _nvim_lib.root,
	joinpath = _nvim_lib.joinpath,
	rm = _nvim_lib.rm,
	parents = _nvim_lib.parents,
	normalize = _nvim_lib.normalize,
	find = _nvim_lib.find,
	dirname = _nvim_lib.dirname,
	dir = _nvim_lib.dir,
	basename = _nvim_lib.basename,
}

return M
