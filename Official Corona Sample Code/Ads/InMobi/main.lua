--==================================================================================================
-- 
-- Abstract: InMobi Ads Sample Project
-- 
-- This project demonstrates Corona Banner Ads support (from inmobi network).
--
-- IMPORTANT: You must get your own "app ID" from the advertising
-- agency you want to display banner ads for. Further, you must build for device
-- to properly test this sample, because "ads" library is not supported by the
-- Corona Simulator.
--
--   1. Get your app ID (example, from inmobi)
--   2. Modify the code below to use your own app ID 
--   3. Build and deploy on device
--
-- The code below demonstrates the different banner ads you can use
-- with the InMobi ad network.
--
--
-- Version: 1.0 (July 7, 2011)
-- Version: 1.1 (July 22, 2011) - Added Hide button and changed Next button behavior.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
--==================================================================================================

-- hide the status bar:
display.setStatusBar( display.HiddenStatusBar )

-- Below is the ad network that will be used:

local adNetwork = "inmobi"

-- Replace nil below with your app ID:
-- String; e.g. surrounded by quotes (ex. "abcdefghijklmnop")

local appID = nil



--==================================================================================================

-- Make Banner Ads features available under "ads" namespace
local ads = require "ads"

-- initialize ad network:
if appID then
	ads.init( adNetwork, appID )
end

-- localize a widget function
local widget = require( "widget" )

-- initial variables
local sysModel = system.getInfo("model")
local sysEnv = system.getInfo("environment")

local bgW, bgH = 320, 480
local currentAdIndex = 1

local adsTable = {
	"banner320x48",
	"banner300x250",
}
if sysModel == "iPad" then
	-- change settings if on iPad. It has 3 additional adUnitTypes it can show.
	bgW, bgH = 768, 1024
	adsTable = {
		"banner320x48",
		"banner300x250",
		"banner728x90",
		"banner468x60",
		"banner120x600"
	}
end


-- change settings if on iPad
if sysModel == "iPad" then
	bgW, bgH = 768, 1024
end

-- create a background for the app
local backgroundImg = display.newImageRect( "space.png", bgW, bgH )
backgroundImg:setReferencePoint( display.TopLeftReferencePoint )
backgroundImg.x, backgroundImg.y = 0, 0


if appID then
	-- Shows the banner indexed by variable "currentAdIndex"
	local showIndexedBanner = function()
		print("Showing Banner: " .. adsTable[currentAdIndex])
		local adX, adY = 0, 0
		ads.show( adsTable[currentAdIndex], { x=adX, y=adY, interval=5, testMode=true } )
	end


	-- onRelease event listener for 'nextButton'
	local onNextButtonReleased = function( event )
		currentAdIndex = currentAdIndex + 1
		if (currentAdIndex > #adsTable) then
			currentAdIndex = 1
		end
		showIndexedBanner()
	end


	-- onRelease event listener for 'hideButton'
	local onHideButtonReleased = function( event )
		ads.hide()
	end


	-- if on simulator, make sure onRelease event for buttons are set to nil
	if sysEnv == "simulator" then
		onNextButtonReleased = nil
		onHideButtonReleased = nil
	end


	-- create a next button (to show a different ad unit)
	local nextButton = widget.newButton
	{
		width = 298,
		height = 56,
		label = "Show Next Banner",
		onRelease = onNextButtonReleased
	}
	nextButton.x = display.contentWidth * 0.5
	nextButton.y = display.contentHeight - 120


	-- create a hide button
	local hideButton = widget.newButton
	{
		width = 298,
		height = 56,
		label = "Hide Banner",
		onRelease = onHideButtonReleased
	}
	hideButton.x = display.contentWidth * 0.5
	hideButton.y = display.contentHeight - 60


	-- if on simulator, let user know they must build for device
	if sysEnv == "simulator" then
		
		local font, size = "Helvetica-Bold", 22
		
		local warningText1 = display.newText( "Please build for device ", 0, 135, font, size )
		local warningText2 = display.newText( "to test this sample code.", 0, 165, font, size )
		
		warningText1:setTextColor( 255, 255, 255, 255 )
		warningText2:setTextColor( 255, 255, 255, 255 )
		
		warningText1:setReferencePoint( display.CenterReferencePoint )
		warningText2:setReferencePoint( display.CenterReferencePoint )
		
		local halfW = display.contentWidth * 0.5
		warningText1.x, warningText2.x = halfW, halfW
		
		-- make buttons appear disabled
		nextButton.alpha = 0
		hideButton.alpha = 0
	else
		-- display initial banner ad
		showIndexedBanner()
	end
else
	-- If no appId is set, show a message on the screen
	local font, size = "Helvetica-Bold", 22

	local warningText1 = display.newText( "No appID has been set.", 0, 105, font, size )
	warningText1:setTextColor( 255, 255, 255, 255 )
	warningText1:setReferencePoint( display.CenterReferencePoint )

	local halfW = display.contentWidth * 0.5
	warningText1.x = halfW

	if sysEnv == "simulator" then
		local warningText2 = display.newText( "Please build for device ", 0, 185, font, size )
		local warningText3 = display.newText( "to test this sample code.", 0, 215, font, size )
		warningText2:setTextColor( 255, 255, 255, 255 )
		warningText3:setTextColor( 255, 255, 255, 255 )

		warningText2:setReferencePoint( display.CenterReferencePoint )
		warningText3:setReferencePoint( display.CenterReferencePoint )
		warningText2.x, warningText3.x = halfW, halfW
	end
end
