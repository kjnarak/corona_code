local physics = require("physics")
local lib_bubble = require("lib_bubble")

local screenW = display.contentWidth
local screenH = display.contentHeight
local screenHW = screenW *.5
local screenHH = screenH *.5
local Random = math.random
	
local function MySimulation()
	physics.start()
	--Make a little less gravity to slow the fall time
	physics.setGravity(0, 2)
	
	--Max onscreen bubbles and counter
	local maxBubbles = 10
	local popCounter = 0
	
	--Some forward declarations
	local bubble = nil
	local spawnTimer = nil
	local EndGame = nil
	
	--Some Group work
	local levelGroup = display.newGroup()
	local groundGroup = display.newGroup()
	levelGroup:insert(groundGroup)
	local bubbleGroup = display.newGroup()
	levelGroup:insert(bubbleGroup)
	
	--Make a quick bubble counter
	local bubbleCounter = display.newText(levelGroup, popCounter, 20, 20, native.systemFont, 20)
	
	--Simple, re-usable function to create physics boundaries on your device
	local function MakeCollisionBounds()
		local tRectTop = display.newRect(groundGroup, 0, 0, screenW, 10)
		physics.addBody(tRectTop, "static", {density = 1.0, friction = 1.0})
		local tRectBottom = display.newRect(groundGroup, 0, screenH - 10, screenW, 10)
		physics.addBody(tRectBottom,  "static", {density = 1.0, friction = 1.0})
		tRectBottom.name = "ground"
		local tRectLeft = display.newRect(groundGroup, 0, 0, 10, screenH)
		physics.addBody(tRectLeft, "static", {density = 1.0, friction = 1.0})
		local tRectRight = display.newRect(groundGroup, screenW - 10, 0, 10, screenH)
		physics.addBody(tRectRight, "static", {density = 1.0, friction = 1.0})		
	end
	MakeCollisionBounds()
		
	--Lets keep collision in the main, makes game-wide communication easier
	function BubbleCollisionHandler(self, event)
		if(event.phase == "began")then
			if(event.other.name == "ground")then
				self.alive = false
				print("Game Over")
				event.other:setFillColor(255,0,0)
				EndGame()
			end
		end	
		return true
	end
	
	--Lets keep the Touch handler in the main as well
	function BubbleTouchHandler(self, event)
		if(self.alive)then
			self.alive = false

			if (event.phase == "began") then
				print("Pop")
				timer.performWithDelay(1, function()
					self:kill()
				end)
				popCounter = popCounter + 1
				bubbleCounter.text = popCounter
			end
		end
		return true
	end
	
	--Kill 'em All \m/ \m/
	function EndGame()
		if(spawnTimer)then
			timer.cancel(spawnTimer)
		end	
		--Notice how easy it is to kill'em since we made a
		--nice group to put them in
		for i=bubbleGroup.numChildren,1,-1 do
			bubbleGroup[i]:kill()
		end
	end
	
	--Bubble Spawner
	function CreateBubble()
		if(bubbleGroup.numChildren < maxBubbles)then
			--Creation from module
			local bubble = bubbleLib:NewBubble(bubbleGroup, BubbleCollisionHandler, BubbleTouchHandler)
		end
	end

	--Create one every 1/2 of a second
	spawnTimer = timer.performWithDelay(500, CreateBubble, 0)
end
MySimulation()