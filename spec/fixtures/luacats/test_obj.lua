--- @nodoc
--- @class test.ulf.lib.luacats.SomeOption
local SomeOption = {} -- luacheck: no unused

---@alias test.ulf.lib.luacats.handler_map {[string]:fun(...:any)}

---@class test.ulf.lib.luacats.BaseObject
---@field id string

--- Some wonderful Object.
---
--- @see SomeLink
---
--- This Object is a fake!
---
---@class test.ulf.lib.luacats.Object:test.ulf.lib.luacats.BaseObject
---@field handlers test.ulf.lib.luacats.handler_map
---@field new fun(self:test.ulf.lib.luacats.Object,...:any):test.ulf.lib.luacats.Object
local Object = {}

--- Initializes a new Emitter instance.
--- @param error_sink table? Optional table to which unhandled 'error' events are forwarded.
function Object:initialize(error_sink)
	self.error_sink = error_sink or process
end

--- Returns a clone of this object
--- @note this creates a copy of this instance!
--- @see Object:_copy
---
--- @param flag? {strict:boolean?}
function Object:clone(flag) end

--- Returns a copy of this object
function Object:_copy() end
