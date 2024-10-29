require("ulf.util.debug")._G()

local instanceof = require("ulf.lib.obj.instanceof").instanceof

describe("#ulf.lib.Emitter", function()
	local Emitter = require("ulf.lib.obj.emitter")
	describe("instance tests", function()
		---@type ulf.lib.obj.Emitter
		local emitter

		before_each(function()
			emitter = Emitter:new()
		end)
		describe("Instance type", function()
			it("has the correct type", function()
				local Object = require("ulf.lib.obj.object")
				assert.True(instanceof(Emitter, Object))
				assert.True(instanceof(emitter, Emitter))
				assert.True(instanceof(emitter, Object))
			end)
		end)

		describe("Basic event handling", function()
			it("registers and emits events", function()
				local called = false

				---@type string
				local arg1
				---@type string
				local arg2

				emitter:on("test_event", function(a, b)
					called = true
					arg1 = a
					arg2 = b
				end)

				emitter:emit("test_event", "hello", "world")

				assert.is_true(called)
				assert.are.equal("hello", arg1)
				assert.are.equal("world", arg2)
			end)

			it("supports multiple handlers for the same event", function()
				local count = 0

				emitter:on("increment", function()
					count = count + 1
				end)

				emitter:on("increment", function()
					count = count + 1
				end)

				emitter:emit("increment")

				assert.are.equal(2, count)
			end)

			it("removes a specific listener", function()
				local count = 0

				local handler = function()
					count = count + 1
				end

				emitter:on("event", handler)
				emitter:emit("event")
				assert.are.equal(1, count)

				emitter:remove_listener("event", handler)
				emitter:emit("event")
				assert.are.equal(1, count)
			end)

			it("removes all listeners for an event", function()
				local count = 0

				emitter:on("event", function()
					count = count + 1
				end)

				emitter:on("event", function()
					count = count + 1
				end)

				emitter:emit("event")
				assert.are.equal(2, count)

				emitter:remove_all_listeners("event")
				emitter:emit("event")
				assert.are.equal(2, count)
			end)

			it("removes all listeners for all events", function()
				local count1 = 0
				local count2 = 0

				emitter:on("event1", function()
					count1 = count1 + 1
				end)

				emitter:on("event2", function()
					count2 = count2 + 1
				end)

				emitter:emit("event1")
				emitter:emit("event2")
				assert.are.equal(1, count1)
				assert.are.equal(1, count2)

				emitter:remove_all_listeners()
				emitter:emit("event1")
				emitter:emit("event2")
				assert.are.equal(1, count1)
				assert.are.equal(1, count2)
			end)

			it("supports once handlers", function()
				local count = 0

				emitter:once("event", function()
					count = count + 1
				end)

				emitter:emit("event")
				emitter:emit("event")

				assert.are.equal(1, count)
			end)

			it("propagates events to another emitter", function()
				local target = Emitter:new()
				local called = false

				target:on("event", function()
					called = true
				end)

				emitter:propagate("event", target)
				emitter:emit("event")

				assert.is_true(called)
			end)

			it("returns correct listener count", function()
				assert.are.equal(0, emitter:listener_count("event"))

				emitter:on("event", function() end)
				assert.are.equal(1, emitter:listener_count("event"))

				emitter:on("event", function() end)
				assert.are.equal(2, emitter:listener_count("event"))

				emitter:remove_all_listeners("event")
				assert.are.equal(0, emitter:listener_count("event"))
			end)

			it("lists listeners for an event", function()
				local handler1 = function() end
				local handler2 = function() end

				emitter:on("event", handler1)
				emitter:on("event", handler2)

				local listeners = emitter:listeners("event")
				assert.are.equal(2, #listeners)
				assert.is_true(listeners[1] == handler1 or listeners[2] == handler1)
				assert.is_true(listeners[1] == handler2 or listeners[2] == handler2)
			end)
		end)

		describe("Error handling", function()
			it('handles errors in handlers by emitting "error" event', function()
				---@type string
				local err_message
				emitter:on("error", function(err)
					err_message = err
				end)

				emitter:on("event", function()
					error("Test error")
				end)

				emitter:emit("event")

				assert.is_not_nil(err_message)
				assert.is_true(string.find(err_message, "Test error") ~= nil)
			end)
		end)
	end)

	describe("error sink", function()
		describe("using process error_sink", function()
			local error_received = nil
			before_each(function()
				_G.process = Emitter:new()

				process:on("error", function(err)
					error_received = err
				end)
			end)
			after_each(function()
				_G.process = nil
			end)
			it("forwards unhandled error events to the process table", function()
				local e = Emitter:new()

				e:emit("error", "Process error")

				assert.are.equal("Process error", error_received)
			end)
		end)

		describe("using custom error_sink", function()
			it("forwards unhandled error events to the custom error_sink", function()
				local custom_sink = Emitter:new()
				local error_received = nil

				custom_sink:on("error", function(err)
					error_received = err
				end)

				local e = Emitter:new(custom_sink)

				e:emit("error", "Custom error")

				assert.are.equal("Custom error", error_received)
			end)
		end)

		describe("no error sink", function()
			it("throws an error for unhandled error events", function()
				-- Ensure process is not defined
				process = nil ---@diagnostic disable-line: assign-type-mismatch ---@diagnostic disable-line: assign-type-mismatch

				local e = Emitter:new()

				local success, err = pcall(function()
					e:emit("error", "Unhandled error")
				end)

				assert.is_false(success)
				assert.is_true(string.find(err, "Unhandled error event") ~= nil)
			end)
		end)
	end)

	describe("propagation", function()
		---@class test.ulf.lib.obj.emitter.Producer : ulf.lib.obj.Emitter
		---@field new fun(self:test.ulf.lib.obj.emitter.Producer,...:any):test.ulf.lib.obj.emitter.Producer
		local Producer = Emitter:extend()
		function Producer:start()
			self:emit("data", "sample data")
			self:emit("end")
		end

		---@class test.ulf.lib.obj.emitter.Consumer : ulf.lib.obj.Emitter
		---@field new fun(self:test.ulf.lib.obj.emitter.Consumer,...:any):test.ulf.lib.obj.emitter.Consumer
		---@field completed boolean
		---@field received_data string
		local Consumer = Emitter:extend()
		function Consumer:initialize()
			self.received_data = nil
			self.completed = false
		end
		function Consumer:handle_data(data)
			self.received_data = data
		end
		function Consumer:handle_end()
			self.completed = true
		end

		it("consumer receives events from producer via propagation", function()
			local producer = Producer:new()
			local consumer = Consumer:new()

			producer:propagate("data", consumer)
			producer:propagate("end", consumer)

			consumer:on("data", function(data)
				consumer:handle_data(data)
			end)
			consumer:on("end", function()
				consumer:handle_end()
			end)

			producer:start()

			assert.are.equal("sample data", consumer.received_data)
			assert.is_true(consumer.completed)
		end)
	end)

	describe("wrap", function()
		---@class test.ulf.lib.obj.emitter.TestEmitter : ulf.lib.obj.Emitter
		---@field new fun(self:test.ulf.lib.obj.emitter.TestEmitter,...:any):test.ulf.lib.obj.emitter.TestEmitter
		---@field success_called boolean
		---@field error_message string
		local TestEmitter = Emitter:extend()

		function TestEmitter:initialize()
			self.success_called = false
			self.error_message = nil
		end

		-- Original method that we will wrap
		-- uv style async callback signature:
		-- 1st arg indicates error
		-- 2nd arg is the result
		function TestEmitter:on_complete(err, result)
			self.success_called = true
			self.result = result
		end

		it("emits an error when wrapped method receives an error", function()
			local emitter = TestEmitter:new()

			-- Wrap the 'on_complete' method
			emitter:wrap("on_complete")

			-- Set up an 'error' event handler
			emitter:on("error", function(err)
				emitter.error_message = err
			end)

			-- Simulate an asynchronous callback with an error
			emitter:on_complete("Simulated error")

			-- Assertions
			assert.is_false(emitter.success_called)
			assert.are.equal("Simulated error", emitter.error_message)
		end)

		it("calls the original method when there is no error", function()
			local emitter = TestEmitter:new()

			-- Wrap the 'on_complete' method
			emitter:wrap("on_complete")

			-- Set up an 'error' event handler
			emitter:on("error", function(err)
				emitter.error_message = err
			end)

			-- Simulate an asynchronous callback without an error
			emitter:on_complete(nil, "Success result")

			-- Assertions
			assert.is_true(emitter.success_called)
			assert.are.equal("Success result", emitter.result)
			assert.is_nil(emitter.error_message)
		end)
	end)
end)
