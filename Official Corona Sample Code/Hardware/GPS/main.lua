--
-- Project: GPS
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: GPS sample app, showing available location event properties
--
-- Demonstrates: locations events, buttons, touch
--
-- File dependencies:
--
-- Target devices: iPhone 3GS or newer for GPS data.
--
-- Limitations: Location events not supported on Simulator
--
-- Update History:
--	v1.2	8/19/10		Added Simulator warning message
--  v1.3	11/28/11	Added test for Location error & alert box
--
-- Comments: 
-- This example shows you how to access the various properties of the "location" events, which
-- are returned by the GPS listener. Devices without GPS will have less accurate location data,
-- and the Corona Simulator returns a set of artificial coordinates for testing.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" )

local currentLatitude = 0
local currentLongitude = 0

display.setStatusBar( display.HiddenStatusBar )

local background = display.newImage("gps_background.png")

local latitude = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
latitude:setReferencePoint( display.CenterLeftReferencePoint )
latitude.x, latitude.y = 125 + latitude.contentWidth * 0.5, 64
latitude:setTextColor( 255, 85, 85 )


local longitude = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
longitude:setReferencePoint( display.CenterLeftReferencePoint )
longitude.x, longitude.y = 125 + longitude.contentWidth * 0.5, latitude.y + 50
longitude:setTextColor( 255, 85, 85 )


local altitude = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
altitude:setReferencePoint( display.CenterLeftReferencePoint )
altitude.x, altitude.y = 125 + altitude.contentWidth * 0.5, longitude.y + 50
altitude:setTextColor( 255, 85, 85 )


local accuracy = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
accuracy:setReferencePoint( display.CenterLeftReferencePoint )
accuracy.x, accuracy.y = 125 + altitude.contentWidth * 0.5, altitude.y + 50
accuracy:setTextColor( 255, 85, 85 )


local speed = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
speed:setReferencePoint( display.CenterLeftReferencePoint )
speed.x, speed.y = 125 + speed.contentWidth * 0.5, accuracy.y + 50
speed:setTextColor( 255, 85, 85 )


local direction = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
direction:setReferencePoint( display.CenterLeftReferencePoint )
direction.x, direction.y = 125 + direction.contentWidth * 0.5, speed.y + 50
direction:setTextColor( 255, 85, 85 )


local time = display.newText( "--", 0, 0, "DBLCDTempBlack", 26 )
time:setReferencePoint( display.CenterLeftReferencePoint )
time.x, time.y = 125 + time.contentWidth * 0.5, direction.y + 50
time:setTextColor( 255, 85, 85 )

local buttonPress = function( event )
	-- Show location on map
	mapURL = "http://maps.google.com/maps?q=Hello,+Corona!@" .. currentLatitude .. "," .. currentLongitude
	system.openURL( mapURL )
end


local button1 = widget.newButton
{
	defaultFile = "buttonRust.png",
	overFile = "buttonRustOver.png",
	label = "Show on Map",
	labelColor = 
	{ 
		default = { 200, 200, 200, 255}, 
		over = { 200, 200, 200, 128 } 
	},
	font = "TrebuchetMS-Bold",
	fontSize = 22,
	emboss = true,
	onPress = buttonPress,
}
button1.x, button1.y = 160, 422

local locationHandler = function( event )

	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )
	else
	
		local latitudeText = string.format( '%.4f', event.latitude )
		currentLatitude = latitudeText
		latitude.text = latitudeText
		latitude.x, latitude.y = 125 + latitude.contentWidth * 0.5, 64
		
		local longitudeText = string.format( '%.4f', event.longitude )
		currentLongitude = longitudeText
		longitude.text = longitudeText
		longitude.x, longitude.y = 125 + longitude.contentWidth * 0.5, latitude.y + 50
		
		local altitudeText = string.format( '%.3f', event.altitude )
		altitude.text = altitudeText
		altitude.x, altitude.y = 125 + altitude.contentWidth * 0.5, longitude.y + 50
	
		local accuracyText = string.format( '%.3f', event.accuracy )
		accuracy.text = accuracyText
		accuracy.x, accuracy.y = 125 + accuracy.contentWidth * 0.5, altitude.y + 50
		
		local speedText = string.format( '%.3f', event.speed )
		speed.text = speedText
		speed.x, speed.y = 125 + speed.contentWidth * 0.5, accuracy.y + 50
	
		local directionText = string.format( '%.3f', event.direction )
		direction.text = directionText
		direction.x, direction.y = 125 + direction.contentWidth * 0.5, speed.y + 50
	
		-- Note: event.time is a Unix-style timestamp, expressed in seconds since Jan. 1, 1970
		local timeText = string.format( '%.0f', event.time )
		time.text = timeText 
		time.x, time.y = 125 + time.contentWidth * 0.5, direction.y + 50
	end
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Location Events is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Location events not supported on Simulator!", 0, 230, "Verdana-Bold", 13 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,255 )
end

-- Activate location listener
Runtime:addEventListener( "location", locationHandler )