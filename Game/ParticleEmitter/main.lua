
local lib_emitter = require("lib_emitter")

local Random = math.random

local screenW = display.contentWidth
local screenH = display.contentHeight
local screenHW = screenW *.5
local screenHH = screenH *.5

--Base emitter props
local radiusRange = 100

local duration = 1200 --800
local startAlpha = 1
local endAlpha = 0
local pImage = nil
local pImageWidth = nil
local pImageHeight = nil
local emitterDensity = 40

--Mortar props
local mortarSpeed = 200
local mortarEmitterDensity = 40
local mortarRadiusRange = 100
local mortarThickness = 4
local mortarEmitter = emitterLib:createEmitter(radiusRange, mortarThickness, duration, startAlpha, endAlpha, pImage, pImageWidth, pImageHeight)

--Sprayer props
local sprayerSpeed = 200
local sprayerEmitterDensity = 40
local sprayerRadiusRange = 70
local sprayerThickness = 3
local sprayerEmitter = emitterLib:createEmitter(sprayerRadiusRange, sprayerThickness, duration, startAlpha, endAlpha, pImage, pImageWidth, pImageHeight)
--This will be a random color emitter
sprayerEmitter:setColor(-1)

--Keep it tidy
local levelGroup = display.newGroup()

local function SprayStyleEmitter(px, py)
	timer.performWithDelay(10, function()
		sprayerEmitter:emit(levelGroup, px, py)
	end, sprayerEmitterDensity)
end

local function ExplodeStyleEmitter(px, py)
	mortarEmitter:setColor(Random(20,255),Random(20,255),Random(20,255))
		
	for i=1,mortarEmitterDensity do
		mortarEmitter:emit(levelGroup, px, py)
	end
end

local function ShootFirework()
	local mortar = display.newRect(levelGroup, screenHW, screenH, 4, 8)
	local px = Random(30, screenW-30)
	local py = Random(30, screenH-180)

	local function mortarExplode(Obj)
		display.remove(Obj)
		Obj = nil
		
		--How about a little poof to boot
		local pop = display.newCircle(levelGroup, px, py, Random(10,20))
		local function DestroyPop(Obj)
			display.remove(Obj)
			Obj = nil
		end
		transition.to(pop, {time=100, alpha = 0, onComplete=DestroyPop})
		--end of extra poof code
		
		ExplodeStyleEmitter(px, py)
	end
	
	transition.to(mortar, {time=2000, x=px, y=py, onComplete=mortarExplode})
end

local function StartSprayer()
	local px = Random(30, screenW-30)
	local py = Random(screenH-60, screenH-30)
	
	SprayStyleEmitter(px, py)
end

local function StartShow()
	--Start mortar volley
	timer.performWithDelay(mortarSpeed, function()
		ShootFirework()
	end, 0)
	
	--Start srayers
	timer.performWithDelay(sprayerSpeed, function()
		StartSprayer()
	end, 0)
	
	local title = display.newText("Corona SDK", 0, 0, native.systemFont, 74)
	title:setTextColor(225, 160, 12)
	title:setReferencePoint(display.CenterReferencePoint)
	title.x = screenHW
	title.y = 200
	title.alpha = 0
	timer.performWithDelay(4000, function() transition.to(title, {time=4000, alpha=1}) end)
end

StartShow()
