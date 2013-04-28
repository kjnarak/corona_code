-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- ==
--    Load SSK CORE
-- ==
require( "ssk.globals" ) -- Load Standard Globals
require("ssk.loadSSK")

local physics = require("physics")
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode( "hybrid" )

-- ==
--    The Recipe
-- ==

local group = display.newGroup()


local mySeq = ssk.sequencer:new()
local steps = {}
steps[#steps+1] = { action = "WAIT", time = 500 }

steps[#steps+1] = { action = "ROTT", angle = 135, time = 250 }

steps[#steps+1] = { action = "WAIT", time = 500 }

steps[#steps+1] = { action = "ROTT", angle = 360, time = 500 }
steps[#steps+1] = { action = "ROTT", angle = 0, time = 0 }

steps[#steps+1] = { action = "WAIT", time = 2200 }

steps[#steps+1] = { action = "ROTT", angle = 180, time = 500 }

steps[#steps+1] = { action = "WAIT", time = 1000 }

steps[#steps+1] = { action = "ROTT", angle = 135, time = 250 }

mySeq:set( steps )

for i = 1, 10 do

	local test = ssk.display.rect( nil, 50 + i * 20, centerY, { w = 10, h = 10 }, { density = 1, linearDaming = 5 } )
	test.rotation = 180

	ssk.components.movesForward( test, 100 )
	test:enableForwardVelocity()

	mySeq:run( test )
end

--transition.to( test, { rotation = 360, time = 360/90 * 1000 } )
--test:removeSelf()
--test = nil

--[[
timer.performWithDelay(2200, 
	function() 
			--test:remove_hasForce() 		
			print("BOOP")
	end )
--]]