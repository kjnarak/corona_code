-- 
-- Abstract: Orientation sample app
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- This demonstrates how to handle orientation changes manually, by rotating elements within
-- Corona. Note that the Corona stage remains fixed in place, and only the text rotates in this case.
-- 
-- The advantage of this method is that you have full control over how to handle the change, as in
-- the animation shown here. The disadvantage is that native UI elements will not rotate.
--
-- Alternatively, you can use the device's automatic orientation changes to rotate the entire stage,
-- which will also rotate native UI elements. See the "NativeOrientation" sample code for more.

local label = display.newText( "portrait", 0, 0, nil, 30 )
label:setTextColor( 255,255,255 )
label.x = display.contentWidth/2
label.y = display.contentHeight/2

local function onOrientationChange( event )
	-- change text to reflect current orientation
	label.text = event.type
	local direction = event.type

	-- rotate text so it remains upright
	local newAngle = label.rotation - event.delta
	transition.to( label, { time=150, rotation=newAngle } )
end

Runtime:addEventListener( "orientation", onOrientationChange )