bubbleLib = {}

local screenW = display.contentWidth
local screenH = display.contentHeight
local screenHW = screenW *.5
local screenHH = screenH *.5
local Random = math.random

function bubbleLib:NewBubble(inGFXGroup, inCollisionCallback, inTouchCallback)
	local bubble = nil
	
	bubbleSize = Random(15, 30)
	
	bubble = display.newCircle(inGFXGroup, Random(bubbleSize, screenW), Random(bubbleSize, screenH * .6), bubbleSize * 2)
	bubble:setFillColor(150,150,150)
	physics.addBody(bubble, "dynamic", {density=0.2, friction=0.0, bounce=0.5, radius=bubbleSize *.5})
	bubble.alive = true
	
	if(inCollisionCallback)then
		bubble.collision = inCollisionCallback
		bubble:addEventListener("collision", bubble)
	end
	
	if(inTouchCallback)then
		bubble.touch = inTouchCallback
		bubble:addEventListener("touch", bubble)
	end
	
	-- This could be here too, and another method could be used to
	-- count the PoPs, but I like to put my main EVENTS, in main :)
	-- function bubble:touch(event)
		-- print("Pop")
		-- if(self.alive)then
			-- self.alive = false
			-- if (event.phase == "began") then
				-- timer.performWithDelay(1, function()
					-- self:kill()
				-- end)
			-- end
		-- end
	-- end
	-- bubble:addEventListener("touch", bubble)
			
	function bubble:kill()
		if(bubble.collision)then
			self:removeEventListener("collision", self)
		end
		if(bubble.touch)then
			self:removeEventListener("touch",self)
		end
		
		self:removeSelf()			
	end

	return bubble
end