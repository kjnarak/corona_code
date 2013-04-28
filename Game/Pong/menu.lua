local scene={}

local function new()
	local localgroup=display.newGroup() -- LocalGroup for SceneManager
	
	------------------------------------------------
	--Require
	------------------------------------------------
	
	local sceneManager=require("scenemanager")
	local ponghelper=require("ponghelper")
	
	
	
	------------------------------------------------
	--Localize
	------------------------------------------------
	
	local middleX=display.contentCenterX
	local middleY=display.contentCenterY
	
	local newButton=ponghelper.newButton
	local newText=display.newText
		
	local difButton
	local difLabel
	local difficulty
	local onDifRelease
	
	local label
	local labelColors
	
	local playButton
	local playLabel
	local playGame
	
	local pointButton
	local pointLabel
	local points
	
	
	
	------------------------------------------------
	--Variabiables
	------------------------------------------------
	
	difficulty="Easy" -- Difficulty starts out at easy
	points=5 -- Number of needed points start out at 5
	
	
	
	------------------------------------------------
	--Label
	------------------------------------------------
	
	labelColors={ -- Colors for the label's color change
		{255, 255, 0},
		{255, 0, 0},
		{0, 0, 255},
		{0, 255, 0},
		{255, 255, 255}
	}
	
	label=newText("NeonPong", 0, 0, "Trebuchet MS", 60) -- Create the label
	label.x, label.y=middleX, middleY-250 -- Position it
	label.color=1 -- Marker to specify which color to set
	label:setTextColor(unpack(labelColors[label.color]))
	localgroup:insert(label)
	
	label.colorChange=function() -- Function to change the label's color
		if label.color~=#labelColors then -- Make sure that we're not over the number of possible colors
			label.color=label.color+1
		else
			label.color=1
		end
		label:setTextColor(unpack(labelColors[label.color])) -- Set the label's color according to which color we're on
	end
	label.colorTimer=timer.performWithDelay(1000, label.colorChange, 0) -- Once every second
	
	
	
	------------------------------------------------
	--Difficulty Button
	------------------------------------------------
	
	function onDifRelease()
		if difficulty=="Easy" then
			playButton:setFillColor(255, 0, 255) -- Set to medium
			difficulty="Medium"
			difLabel.text=difficulty
		elseif difficulty=="Medium" then
			playButton:setFillColor(255, 0, 0) -- Set to hard
			difficulty="Hard"
			difLabel.text=difficulty
		elseif difficulty=="Hard" then
			playButton:setFillColor(60, 0, 120) -- Set to endless
			difficulty="Endless"
			difLabel.text=difficulty
		elseif difficulty=="Endless" then
			playButton:setFillColor(100, 150, 255) -- Set back to easy
			difficulty="Easy"
			difLabel.text=difficulty
		end
	end
	
	difButton=newButton{
		color={100, 100, 100},
		onRelease=onDifRelease
	}
	difButton.x, difButton.y=middleX, middleY+200 -- Near the middle of the screen
	localgroup:insert(difButton)
	
	difLabel=newText("Easy", 0, 0, "Trebuchet MS", 30) -- Starts out on easy
	difLabel.x, difLabel.y=middleX, middleY+200
	difLabel:setTextColor(255, 255, 255)
	localgroup:insert(difLabel)
	
	
	
	------------------------------------------------
	--Variables
	------------------------------------------------

	function onPointRelease()
		if points<15 then -- If it's under 15, add to it...
			points=points+1
			pointLabel.text=points.."-Point Game"
		else -- But if it's equal to 15, set it back to 1
			points=1
			pointLabel.text=points.."-Point Game"
		end
	end
	
	pointButton=newButton{
		color={255, 255, 0},
		onRelease=onPointRelease
	}
	pointButton.x, pointButton.y=middleX, middleY+100
	localgroup:insert(pointButton)
	
	pointLabel=newText("5-Point Game", 0, 0, "Trebuchet MS", 30)
	pointLabel.x, pointLabel.y=middleX, middleY+100
	pointLabel:setTextColor(0, 0, 0)
	localgroup:insert(pointLabel)
	
	
	
	------------------------------------------------
	--Variables
	------------------------------------------------
	
	function playGame()
		if "Easy"==difficulty then
			ponghelper.save(5, "paddlespeed") -- Save the settings
			ponghelper.save(120, "playerheight")
			ponghelper.save(120, "cpuHeight")
			ponghelper.save(25, "ballRebound")
			ponghelper.save({100, 150, 255}, "CPUColor")
			ponghelper.save(6, "ballVel")
		elseif "Medium"==difficulty then
			ponghelper.save(7, "paddlespeed")
			ponghelper.save(90, "playerheight")
			ponghelper.save(120, "cpuHeight")
			ponghelper.save(20, "ballRebound")
			ponghelper.save({255, 0, 255}, "CPUColor")
			ponghelper.save(8, "ballVel")
		elseif "Hard"==difficulty then
			ponghelper.save(9, "paddlespeed")
			ponghelper.save(60, "playerheight")
			ponghelper.save(90, "cpuHeight")
			ponghelper.save(13, "ballRebound")
			ponghelper.save({255, 0, 0}, "CPUColor")
			ponghelper.save(10, "ballVel")
		elseif "Endless"==difficulty then
			points=10000000000000000000000000000000000000000000000000000000000000000000000000 -- Ok, so it's not exactly "endless", but it's pretty close to it
			ponghelper.save(9, "paddlespeed")
			ponghelper.save(90, "playerheight")
			ponghelper.save(120, "cpuHeight")
			ponghelper.save(16, "ballRebound")
			ponghelper.save({60, 0, 120}, "CPUColor")
			ponghelper.save(6, "ballVel")
		end
		ponghelper.save(points, "numpoints")
		timer.cancel(label.colorTimer) -- Cancel the color changing timer
		sceneManager:changeScene("game")
	end
	
	playButton=newButton{
		color={100, 150, 255}, -- Start out on the "easy" color
		onRelease=playGame
	}
	playButton.x, playButton.y=middleX, middleY
	localgroup:insert(playButton)
	
	playLabel=newText("Play", 0, 0, "Trebuchet MS", 30)
	playLabel.x, playLabel.y=middleX, middleY
	localgroup:insert(playLabel)
	
	return localgroup
end

scene.new=new
return scene