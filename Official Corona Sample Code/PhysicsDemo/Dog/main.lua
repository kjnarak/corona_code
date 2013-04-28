-- Cut the Rope Inspired Game
-- Developed by Carlos Yanez

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Physics

local physics = require('physics')
physics.start()
--physics.setDrawMode('hybrid')

-- Graphics

-- [Background]

local bg = display.newImage('bg.png')

-- [Title View]

local titleBg
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- Instructions

local ins

-- Dog

local dog

-- Shadow Stars

local s1
local s2
local s3

-- Hang

local hang

-- Bone

local bone

-- Alert

local alertView

-- Sounds

local starSnd = audio.loadSound('star.mp3')
local bite = audio.loadSound('bite.mp3')

-- Variables

local lastY
local ropeParts = display.newGroup()
local initX
local initY
local lines = display.newGroup()
local line
local collected = 0

-- Levels

local l1 = {{0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 2, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 2, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 2, 0, 0, 0, 0, 0},}

-- Functions

local Main = {}
local startButtonListeners = {}
local showCredits = {}
local hideCredits = {}
local showGameView = {}
local loadLevel = {}
local gameListeners = {}
local drawLine = {}
local ropeCollision = {}
local starBoneCollision = {}
local alert = {}

-- Main Function

function Main()
	titleBg = display.newImage('titleBg.png', 40, 57)
	playBtn = display.newImage('playBtn.png', 125, 225)
	creditsBtn = display.newImage('creditsBtn.png', 115, 286)
	titleView = display.newGroup(titleBg, playBtn, creditsBtn)
	
	startButtonListeners('add')
end

function startButtonListeners(action)
	if(action == 'add') then
		playBtn:addEventListener('tap', showGameView)
		creditsBtn:addEventListener('tap', showCredits)
	else
		playBtn:removeEventListener('tap', showGameView)
		creditsBtn:removeEventListener('tap', showCredits)
	end
end

function showCredits:tap(e)
	playBtn.isVisible = false
	creditsBtn.isVisible = false
	creditsView = display.newImage('credits.png', 0, display.contentHeight)
	
	lastY = titleBg.y
	transition.to(titleBg, {time = 300, y = (display.contentHeight * 0.5) - (titleBg.height + 50)})
	transition.to(creditsView, {time = 300, y = (display.contentHeight * 0.5) + 35, onComplete = function() creditsView:addEventListener('tap', hideCredits) end})
end

function hideCredits:tap(e)
	transition.to(creditsView, {time = 300, y = display.contentHeight + 25, onComplete = function() creditsBtn.isVisible = true playBtn.isVisible = true creditsView:removeEventListener('tap', hideCredits) display.remove(creditsView) creditsView = nil end})
	transition.to(titleBg, {time = 300, y = lastY});
end

function showGameView:tap(e)
	transition.to(titleView, {time = 300, x = -titleView.height, onComplete = function() startButtonListeners('rmv') display.remove(titleView) titleView = nil end})
	
	-- [Add GFX]
	
	-- Instructions
	
	ins = display.newImage('instructions.png', 205, 360)
	
	-- Dog
	
	dog = display.newImage('dog.png', 128, 408)
	dog.name = 'dog'
	
	-- Shadow Stars
	
	s1 = display.newImage('starShadow.png', 3, 3)
	s2 = display.newImage('starShadow.png', 33, 3)
	s3 = display.newImage('starShadow.png', 63, 3)
	
	-- [Set Dog Physics]
	
	physics.addBody(dog, 'static', {radius = 14})
	dog.isSensor = true
	
	loadLevel(1)
	gameListeners('add')
end

function loadLevel(n)
	for i = 1, 10 do
		for j = 1, 10 do
			if(l1[j][i] == 1) then
				hang = display.newImage('hang.png', i*31, j*32)
				physics.addBody(hang, 'static', {radius = 8})
				
				bone = display.newImage('bone.png', i*29.5, j*32 + (90))
				physics.addBody(bone, 'dynamic', {shape = {-21.5, -5.5, 18.5, -12.5, 20.5, 2.5, -18.5, 11.5}})
			elseif(l1[j][i] == 2) then
				local star = display.newImage('star.png', i*29, j*28)
				star.name = 'star'
				physics.addBody(star, 'static', {radius = 15})
				star.isSensor = true
			end
		end
	end
	
	-- Add Rope
	
	for k = 1, 8 do
		local ropePart = display.newImage('rope.png', hang.x - 3, (hang.y-3) + k*10) --10 = rope part height
		ropePart.name = 'rope'
		
		physics.addBody(ropePart)
		ropeParts:insert(ropePart)
		
		-- Hang joint
		
		if(k == 1) then
			local hangJoint = physics.newJoint('pivot', hang, ropePart, hang.x - 3, hang.y)
		end
		
		-- Rope Joints
		
		if(k > 1) then
			local joint = physics.newJoint('pivot', ropeParts[k-1], ropeParts[k], hang.x - 3, ropePart.y)
		end
		
		-- Bone joint
		
		if(k == 8) then
			local boneJoint = physics.newJoint('pivot', ropePart, bone, hang.x - 3, ropePart.y)
		end
	end
end

function gameListeners(action)
	if(action == 'add') then
		bone:addEventListener('collision', starBoneCollision)
		bg:addEventListener('touch', drawLine)
	else
		bone:removeEventListener('collision', starBoneCollision)
		bg:removeEventListener('touch', drawLine)
	end
end

function drawLine(e)
	if(e.phase == 'began') then
		initX = e.x
		initY = e.y
	elseif(e.phase == 'moved') then
		line = display.newLine(initX, initY, e.x, e.y)
		physics.addBody(line, 'static')
		line.isSensor = true
		line:addEventListener('collision', ropeCollision)
		line.width = 5
		lines:insert(line)
	elseif(e.phase == 'ended') then
		display.remove(lines)
		lines = nil
		lines = display.newGroup()
	end
end

function ropeCollision(e)
	if(e.other.name == 'rope') then
		display.remove(e.other)
	end
end

function starBoneCollision(e)
	if(e.other.name == 'star') then
		display.remove(e.other)
		audio.play(starSnd)
		collected = collected + 1
		
		if(collected == 1) then
			local s1 = display.newImage('star.png', -10, -10)
		elseif(collected == 2) then
			local s2 = display.newImage('star.png', 21, -10)
		elseif(collected == 3) then
			local s3 = display.newImage('star.png', 51, -10)
		end
		
	elseif(e.other.name == 'dog') then
		display.remove(e.target)
		audio.play(bite)
		
		alert()
	end
end

function alert()
	gameListeners('rmv')
	alert = display.newImage('alert.png', (display.contentWidth * 0.5) - 105, (display.contentHeight * 0.5) - 55)
	transition.from(alert, {time = 300, xScale = 0.5, yScale = 0.5})
	
	-- Wait 1 second to stop physics
	timer.performWithDelay(1000, function() physics.stop() end, 1)
end

Main()