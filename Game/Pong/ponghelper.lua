------------------------------------------------
--PongHelper Helper Library
--
--If your function is in here, thank you for it
------------------------------------------------

local ponghelper={} -- Table to hold the functions

local json=require("json")


--Saves a value
local function save(t, filename)
	local path=system.pathForFile( filename, system.DocumentsDirectory)
	local file=io.open(path, "w")
	if file then
		local contents=json.encode(t)
		file:write( contents )
		io.close( file )
		return true
	else
		return false
	end
end


--Loads a previously saved value
local function LOAD(filename) -- There's a Lua function "load" so make it all in caps - we can change it to lowercase when adding it to the PongHelper table
	local path=system.pathForFile( filename, system.DocumentsDirectory)
	local contents=""
	local myTable={}
	local file=io.open( path, "r" )
	if file then
		local contents=file:read( "*a" )
		myTable=json.decode(contents);
		io.close( file )
		return myTable
	end
	return nil
end


--Generates a display object that functions as a button
local function newButton(params)
	local params=params
	
	local button
	
	local color=params.color or {255, 0, 0}
	
	local onRelease=params.onRelease or function()end
	local onPress=params.onPress or function()end
	
	button=display.newImage("assets/button.png")
	button:setFillColor(unpack(color))
	
	button.onRelease=onRelease
	button.onPress=onPress	
	
	local function buttonTouch(event)
		local isWithinBounds=
			event.x>=button.contentBounds.xMin and event.x<=button.contentBounds.xMax and event.y>=button.contentBounds.yMin and event.y<=button.contentBounds.yMax

		if "began"==event.phase then
			display.getCurrentStage():setFocus(button)
			button.isFocus=true
			
			button.alpha=0.8
			button.onPress()
		
		elseif button.isFocus then
			if "moved"==event.phase then
				if isWithinBounds then
					button.alpha=0.8
				elseif not isWithinBounds then
					button.alpha=1
				end
			elseif "ended"==event.phase then
				display.getCurrentStage():setFocus(nil)
				button.isFocus=false
				
				if isWithinBounds then
					button.onRelease()
					button.alpha=1
				elseif not isWithinBounds then
					button.alpha=1
				end
			
			end
		end
		return true
	end
	
	button:addEventListener("touch", buttonTouch)
	
	
	
	return button
end


--Clamps a value to range l-h
local function clamp(t, l, h)
	if t<l then
		return l
	elseif t>h then
		return h
	else
		return t
	end
end


--Clamps a value to closest - l, 0, h
local function roundToNearest(t, l, h)
	local tMl=math.abs(t-l)
	local tMh=math.abs(t-h)
	local diff=tMl-tMh
	
	if diff > 1 then
		return l
	elseif diff < -1 then
		return h
	else
		return 0
	end
end


--Determines if a point is colliding with a rectangle
local function pointInRect( pointX, pointY, left, top, width, height )
	if pointX >= left and pointX <= left + width and pointY >= top and pointY <= top + height then 
		return true
	else 
		return false 
	end
end


ponghelper.save=save
ponghelper.load=LOAD
ponghelper.newButton=newButton
ponghelper.clamp=clamp
ponghelper.roundToNearest=roundToNearest
ponghelper.pointInRect=pointInRect
return ponghelper