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
local createSprite
local createSky
local createSprite
local createRunner

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
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	--createSky(centerX, centerY, screenWidth, screenHeight )
	--thePlayer = createPlayer( centerX, centerY- 60, 99 * 2, 34 * 2 )

	local tank = createSprite( centerX, centerY + 60, "blue", 1/2 )
	tank.rotation = 90
	tank.x,tank.y = 100,60
	transition.to( tank, {x = w-100, time = 3000 } )
	timer.performWithDelay(3000, function() if(isDisplayObject(tank)) then tank:pause() end end )

	local tank = createSprite( centerX, centerY + 60, "grey", 1/2 )
	tank.rotation = 90
	tank.x,tank.y = 100,90
	transition.to( tank, {x = w-100, time = 3000 } )
	timer.performWithDelay(3000, function() if(isDisplayObject(tank)) then tank:pause() end end )

	local tank = createSprite( centerX, centerY + 60, "red", 1/2 )
	tank.rotation = 90
	tank.x,tank.y = 100,120
	transition.to( tank, {x = w-100, time = 3000 } )
	timer.performWithDelay(3000, function() if(isDisplayObject(tank)) then tank:pause() end end )

	local tank = createSprite( centerX, centerY + 60, "green", 1/2 )
	tank.rotation = 90
	tank.x,tank.y = 100,150
	transition.to( tank, {x = w-100, time = 3000 } )
	timer.performWithDelay(3000, function() if(isDisplayObject(tank)) then tank:pause() end end )


	--createRunner( centerX, centerY, 1/2)


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


	ssk.sheetmgr:destroySheet( "greyTank1" )
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
	--backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

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

function createSprite( x, y, tankColor, scale ) 
	local scale = scale * 2
	local sheetData = { 
		width = 32,   --the width of each frame
		height = 32,  --the height of each frame
		numFrames = 8, --the total number of frames on the sheet
	}

	--local mySheet = graphics.newImageSheet( imagesDir .. "AriFeldman/enemyPlaneBlue2x.png", sheetData )

	if( not ssk.sheetmgr:sheetExists( tankColor .. "tank" ) ) then
		ssk.sheetmgr:createSheet( tankColor .. "tank", imagesDir .. "AriFeldman/" .. tankColor .. "tank.png", sheetData )
	end

	local mySheet = ssk.sheetmgr:getSheet( tankColor .. "tank" )

	local sequenceData = {
		{ 
			name = "normalRun",  --name of animation sequence
			start = 1,  --starting frame index
			count = 8,  --total number of frames to animate consecutively before stopping or looping
			time = 400,  --optional, in milliseconds; if not supplied, the sprite is frame-based
			loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
			loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
		}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table	
	}

	local animation = display.newSprite( mySheet, sequenceData )
	animation:scale(scale,scale)
	animation.x = x
	animation.y = y
	animation:play()

	layers.content:insert(animation)

	--

	return animation
end

function createRunner( x, y, scale ) 
	local scale = scale * 2
	local sheetData = { 
		width = 96,   --the width of each frame
		height = 96,  --the height of each frame
		numFrames = 8, --the total number of frames on the sheet
	}

	--local mySheet = graphics.newImageSheet( imagesDir .. "walker.png", sheetData )

	if( not ssk.sheetmgr:sheetExists( "runner" ) ) then
		ssk.sheetmgr:createSheet( "runner", imagesDir .. "walker.png", sheetData )
	end

	local mySheet = ssk.sheetmgr:getSheet( "runner" )

	local sequenceData = {
		{ 
			name = "normalRun",  --name of animation sequence
			start = 1,  --starting frame index
			count = 8,  --total number of frames to animate consecutively before stopping or looping
			time = 500,  --optional, in milliseconds; if not supplied, the sprite is frame-based
			loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
			loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
		}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table	
	}

	local animation = display.newSprite( mySheet, sequenceData )
	animation:scale(scale,scale)
	animation.x = x
	animation.y = y
	animation:play()

	layers.content:insert(animation)

	--

	return animation
end


function createPlayer( x, y, width, height )
	local player = ssk.display.imageRect( layers.content, x, y,imagesDir .. "AriFeldman/enemyPlaneBlue.png",
										{ w = width, h = height, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
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