-- Project: KeyEvents
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract:	Handle navigation key events on Android devices
--
-- Demonstrates: 
--
-- File dependencies: build.settings
--
-- Target devices: Android (no Simulator or iOS)
--
-- Update History:
--	7/14/2011	1.1		Added "volumeUp" exception code / removed splash screen
--	7/12/2011	1.0		Initial version
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Create text message label
--
local title = display.newText( "Press a navigation key", 0, 0, nil, 20 )
title.x = display.contentWidth/2		-- Center the text
title.y = 40

local eventTxt = display.newText( "Waiting for nav key event...", 0, 0, nil, 20 )
eventTxt.x = display.contentWidth/2		-- Center the text
eventTxt.y = display.contentHeight/2-30
eventTxt:setTextColor( 255, 255, 255 )

-- Check that we are running on Android device
--
if "Android" ~= system.getInfo("platformName") then
	eventTxt.text = "Build for Android Device!"
end

-- The Key Event Listener
--
local function onKeyEvent( event )
	local returnValue = true
	
	local phase = event.phase
	local keyName = event.keyName
	eventTxt.text = "("..phase.." , " .. keyName ..")"
	print( "Listener: " .. event.name )

	-- Make an exception for Volume Up key and default to it's normal function (just for show)
	if "volumeUp" == keyName then
		returnValue = false 		-- use default key operation
		print( "found 'volumeUp' key" )
	end
	
	-- we handled the event, so return true.
	-- for default behavior, return false.
	return returnValue
end

-- Add the key callback
Runtime:addEventListener( "key", onKeyEvent );

