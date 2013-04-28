-- 
-- Abstract: SimplePool sample project 
-- A basic game of billiards using the physics engine
-- (This is easiest to play on iPad or other large devices, but should work on all iOS and Android devices)
-- 
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

local physics = require("physics")
physics.start()

physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

display.setStatusBar( display.HiddenStatusBar )

local tabletop = display.newImage( "table_bkg.png", true ) -- "true" overrides Corona's downsizing of large images on smaller devices
tabletop.x = 384
tabletop.y = 512

local filltop = display.newImage( "fill_bkg.png", true )
filltop.x = 384; filltop.y = -93
local fillbot = display.newImage( "fill_bkg.png", true )
fillbot.rotation=180; fillbot.x = 384; fillbot.y = 1117

local endBumperShape = { -212,-18, 212,-18, 190,2, -190,2 }
local sideBumperShape = { -18,-207, 2,-185, 2,185, -18,207 }

local bumperBody = { friction=0.5, bounce=0.5, shape=endBumperShape }

local bumper1 = display.newImage( "bumper_end.png" )
physics.addBody( bumper1, "static", bumperBody )
bumper1.x = 384; bumper1.y = 58

local bumper2 = display.newImage( "bumper_end.png" )
physics.addBody( bumper2, "static", bumperBody )
bumper2.x = 384; bumper2.y = 966; bumper2.rotation = 180

-- Override the shape declaration above, but reuse the other body properties
bumperBody.shape = sideBumperShape

local bumper3 = display.newImage( "bumper_side.png" )
physics.addBody( bumper3, "static", bumperBody )
bumper3.x = 157; bumper3.y = 279

local bumper4 = display.newImage( "bumper_side.png" )
physics.addBody( bumper4, "static", bumperBody )
bumper4.x = 611; bumper4.y = 279; bumper4.rotation = 180

local bumper5 = display.newImage( "bumper_side.png" )
physics.addBody( bumper5, "static", bumperBody )
bumper5.x = 157; bumper5.y = 745

local bumper6 = display.newImage( "bumper_side.png" )
physics.addBody( bumper6, "static", bumperBody )
bumper6.x = 611; bumper6.y = 745; bumper6.rotation = 180

-- Set up score displays
local redTotal = 0
redScore = display.newText( "RED - " .. redTotal, 0, 0, native.systemFontBold, 28 )
redScore:setTextColor( 255, 40, 40, 90 )
redScore.x = 50; redScore.y = 510; redScore.rotation = 270

local yellowTotal = 0
local yellowScore = display.newText( "YELLOW - " .. yellowTotal, 0, 0, native.systemFontBold, 28 )
yellowScore:setTextColor( 255, 255, 40, 90 )
yellowScore.x = 718; yellowScore.y = 530; yellowScore.rotation = 90

local ball = {}
local ballColors = { "yellow", "red", "yellow", "yellow", "red", "red", "yellow", "red", "yellow", "yellow", "black", "red", "red", "yellow", "red" }

local ballBody = { density=0.8, friction=0.2, bounce=0.5, radius=15 }

local n = 0

-- Arrange balls in triangle formation
for i = 1, 5 do
	for j = 1, (6-i) do
		n = n + 1
		ball[n] = display.newImage( "ball_" .. ballColors[n] .. ".png" )
		ball[n].x = 279 + (j*30) + (i*15)
		ball[n].y = 185 + (i*26)

		physics.addBody( ball[n], ballBody )
		ball[n].linearDamping = 0.3 -- simulates friction of felt
		ball[n].angularDamping = 0.8 -- stops balls from spinning forever
		ball[n].id = "ball" -- store object type as string attribute
		ball[n].color = ballColors[n] -- store ball color as string attribute
	end
end

-- Create cueball
local cueball = display.newImage( "ball_white.png" )
cueball.x = display.contentWidth/2; cueball.y = 780

physics.addBody( cueball, ballBody )
cueball.linearDamping = 0.3
cueball.angularDamping = 0.8
cueball.isBullet = true -- force continuous collision detection, to stop really fast shots from passing through other balls
cueball.color = "white"

target = display.newImage( "target.png" )
target.x = cueball.x; target.y = cueball.y; target.alpha = 0


local function resetCueball()
	cueball.alpha = 0
	cueball.x = 384
	cueball.y = 780
	cueball.xScale = 2.0; cueball.yScale = 2.0
	local dropBall = transition.to( cueball, { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
end

local function updateScores()
	redScore.text = "RED - " .. redTotal
	yellowScore.text = "YELLOW - " .. yellowTotal
end

-- Handler for ball in pocket
local gameOver -- forward declaration; function is below
local function inPocket( self, event )
	event.other:setLinearVelocity( 0, 0 )
	local fallDown = transition.to( event.other, { alpha=0, xScale=0.3, yScale=0.3, time=200 } )
	
	if ( event.other.color == "white" ) then
		timer.performWithDelay( 50, resetCueball )
	elseif ( event.other.color == "red" ) then
		redTotal = redTotal + 1
		updateScores()
	elseif ( event.other.color == "yellow" ) then
		yellowTotal = yellowTotal + 1
		updateScores()
	elseif ( event.other.color == "black" ) then
		gameOver()
	end
end

-- Create pockets
local pocket = {}
for i = 1, 3 do
	for j = 1, 2 do
		local index = j + ((i-1) * 2) -- a counter from 1 to 6

		-- Add objects to use as collision sensors in the pockets
		local sensorRadius = 20
		pocket[index] = display.newCircle( -389 + (515*j), -436 + (474*i), sensorRadius )
		
		-- (Change this value to "true" to make the pocket sensors visible)
		pocket[index].isVisible = false
		
		physics.addBody( pocket[index], { radius=sensorRadius, isSensor=true } )
		pocket[index].id = "pocket"
		pocket[index].collision = inPocket
		pocket[index]:addEventListener( "collision", pocket[index] ) -- add table listener to each pocket sensor

	end
end

-- Shoot the cue ball, using a visible force vector
local function cueShot( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		
		-- Stop current cueball motion, if any
		t:setLinearVelocity( 0, 0 )
		t.angularVelocity = 0

		target.x = t.x
		target.y = t.y
		
		startRotation = function()
			target.rotation = target.rotation + 4
		end
		
		Runtime:addEventListener( "enterFrame", startRotation )
		
		local showTarget = transition.to( target, { alpha=0.4, xScale=0.4, yScale=0.4, time=200 } )
		myLine = nil

	elseif t.isFocus then
		if "moved" == phase then
			
			if ( myLine ) then
				myLine.parent:remove( myLine ) -- erase previous line, if any
			end
			myLine = display.newLine( t.x,t.y, event.x,event.y )
			myLine:setColor( 255, 255, 255, 50 )
			myLine.width = 8

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end
			
			local hideTarget = transition.to( target, { alpha=0, xScale=1.0, yScale=1.0, time=200, onComplete=stopRotation } )
			
			if ( myLine ) then
				myLine.parent:remove( myLine )
			end
			
			-- Strike the ball!
			t:applyForce( (t.x - event.x), (t.y - event.y), t.x, t.y )

		end
	end

	-- Stop further propagation of touch event
	return true
end

function gameOver()
	local overSplash = display.newImage( "game_over.png", true )
	overSplash.alpha = 0
	overSplash.xScale = 1.5; overSplash.yScale = 1.5
	local showGameOver = transition.to( overSplash, { alpha=1.0, xScale=1.0, yScale=1.0, time=500 } )
	cueball:removeEventListener( "touch", cueShot )
end

-- Activate the cue ball and start playing!
cueball:addEventListener( "touch", cueShot )