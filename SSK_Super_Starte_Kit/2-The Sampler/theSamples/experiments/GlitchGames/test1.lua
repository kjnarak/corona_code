-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #2
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
local backImage
local theChart

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createChart

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
	
	timer.performWithDelay(250, 
		function() 
			theChart = createChart( layers.content, centerX, centerY, w, h, 2 )
		end )

	table.dump( theChart )


end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	theChart:destroy()
	theChart = nil

	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
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
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	

createChart = function ( group, x, y, width, height, chartNum )

	local chartNum = chartNum or 1
	local chart

	if( chartNum == 1) then
		chart = ssk.ggchart:new
		{
			type = "line",
			mode = "standard",
			title = "Random Line Chart",
			legend = "Green|Red",
			legendPosition = "b",
			dataColours = "008000,FF0000",
			data = "t:10,120,40,80,90,95,99|20,30,40,50,60,70,80",
			width = width,
			height = height,
			margins = { 20, 0, 0, 20 },
			x = -10000,
			y = -10000
		}
	elseif( chartNum == 2) then
		chart = ssk.ggchart:new
		{
			type = "pie",
			title = "Android Distribution - Percent",
			legend = "3.9|6.3|31.4|57.6|0.8",
			legendPosition = "r",
			width = width,
			height = height,
			labels = "Android 1.5|Android 1.6|Android 2.1|Android 2.2|Android 2.3",
			data = "t:3.9,6.3,31.4,57.6,0.8",
			mode = "2d",
			dataColours = "C4DF9B|AFD377|9AC653|84BA2F|6FAD0C",
			scale = { 0, 100 },
			margins = { 20, 0, 0, 20 },
			x = -10000,
			y = -10000
		}
	elseif( chartNum == 3) then
		chart = ssk.ggchart:new
		{ 
			type = "qr",
			data = "Corona Rocks!",
			width = width,
			margin = 1,
			background = "bg,s,FFFF00",
			errorCorrectionLevel = "L",
			x = -10000,
			y = -10000
		}
	end
	chart.image:setReferencePoint( display.CenterReferencePoint )
	chart.image.x = x
	chart.image.y = y

	group:insert(chart.image)

	return chart

end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic