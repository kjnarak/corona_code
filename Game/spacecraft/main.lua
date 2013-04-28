-- Space Shooter Game
-- Developed by Carlos Yanez

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Import MovieClip Library

local movieclip = require('movieclip')

-- Import Physics

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

-- Graphics

-- Background

local bg = display.newImage('bg.png')

-- [Title View]

local title
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- [Ship]

local ship

-- [Boss]

local boss

-- [Score]

local score

-- [Lives]

local lives

-- Load Sounds

local shot = audio.loadSound('shot.mp3')
local explo = audio.loadSound('explo.mp3')
local bossSound = audio.loadSound('boss.mp3')

-- Variables

local timerSource
local lives = display.newGroup()
local bullets = display.newGroup()
local enemies = display.newGroup()
local scoreN = 0
local bossHealth = 20

-- Functions

local Main = {}
local addTitleView = {}
local showCredits = {}
local removeCredits = {}
local removeTitleView = {}
local addShip = {}
local addScore = {}
local addLives = {}
local listeners = {}
local moveShip = {}
local shoot = {}
local addEnemy = {}
local alert = {}
local update = {}
local collisionHandler = {}
local restart = {}

-- Main Function

function Main()
	addTitleView()
end

function addTitleView()
	title = display.newImage('title.png')
	playBtn = display.newImage('playBtn.png')
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY + 10
	playBtn:addEventListener('tap', removeTitleView)
	
	creditsBtn = display.newImage('creditsBtn.png')
	creditsBtn.x = display.contentCenterX
	creditsBtn.y = display.contentCenterY + 60
	creditsBtn:addEventListener('tap', showCredits)
	
	titleView = display.newGroup(title, playBtn, creditsBtn)
end

function removeTitleView:tap(e)
	transition.to(titleView,  {time = 300, y = -display.contentHeight, onComplete = function() display.remove(titleView) titleView = null addShip() end})
end

function showCredits:tap(e)
	creditsBtn.isVisible = false
	creditsView = display.newImage('creditsView.png')
	creditsView:setReferencePoint(display.TopLeftReferencePoint)
	transition.from(creditsView, {time = 300, x = display.contentWidth})
	creditsView:addEventListener('tap', removeCredits)
end

function removeCredits:tap(e)
	creditsBtn.isVisible = true
	transition.to(creditsView, {time = 300, x = display.contentWidth, onComplete = function() display.remove(creditsView) creditsView = null end})
end

function addShip()
	ship = movieclip.newAnim({'shipA.png', 'shipB.png'})
	ship.x = display.contentWidth * 0.5
	ship.y = display.contentHeight - ship.height
	ship.name = 'ship'
	ship:play()
	physics.addBody(ship)
	
	addScore()
end

function addScore()
	score = display.newText('Score: ', 1, 0, native.systemFontBold, 14)
	score.y = display.contentHeight - score.height * 0.5
	score.text = score.text .. tostring(scoreN)
	score:setReferencePoint(display.TopLeftReferencePoint)
	score.x = 1
	
	addLives()
end

function addLives()
	for i = 1, 3 do
		live = display.newImage('live.png')
		live.x = (display.contentWidth - live.width * 0.7) - (5 * i+1) - live.width * i + 20
		live.y = display.contentHeight - live.height * 0.7
		
		lives.insert(lives, live)
	end
	listeners('add')
end

function listeners(action)
	if(action == 'add') then	
		bg:addEventListener('touch', moveShip)
		bg:addEventListener('tap', shoot)
		--Runtime:addEventListener('enterFrame', update)
		timerSource = timer.performWithDelay(800, addEnemy, 0)
	else
		bg:removeEventListener('touch', moveShip)
		bg:removeEventListener('tap', shoot)
		Runtime:removeEventListener('enterFrame', update)
		timer.cancel(timerSource)
	end
end

function moveShip:touch(e)
	if(e.phase == 'began') then
		lastX = e.x - ship.x
	elseif(e.phase == 'moved') then
		ship.x = e.x - lastX
	end
end

function shoot:tap(e)
	local bullet = display.newImage('bullet.png')
	bullet.x = ship.x
	bullet.y = ship.y - ship.height
	bullet.name = 'bullet'
	physics.addBody(bullet)
	
	audio.play(shot)
	
	bullets.insert(bullets, bullet)
end

function addEnemy(e)
	local enemy = movieclip.newAnim({'enemyA.png', 'enemyA.png','enemyA.png','enemyA.png','enemyA.png','enemyA.png','enemyB.png','enemyB.png','enemyB.png','enemyB.png','enemyB.png','enemyB.png'})
	enemy.x = math.floor(math.random() * (display.contentWidth - enemy.width))
	enemy.y = -enemy.height
	enemy.name = 'enemy'
	physics.addBody(enemy)
	enemy.bodyType = 'static'
	enemies.insert(enemies, enemy)
	enemy:play()
--	enemy:addEventListener('collision', collisionHandler)
end

function alert(e)
	listeners('remove')
	local alertView
	
	if(e == 'win') then
		alertView = display.newImage('youWon.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	else
		alertView = display.newImage('gameOver.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	end
	
	--alertView:addEventListener('tap', restart)
end

Main()