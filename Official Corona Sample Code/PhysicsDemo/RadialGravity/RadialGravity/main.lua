-- Physics Demo: Radial Gravity | Version: 1.0
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.

local physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight

--set up collision filters
local screenFilter = { categoryBits=2, maskBits=1 }
local objFilter = { categoryBits=1, maskBits=14 }
local fieldFilter = { categoryBits=4, maskBits=1 }
local magnetFilter = { categoryBits=8, maskBits=1 }

--set initial magnet pull
local magnetPull = 0.25

--set up world and background
local back = display.newImageRect( "sky.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2 ; back:scale( 1.4,1.4 )
local screenBounds = display.newRect( -ox, -oy, display.contentWidth+ox+ox, display.contentHeight+oy+oy )
screenBounds.name = "screenBounds"
screenBounds.isVisible = false ; physics.addBody( screenBounds, "static", { isSensor=true, filter=screenFilter } )



local function newPositionVelocity( object )

	local math_random = math.random
	local side = math_random( 1,4 ) ; local posX ; local posY ; local velX ; local velY

	if ( side == 1 or side == 3 ) then
		posX = math_random(0,display.pixelHeight)
		velX = math_random( -10,10 ) * 5
		if ( side == 1 ) then posY = -oy-40 ; velY = math_random( 8,18 ) * 16
		else posY = display.contentHeight+oy+40 ; velY = math_random( 8,16 ) * -16
		end
	else
		posY = math_random(0,display.pixelWidth)
		velY = math_random( -10,10 ) * 5
		if ( side == 4 ) then posX = -ox-40 ; velX = math_random( 8,16 ) * 16
		else posX = display.contentWidth+ox+40 ; velX = math_random( 8,16 ) * -16
		end
	end
	object.x = posX ; object.y = posY
	object:setLinearVelocity( velX, velY )
	object.angularVelocity = math_random( -3,3 ) * 40
	object.alpha = 1

end



local function objectCollide( self, event )

	local otherName = event.other.name
	
	local function onDelay( event )
		local action = ""
		if ( event.source ) then action = event.source.action ; timer.cancel( event.source ) end
		
		if ( action == "makeJoint" ) then
			self.hasJoint = true
			self.touchJoint = physics.newJoint( "touch", self, self.x, self.y )
			self.touchJoint.frequency = magnetPull
			self.touchJoint.dampingRatio = 0.0
			self.touchJoint:setTarget( 512, 384 )
		elseif ( action == "leftField" ) then
			self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil
		else
			if ( self.hasJoint == true ) then self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil end
			newPositionVelocity( self )
		end
	end

	if ( event.phase == "ended" and otherName == "screenBounds" ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftScreen"
	elseif ( event.phase == "began" and otherName == "magnet" ) then
		transition.to( self, { time=400, alpha=0, onComplete=onDelay } )
	elseif ( event.phase == "began" and otherName == "field" and self.hasJoint == false ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "makeJoint"
	elseif ( event.phase == "ended" and otherName == "field" and self.hasJoint == true ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftField"
	end

end



local function setupWorld()

	for i=1,8 do
		local obj = display.newImageRect( "object.png", 48, 48 )
		physics.addBody( obj, { bounce=0, radius=12, filter=objFilter } )
		newPositionVelocity( obj )
		obj.hasJoint = false
		obj.collision = objectCollide ; obj:addEventListener( "collision", obj )
	end

	local field = display.newImageRect( "field.png", 660, 660 ) ; field.alpha = 0.3
	field.name = "field"
	field.x = display.contentCenterX ; field.y = display.contentCenterY
	physics.addBody( field, "static", { isSensor=true, radius=320, filter=fieldFilter } )
	
	local magnet = display.newImageRect( "magnet.png", 128, 128 )
	magnet.name = "magnet"
	magnet.x = display.contentCenterX ; magnet.y = display.contentCenterY
	physics.addBody( magnet, "static", { bounce=0, radius=40, filter=magnetFilter } )
	
end

setupWorld()