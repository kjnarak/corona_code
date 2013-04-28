-- 
-- Abstract: Digital clock, with reformatted UI for different orientations
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

display.setStatusBar( display.HiddenStatusBar )

local clock = display.newGroup()

local background = display.newImage( "purple.png" )
clock:insert( background, true )
background.x = 160; background.y = 240

-- Set the rotation point to the center of the screen
clock:setReferencePoint( display.CenterReferencePoint )

-- Create dynamic textfields
-- Note: these are iOS/MacOS fonts. If building for Android, choose available system fonts, 
-- or use native.systemFont / native.systemFontBold

local hourField = display.newText( "", 0, 0, native.systemFontBold, 180 )
hourField:setTextColor( 255, 255, 255, 70 )
clock:insert( hourField, true )
hourField.x = 100; hourField.y = 90; hourField.rotation = -15

local minuteField = display.newText( "", 0, 0, native.systemFontBold, 180 )
minuteField:setTextColor( 255, 255, 255, 70 )
clock:insert( minuteField, true )
minuteField.x = 100; minuteField.y = 240; minuteField.rotation = -15

local secondField = display.newText( "", 0, 0, native.systemFontBold, 180 )
secondField:setTextColor( 255, 255, 255, 70 )
clock:insert( secondField, true )
secondField.x = 100; secondField.y = 390; secondField.rotation = -15

-- Create captions
local hourLabel = display.newText( "hours ", 0, 0, native.systemFont, 40 )
hourLabel:setTextColor( 131, 255, 131, 255 )
clock:insert( hourLabel, true )
hourLabel.x = 220; hourLabel.y = 100

local minuteLabel = display.newText( "minutes ", 0, 0, native.systemFont, 40 )
minuteLabel:setTextColor( 131, 255, 131, 255 )
clock:insert( minuteLabel, true )
minuteLabel.x = 220; minuteLabel.y = 250

local secondLabel = display.newText( "seconds ", 0, 0, native.systemFont, 40 )
secondLabel:setTextColor( 131, 255, 131, 255 )
clock:insert( secondLabel, true )
secondLabel.x = 210; secondLabel.y = 400


local function updateTime()
	local time = os.date("*t")
	
	local hourText = time.hour
	if (hourText < 10) then hourText = "0" .. hourText end
	hourField.text = hourText
	
	local minuteText = time.min
	if (minuteText < 10) then minuteText = "0" .. minuteText end
	minuteField.text = minuteText
	
	local secondText = time.sec
	if (secondText < 10) then secondText = "0" .. secondText end
	secondField.text = secondText
end

updateTime() -- run once on startup, so correct time displays immediately


-- Update the clock once per second
local clockTimer = timer.performWithDelay( 1000, updateTime, -1 )


-- Use accelerometer to rotate display automatically
local function onOrientationChange( event )

	-- Adapt text layout to current orientation	
	local direction = event.type

	if ( direction == "landscapeLeft" or direction == "landscapeRight" ) then
		hourField.y = 120
		secondField.y = 360
		hourLabel.y = 130
		secondLabel.y = 370
	elseif ( direction == "portrait" or direction == "portraitUpsideDown" ) then
		hourField.y = 90
		secondField.y = 390
		hourLabel.y = 100
		secondLabel.y = 400
	end

	-- Rotate clock so it remains upright
	local newAngle = clock.rotation - event.delta
	transition.to( clock, { time=150, rotation=newAngle } )	
end

Runtime:addEventListener( "orientation", onOrientationChange )