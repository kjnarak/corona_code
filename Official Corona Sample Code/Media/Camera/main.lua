-- 
-- Abstract: Camera sample app
-- 
-- Version: 1.2
-- 
-- Updated: September 21, 2011
--
-- Update History:
-- 	v1.1	Fixed logic problem where it said "session was cancelled".
--	v1.2	Added Android support.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "Camera API not available on iOS Simulator.", { "OK"})    
end

--
local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 128, 0, 0 )

local text = display.newText( "Tap anywhere to launch Camera", 0, 0, nil, 16 )
text:setTextColor( 255, 255, 255 )
text.x = 0.5 * display.contentWidth
text.y = 0.5 * display.contentHeight

local sessionComplete = function(event)	
	local image = event.target

	print( "Camera ", ( image and "returned an image" ) or "session was cancelled" )
	print( "event name: " .. event.name )
	print( "target: " .. tostring( image ) )

	if image then
		-- center image on screen
		image.x = display.contentWidth/2
		image.y = display.contentHeight/2
		local w = image.width
		local h = image.height
		print( "w,h = ".. w .."," .. h )
	end
end

local listener = function( event )
	if media.hasSource( media.Camera ) then
		media.show( media.Camera, sessionComplete )
	else
		native.showAlert("Corona", "Camera not found.")
	end
	return true
end
bkgd:addEventListener( "tap", listener )
