--==================================================================================================
-- 
-- Abstract: Inneractive Sample Project
-- 
-- This project demonstrates Corona Banner Ads support (from inneractive network).
--
-- IMPORTANT: You must get your own "app ID" from the advertising
-- agency you want to display banner ads for. Further, you must build for device
-- to properly test this sample, because "ads" library is not supported by the
-- Corona Simulator.
--
--   1. Get your app ID (example, from inneractive)
--   2. Modify the code below to use your own app ID 
--   3. Build and deploy on device (or Xcode simulator)
--
-- The code below demonstrates the different banner ads you can use
-- with the Inneractive ad network.
--
-- Version: 1.0 (November 29, 2011)
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
--==================================================================================================

-- hide the status bar:
display.setStatusBar( display.HiddenStatusBar )

-- Below is the ad network that will be used:

local adNetwork = "inneractive"

-- Replace nil below with your app ID:
-- String; e.g. surrounded by quotes (ex. "abcdefghijklmnop")

local appID = nil

--==================================================================================================

-- Make Banner Ads features available under "ads" namespace
local ads = require "ads"

-- Create a text object to display ad status
local statusText = display.newRetinaText( "", 0, 0, native.systemFontBold, 22 )
statusText:setTextColor( 255 )
statusText:setReferencePoint( display.CenterReferencePoint )
statusText.x, statusText.y = display.contentWidth * 0.5, 160

-- Set up ad listener.
local function adListener( event )
	-- event table includes:
	-- 		event.provider (e.g. "inneractive")
	--		event.isError (e.g. true/false )
	
	if event.isError then
		statusText:setTextColor( 255, 0, 0 )
		statusText.text = "Error Loading Ad"
		statusText.x = display.contentWidth * 0.5
	else
		statusText:setTextColor( 0, 255, 0 )
		statusText.text = "Successfully Loaded Ad"
		statusText.x = display.contentWidth * 0.5
	end
end

-- initialize ad network:
ads.init( adNetwork, appID, adListener )

-- localize a widget function
local widget = require( "widget" )

-- initial variables
local sysModel = system.getInfo("model")
local sysEnv = system.getInfo("environment")

-- create a background for the app
local backgroundImg = display.newImageRect( "space.png", display.contentWidth, display.contentHeight )
backgroundImg:setReferencePoint( display.TopLeftReferencePoint )
backgroundImg.x, backgroundImg.y = 0, 0
statusText:toFront()

-- Shows a specific type of ad
local showAd = function( adType )
	local adX, adY = 0, 0
	statusText.text = ""
	ads.show( adType, { x=adX, y=adY, interval=60, testMode=true } )	-- standard interval for "inneractive" is 60 seconds
end

-- event listener for widget buttons
local function onButtonRelease( event )
	local id = event.target.id
	
	if id == "hideAll" then
		ads.hide()
		statusText.text = ""
	else
		showAd( id )
	end
end

-- if on simulator, make sure onRelease listeners for buttons are reset to nil
if sysEnv == "simulator" then onButtonRelease = nil; end

-- create show banner ad button
local bannerButton = widget.newButton
{
	width = 298,
	height = 56,
	id = "banner",
	label = "Show Banner Ad",
	onRelease = onButtonRelease
}
bannerButton:setReferencePoint( display.CenterReferencePoint )
bannerButton.x = display.contentWidth * 0.5
bannerButton.y = display.contentHeight - 240

-- create text ad button
local textButton = widget.newButton
{
	width = 298,
	height = 56,
	id = "text",
	label = "Show Text Ad",
	onRelease = onButtonRelease
}
textButton:setReferencePoint( display.CenterReferencePoint )
textButton.x = display.contentWidth * 0.5
textButton.y = display.contentHeight - 180

-- create fullscreen ad button
local fullScreenButton = widget.newButton
{
	width = 298,
	height = 56,
	id = "fullscreen",
	label = "Show Fullscreen Ad",
	onRelease = onButtonRelease
}
fullScreenButton:setReferencePoint( display.CenterReferencePoint )
fullScreenButton.x = display.contentWidth * 0.5
fullScreenButton.y = display.contentHeight - 120

-- create a hide all ads button
local hideButton = widget.newButton
{
	width = 298,
	height = 56,
	id = "hideAll",
	label = "Hide All Ads",
	onRelease = onButtonRelease
}
hideButton:setReferencePoint( display.CenterReferencePoint )
hideButton.x = display.contentWidth * 0.5
hideButton.y = display.contentHeight - 60

-- if on simulator, let user know they must build for device
if sysEnv == "simulator" then
	local font, size = native.systemFontBold, 22
	local warningText = display.newText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
	warningText:setTextColor( 255 )
	warningText:setReferencePoint( display.CenterReferencePoint )
	warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
else
	-- start with banner ad
	showAd( "banner" )
end