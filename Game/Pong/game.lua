local scene={}

local function new()
	local localgroup=display.newGroup() -- LocalGroup for SceneManager
	
	------------------------------------------------
	--Require
	------------------------------------------------
	
	local sceneManager=require("scenemanager")
	local ponghelper=require("ponghelper")
	
	local physics=require("ParticlePhysics").createPhysics()
	


	------------------------------------------------
	--Localize
	------------------------------------------------
	
	local middleX=display.contentCenterX
	local middleY=display.contentCenterY
	local right=display.contentWidth
	local left=0
	local top=0
	local bottom=display.contentHeight
	
	local newButton=ponghelper.newButton
	local clamp=ponghelper.clamp
	local roundToNearest=ponghelper.roundToNearest
	local pointInRect=ponghelper.pointInRect
	
	local newText=display.newText
	
	local screenRectListener
	local screenRect
	local lock
	local unlock
	local ballColors
	local cpuHeight
	local startVel
	local ballVel
	local ballRebound
	
	local onReset
	local resetRect
	local addReset
	local removeReset
	
	local timerText
	local timeLeft
	local timerListener
	
	local paddleSpeed
	local playerHeight
	
	local roof
	local floor
	
	local cpu
	local cpuColor
	local cpuMessages
	
	local player
	local touchSensor
	local touchPlayer
	local canDrag
	local playerMessages
	
	local newBall
	local ball
	
	local onEnterFrame
	local enterFrame
	
	local hitText
	local hits
	
	local pointText
	local playerPoints
	local cpuPoints
	local continueText
	
	local notDone
	
	
	
	------------------------------------------------
	--Variables
	------------------------------------------------
	
	--Load previously saved values
	paddleSpeed=ponghelper.load("paddlespeed")
	playerHeight=ponghelper.load("playerheight")
	numPoints=ponghelper.load("numpoints")
	cpuColor=ponghelper.load("CPUColor")
	cpuHeight=ponghelper.load("cpuHeight")
	startVel=ponghelper.load("ballVel")
	ballRebound=ponghelper.load("ballRebound") or 1.0
	
	ballVel=startVel
	
	hits=0
	
	enterFrame=false -- Whether the EnterFrame listener executes
	cpuPoints=0 -- Point values
	playerPoints=0
	
	timeLeft=3 -- Starting timer value
	canDrag=true -- Whether you can move the player
	notDone=true
	
	
	------------------------------------------------
	--Walls
	------------------------------------------------
	
	roof=display.newImage("assets/wall.png", true) -- Final "true" parameter is for scaling of large image
	roof:setFillColor(0, 0, 255) -- Blue
	roof.x, roof.y=middleX, top+5
	localgroup:insert(roof)
		
	floor=display.newImage("assets/wall.png", true)
	floor:setFillColor(0, 0, 255)
	floor.x, floor.y=middleX, bottom-5
	localgroup:insert(floor)
	
	
	
	------------------------------------------------
	--Screen Locking/Unlocking
	------------------------------------------------
	
	function screenRectListener(event) -- Blank touch event
		return true
	end
	
	screenRect=display.newRect(0, 0, right, bottom) -- The screen size
	screenRect.x, screenRect.y=middleX, middleY
	screenRect:setFillColor(0, 0, 0)
	screenRect.alpha=0.75 -- Make a darker background to start with - we'll make it invisible when the timer finishes
	localgroup:insert(screenRect)

	function lock()
		canDrag=false -- So you can't move the player when the screen "locks"		
		screenRect.isHitTestable=true
		screenRect:toFront() -- Make sure the screener is in front
	end
	
	function unlock()
		canDrag=true -- Unlock the player movement
		screenRect.isHitTestable=false
	end
	
	screenRect:addEventListener("touch", screenRectListener) -- Add the listener



	------------------------------------------------
	--Reset
	------------------------------------------------
	
	function onReset(event) -- Blank touch event
		if "ended"==event.phase then
			if not touchSensor.isFocus then
				if notDone then
					timer.performWithDelay(500, newBall)
					continueText.isVisible=false
					ball.removePaths()
					ball.x, ball.y=middleX, middleY
					ball:setFillColor(255, 255, 255)
					removeReset()
				else
					sceneManager:changeScene("menu")
				end
			end
		end
		return true
	end
	
	resetRect=display.newRect(0, 0, right, bottom)
	resetRect.x, resetRect.y=middleX, middleY
	resetRect:setFillColor(0, 0, 0)
	resetRect.alpha=0
	localgroup:insert(resetRect)

	function addReset()
		resetRect.alpha=0.75
		resetRect.isHitTestable=true
		resetRect:toFront()
		continueText:toFront()
		canDrag=false
	end
	
	function removeReset()
		resetRect.alpha=0
		canDrag=true
		resetRect.isHitTestable=false
	end
	
	resetRect:addEventListener("touch", onReset)
	
	

	------------------------------------------------
	--Start Timer
	------------------------------------------------

	timerText=newText(timeLeft, 0, 0, "Trebuchet MS", 100) -- Build the timer's display
	timerText.x, timerText.y=middleX, middleY
	localgroup:insert(timerText)
	timerText.xScale, timerText.yScale=9, 9
	timerText.trans=transition.to(timerText, {xScale=1, yScale=1, time=500}) -- Shrink it down with a transition
	
	function timerListener()
		if timeLeft>1 then
			timeLeft=timeLeft-1 -- Subtract 1 from the remaining time
			timerText.text=timeLeft -- Reset the text
			timerText.xScale, timerText.yScale=9, 9 -- Reset the xScale and yScale...
			timerText.trans=transition.to(timerText, {xScale=1, yScale=1, time=500}) -- ...And shrink it down again
		else
			timeLeft=0
			timerText.xScale, timerText.yScale=9, 9
			timerText.trans=transition.to(timerText, {xScale=1, yScale=1, time=500})
			timerText.text=timeLeft
			timerText.finishTimer=timer.performWithDelay(750, function() -- 750 so that we have a 250 millisecond delay
					timerText.isVisible=false -- Hide the timerText
					unlock() -- Unlock the screen
					newBall() -- Initialize the ball
					screenRect.alpha=0 -- Hide the screener
					enterFrame=true -- Start the EnterFrame listener
				end)
		end
	end
	timer.performWithDelay(1000, timerListener, timeLeft) -- Start the timer



	------------------------------------------------
	--CPU
	------------------------------------------------

	cpu=display.newImage("assets/paddle"..cpuHeight..".png")
	cpu.x, cpu.y=right-30, middleY
	cpu:setFillColor(unpack(cpuColor)) -- Set fill color to the loaded cpuColor
	cpu.isTracking=true -- Whether or not the CPU follows the ball
	localgroup:insert(cpu)
	
	cpuMessages={
		"Oops...",
		"Try again.",
		"Missed!",
		"Uh oh...",
		"CPU Point!"
	}


	
	------------------------------------------------
	--Player
	------------------------------------------------

	player=display.newImage("assets/paddle"..playerHeight..".png") -- The player changes height according to difficulty, so we need to use different images
	player.x, player.y=left+30, middleY
	player:setFillColor(255, 255, 0) -- Player is yellow
	physics.addBody(player, {})
	player.moveSpeed=0 -- This is the value added to the ball's velocity when colliding - the faster you move your paddle, the greater this is
	localgroup:insert(player)
	player.prevY=0
	
	playerMessages={
		"Good!",
		"Player Point!",
		":]",
		"+1"
	}
	
	touchSensor=display.newImage("assets/touchSensor.png") -- The touch bounds for moving the player
	touchSensor.x, touchSensor.y=left+100, middleY
	localgroup:insert(touchSensor)
		
	function touchPlayer(event)
		if "began"==event.phase then
			player.y1=event.y-player.y
			player.prevY=player.y
			display.getCurrentStage():setFocus(touchSensor) -- Set focus to touchSensor
			touchSensor.isFocus=true
		elseif touchSensor.isFocus then
			if "moved"==event.phase and canDrag then -- Only if canDrag is active
				if event.y-player.y1>=top+60 and event.y-player.y1<=bottom-60 then -- Snap to bounds
					player.y=event.y-player.y1 -- Reposition player
				elseif event.y-player.y1<top+60 then
					player.y=top+60
				elseif event.y-player.y1>bottom-60 then
					player.y=bottom-60
				end
				player.moveSpeed=player.y-player.prevY -- MoveSpeed is the difference between previous position and new position - the faster you move, the more it is
				player.prevY=player.y -- Reset prevY
				
			elseif "ended"==event.phase then
				display.getCurrentStage():setFocus(nil) -- "Un-focus" the touchSensor
				touchSensor.isFocus=false
			end
		end
	end
	touchSensor:addEventListener("touch", touchPlayer) -- Add listener
	
	
	
	------------------------------------------------
	--Ball
	------------------------------------------------
	
	ball=display.newImage("assets/ball.png") -- This is the actual Pong ball
	ball:setFillColor(255, 255, 255) -- White to start with
	physics.addBody(ball, {}) -- ParticlePhysics physics body added to the ball
	localgroup:insert(ball)
	ball.x, ball.y=middleX, middleY -- In the middle of the screen
	ball.path={} -- Table to hold the ball's path lines
	ball.I=1; ball.O=1 -- Values for the next path to remove and the next path to create
	ball.PrevX=0; ball.PrevY=0 -- Must have a capital "P" as ParticlePhysics uses the "prevX" and "prevY" names

	function ball.removePaths()
		for i=1, ball.O do -- Iterate through and remove all joints and paths
			if ball.path[i] then
				display.remove(ball.path[i].joint)
				ball.path[i].joint=nil
				display.remove(ball.path[i])
				ball.path[i]=nil
			end
		end
		ball.O=1; ball.I=1
	end

	function newBall() -- Function to reset the ball
		ballVel=startVel
	
		physics.start() -- Start ParticlePhysics
		enterFrame=true -- Start the EnterFrame listener
				
		ball.x, ball.y=middleX, middleY -- And the ball's
		ball.PrevX, ball.PrevY=ball.x, ball.y -- And the PrevX and PrevY
			
		local velX, velY=math.random(-1, 1)*ballVel, math.random(-1, 1)*ballVel -- Make a random velocity, clamped to -10 or 10 for uniformity 
		if velX==0 then -- Make sure neither velX nor velY is 0
			velX=ballVel
		end
		if velY==0 then
			velY=-ballVel
		end
		
		if velX<0 then -- If the ball is going towards the character, the CPU doesn't need to move
			cpu.isTracking=false
			ball:setFillColor(unpack(cpuColor))
		else
			cpu.isTracking=true
			ball:setFillColor(255, 255, 0)
		end
		
		ball:setLinearVelocity(velX, velY) -- Set velocity
		
	end
	
	
	
	------------------------------------------------
	--Hits
	------------------------------------------------
	
	hitText=newText("0", 0, 0, "Trebuchet MS", 30)
	hitText.x, hitText.y=middleX, top+70
	localgroup:insert(hitText)
	
	
	------------------------------------------------
	--Points
	------------------------------------------------
	
	pointText=newText("Player: 0           CPU: 0", 0, 0, "Trebuchet MS", 30) -- So many spaces because we only have one text object
	pointText.x, pointText.y=middleX, bottom-70
	localgroup:insert(pointText)
	
	continueText=newText("Nice Shot!", 0, 0, right, 0, "Trebuchet MS", 40) -- General display
	continueText.x, continueText.y=512, 384
	localgroup:insert(continueText)
	continueText.isVisible=false -- Hidden
	
	
	
	------------------------------------------------
	--EnterFrame
	------------------------------------------------
	
	function onEnterFrame()
		if enterFrame then
		
			------------
			--Move the CPU
			------------
			
			if cpu.isTracking then -- Only if isTracking is turned on
				cpu.y=clamp(cpu.y+roundToNearest((cpu.y-(ball.y))/5, -paddleSpeed, paddleSpeed), 60, bottom-60)
			end
			
			
			------------
			--Check for Roof/Floor Collision
			------------
			
			if ball.y>bottom-20 then
				ball.velY=-math.abs(ball.velY) -- Always a negative value
			elseif ball.y<top+20 then
				ball.velY=math.abs(ball.velY) -- Always a positive value
			end
			
			
			------------
			--Check for Paddle Collision
			------------
			
			if pointInRect(ball.x, ball.y, player.x-player.width/2, player.y-player.height/2, player.width, player.height) then -- Player paddle collision
				ball.velX=math.abs(ball.velX+math.abs(player.moveSpeed))
				cpu.isTracking=true -- Make the CPU follow the ball
				ball:setFillColor(255, 255, 0)
				hits=hits+1
				hitText.text=hits
			elseif pointInRect(ball.x, ball.y, cpu.x-cpu.width/2, cpu.y-cpu.height/2, cpu.width, cpu.height) then -- CPU paddle collision
				local v=roundToNearest(ball.velX, -ballVel, ballVel) -- Set the velocity to either -10 or 10 - we don't want a perfect deflection, just a hit back
				if v~=0 then
					ball.velX=-math.abs(v)
				else
					ball.velX=-ballVel
				end
				
				ballVel=ballVel+(ballVel/ballRebound)
						
				ball:setFillColor(unpack(cpuColor))
				
				cpu.isTracking=false -- Don't follow the ball
				
				hits=hits+1
				hitText.text=hits
			end
			
			
			
			------------
			--Ball Path
			------------
			
			if ball.O>80 then -- If the path is long enough
				display.remove(ball.path[ball.I].joint) -- Remove the ball.I joint
				ball.path[ball.I].joint=nil
				display.remove(ball.path[ball.I]) -- Remove the ball.I path
				ball.path[ball.I]=nil
				ball.I=ball.I+1 -- Add one to ball.I
			end
						
			ball.path[ball.O]=display.newLine(ball.x, ball.y, ball.PrevX, ball.PrevY) -- Make a new path line
			ball.path[ball.O].width=4
			localgroup:insert(ball.path[ball.O])

			ball.path[ball.O].joint=display.newCircle(0, 0, 2) -- To smooth the path
			ball.path[ball.O].joint.x, ball.path[ball.O].joint.y=ball.x, ball.y
			localgroup:insert(ball.path[ball.O].joint)
			
			if cpu.isTracking then -- In other words, "If the last one to hit it was you"
				ball.path[ball.O]:setColor(255, 255, 0)
				ball.path[ball.O].joint:setFillColor(255, 255, 0)
			else -- Otherwise the last one to hit it was the CPU
				ball.path[ball.O]:setColor(unpack(cpuColor))
				ball.path[ball.O].joint:setFillColor(unpack(cpuColor))
			end
			
			ball.PrevX, ball.PrevY=ball.x, ball.y -- Reset PrevX and PrevY
			
			ball.O=ball.O+1 -- Plus 1 to the number of path lines
			
			
			------------
			--Check for Goal
			------------
			
			if ball.x<left then -- CPU point
			
				if cpuPoints<numPoints-1 then -- If the CPU hasn't won
					physics.pause() -- Pause the physics
					enterFrame=false -- Pause the EnterFrame listener
					cpuPoints=cpuPoints+1 -- Add a point to the CPU
					continueText.text=cpuMessages[math.random(#cpuMessages)] -- Set a random "lose" message
					continueText.isVisible=true
					
					addReset()
					
					hits=0
					hitText.text=hits	
				else
					physics.pause()
					enterFrame=false
					continueText.isVisible=true
					continueText.text="You Lost..."
					
					cpuPoints=cpuPoints+1
					
					notDone=false
					
					addReset()
				end
			elseif ball.x>right then -- Player point
				if playerPoints~=numPoints-1 then -- If you haven't won
					physics.pause()
					enterFrame=false
					playerPoints=playerPoints+1 -- Add a point to you
					if ball.velX>ballVel+30 then -- Check for a "slammed" ball
						continueText.text="Nice Shot!\n\nVelocity: "..ball.velX.."" -- Set the text
					else
						continueText.text=playerMessages[math.random(#playerMessages)] -- A random "win" message
					end
					continueText.isVisible=true
					
					addReset()
					
					hits=0
					hitText.text=hits
				else
					physics.pause()
					enterFrame=false
					continueText.isVisible=true
					continueText.text="You Won!"
					
					playerPoints=playerPoints+1
					
					notDone=false
					
					addReset()
				end
			end
			
			
			------------
			--Decrement Ball Hit velocity
			------------			
			
			if player.moveSpeed>0 then -- Lower it, either negatively or positively
				player.moveSpeed=player.moveSpeed-0.08
			elseif player.moveSpeed<0 then
				player.moveSpeed=player.moveSpeed+0.08
			end
			
			
			--Reset the text
			pointText.text="Player: "..playerPoints.."           CPU: "..cpuPoints
			
			
		end
	end
	Runtime:addEventListener("enterFrame", onEnterFrame)
	
	lock()
	timerText:toFront()
	
	
	return localgroup
end

scene.new=new
return scene