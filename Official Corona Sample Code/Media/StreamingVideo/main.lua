-- Abstract: Streaming Video sample app
-- 
-- Project: StreamingVideo
--
-- Date: September 21, 2011
--
-- Version: 1.4
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Displays video from CoronaLabs.com
--
-- Demonstrates: media.playVideo, detection of Corona Simulator
--
-- File dependencies: none
--
-- Target devices: Simulator (results in Console)
--
-- Limitations: Requires internet access
--
-- Update History:
--	v1.2	Detect running in simulator.
--			Added "Tap to start video" message
--	v1.3	Changed default orientation from portrait to landscape.
--			Looks better on Android this way.
--  v1.4	Added support for Mac OS X simulator.
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


display.setStatusBar( display.HiddenStatusBar )

local posterFrame = display.newImage( "Default.png" )
posterFrame:rotate(270)
posterFrame.x = display.contentCenterX
posterFrame.y = display.contentCenterY

function posterFrame:tap( event )
	msg.text = "Video Done"		-- message will appear after the video finishes
	media.playVideo( "http://www.coronalabs.com/links/video/Corona-iPhone.m4v", media.RemoteSource, true )
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")
if system.getInfo( "platformName" ) == "Mac OS X" then isSimulator = false; end

-- Video is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "No Video on Simulator!", 0, 60, "Verdana-Bold", 22 )
else
	msg = display.newText( "Tap to start video", 0, 60, "Verdana-Bold", 22 )
	posterFrame:addEventListener( "tap", posterFrame )		-- add Tap listener
end

msg.x = display.contentWidth/2		-- center title
msg:setTextColor( 0,0,255 )
