-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #1
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local thePlayer

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createPlayer
local createSky

local onShowHide

local onUp
local onDown
local onRight
local onLeft
local onA
local onB

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	createSky(centerX, centerY, screenWidth, screenHeight )
	thePlayer = createPlayer( centerX, centerY, 25 )
	--thePlayer = createPlayer( centerX - 30, centerY, 25 )
	--thePlayer = createPlayer( centerX + 30, centerY, 25 )

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false
end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"scrollers", 
			{ "scroll3", "scroll2", "scroll1" },
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = false

	-- Add generic direction and input buttons
	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "upButton", screenLeft-30, screenBot-175, 42, 42, "", onUp )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "downButton",  screenLeft-30, screenBot-125, 42, 42, "", onDown )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", onLeft )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", onRight )
	-- Universal Buttons
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-75, 42, 42, "", onA )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

_G.testFunc = function( obj )

	print("Bob", obj)

end

createPlayer = function ( x, y, size )
	local player  = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 

	local version  = math.random(1,2)
	print(version)
	local mySeq



	-- LINEAR & ANGULAR VELOCITY ++

	player.testFunc = function( self )
		print("Bill", self)
	end

	player.testFunc2 = function( self )
		print("Rob", self )
	end


	mySeq = ssk.sequencer:new()
	local steps = {}
	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "LVEL", vector = { x = 0, y = 100 }, time = 500 }
	steps[#steps+1] = { action = "LVEL", vector = { x = 0, y = -100 }, time = 500 }
	steps[#steps+1] = { action = "STOP", time = 500 }
	steps[#steps+1] = { action = "AVEL", angle = 90, time = 500 }
	steps[#steps+1] = { action = "AVEL", angle = -90, time = 500 }
	steps[#steps+1] = { action = "STOP", time = 0 }
	steps[#steps+1] = { action = "ROTT", angle = 0, time = 0 }
	steps[#steps+1] = { action = "AIMP", angle = 0.10, time = 500 }
	steps[#steps+1] = { action = "LIMP", vector = { x = 0.01, y = 0 }, time = 500 }
	steps[#steps+1] = { action = "LIMP", vector = { x = -0.01, y = 0 }, time = 0 }
	steps[#steps+1] = { action = "LIMP", vector = { x = -0.01, y = 0 }, time = 500 }
	steps[#steps+1] = { action = "LIMP", vector = { x = 0.01, y = 0 }, time = 0 }
	steps[#steps+1] = { action = "AIMP", angle = -0.10, time = 0 }
	steps[#steps+1] = { action = "ROTT", angle = 0, time = 100 }
	--steps[#steps+1] = { action = "REPEAT"   }
	mySeq:set( steps )
	mySeq:clear()
	mySeq:add({ action = "AIMP", angle = 0.10, time = 1000 } )
	mySeq:add({ action = "METHOD", name = "testFunc2", time = 1000} )
	mySeq:add({ action = "METHOD", name = "testFunc", time = 1000} )
	mySeq:add( { action = "REPEAT" , count = 3 , time = 1000 } )
	mySeq:run( player )
	mySeq:stop( )

--[[
	-- TRANSLATE
	mySeq = ssk.sequencer:new()
	local steps = {}
	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "TRNT", vector = { x = 0, y = 100 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "TRNT", vector = { x = -100, y = 0 }, speed = 75 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "TRNT", vector = { x = 100, y = -100 }, time = 100 }

	mySeq:set( steps )
	mySeq:run( player )
--]]

--[[
	-- MOVE TO 
	mySeq = ssk.sequencer:new()
	local steps = {}
	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = w/3, y = h-h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = centerY }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = w/3, y = h-h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = centerY }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = w/3, y = h-h/3 }, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }
	steps[#steps+1] = { action = "MOVT", vector = { x = centerX, y = centerY }, time = 500 }

	mySeq:set( steps )
	mySeq:run( player )
--]]

--[[ -- ROTATE TO (ANGLE)
	if(version == 1) then

	mySeq = ssk.sequencer:new()
	local steps = {}
	steps[#steps+1] = { action = "WAIT", time = 500 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(90,true), time = 500 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(180,true), time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(0,true), time = 500 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(270,true), time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(180,true), time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(90,true), time = 1000 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(0,true), time = 1000 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(270,true), time = 1000 }

	steps[#steps+1] = { action = "ROTTV", vector = ssk.math2d.angle2Vector(180,true), time = 1000 }

	mySeq:set( steps )



	-- ROTATE TO (ANGLE)

	else

	mySeq = ssk.sequencer:new()
	local steps = {}
	steps[#steps+1] = { action = "WAIT", time = 500 }

	steps[#steps+1] = { action = "ROTT", angle = 90, time = 500 }

	steps[#steps+1] = { action = "ROTT", angle = 180, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 500 }

	steps[#steps+1] = { action = "ROTT", angle = 0, time = 500 }

	steps[#steps+1] = { action = "ROTT", angle = 270, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTT", angle = 180, time = 500 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTT", angle = 90, time = 1000 }

	steps[#steps+1] = { action = "ROTT", angle = 0, time = 1000 }

	steps[#steps+1] = { action = "WAIT", time = 1200 }

	steps[#steps+1] = { action = "ROTT", angle = 270, time = 1000 }

	steps[#steps+1] = { action = "ROTT", angle = 180, time = 1000 }

	mySeq:set( steps )

	end

	ssk.components.movesForward( player, 100 )
	player:enableForwardVelocity()
	mySeq:run( player )

--]]

	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		event.target:setText( "Hide Details" )
	end	
end


-- Movement/General Button Handlers
onUp = function ( event )
end

onDown = function ( event )
end

onRight = function ( event )
end

onLeft = function ( event )
end

onA = function ( event )
end

onB = function ( event )	
end


return gameLogic