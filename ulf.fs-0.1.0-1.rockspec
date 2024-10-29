---@diagnostic disable:lowercase-global

rockspec_format = "3.0"
package = "ulf.fs"
version = "0.1.0-1"
source = {
	url = "https://github.com/lua-ulf/ulf.fs/archive/refs/tags/0.1.0-1.zip",
}

description = {
	summary = "ulf.fs is the fs library for the ULF framework.",
	labels = { "lua", "neovim", "ulf" },
	homepage = "http://github.com/lua-ulf/ulf.fs",
	license = "MIT",
}

dependencies = {
	"lua >= 5.1",
	"lpeg",
}
build = {
	type = "builtin",
	modules = {},
	copy_directories = {},
	platforms = {},
}
test_dependencies = {
	"busted",
	"busted-htest",
	"luacov",
	"luacov-html",
	"luacov-multiple",
	"luacov-console",
	"luafilesystem",
}
test = {
	type = "busted",
}
