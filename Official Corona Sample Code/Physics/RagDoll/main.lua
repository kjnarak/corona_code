-- Abstract: Ragdoll sample project
-- A port of the ragdoll from http://www.box2dflash.org/
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- History
--  1.0		6/7/12		Initial version
-------------------------------------------------------------------------------------


local ragdoll = require "ragdoll"

--> Setup Display
display.setStatusBar (display.HiddenStatusBar)

--> Start Physics
local physics = require ("physics")

physics.start (true)
physics.setDrawMode( 'debug' )

-- For ragdolls, we need to turn off continuous physics to prevent joint instability
-- Contiouous physics prevents "tunnelling" effects where an object (e.g. a bullet) 
-- moves so quickly that it appears to move through a thin wall. Because it's turned off,
-- we have to make the walls extra thick to prevent tunneling effects.
physics.setContinuous( false )
 
system.activate ("multitouch")

local color1 = {255, 0, 0, 128}
local color2 = {0, 255, 0, 128}
--local color3 = {255, 255, 0, 128}
local color4 = {0, 0, 255, 128}

local walls = ragdoll.createWalls()
local doll1 = ragdoll.newRagDoll(0, 100, color1) 
--local doll2 = ragdoll.newRagDoll(200, 320, color2) 
--local doll3 = ragdoll.newRagDoll(160, 320, color3) 
--local doll4 = ragdoll.newRagDoll(280, 320, color4)

-- Create pillar that hands from the ceiling
local box = display.newRect(0, 0, 64, 256)
box:setFillColor(32, 0, 0, 255)
box.strokeWidth = 3
box:setStrokeColor(128, 128, 128)

box.x = 160
box.y = 32

physics.addBody(box, { density = 0.2, friction = 0.1, bounce = 0.0 })
box.bodyType="static"

-- Ensure gravity points down relative to the earth
local function onTilt( event )
	physics.setGravity( 10 * event.xGravity, -10 * event.yGravity )
end
 
Runtime:addEventListener( "accelerometer", onTilt )
