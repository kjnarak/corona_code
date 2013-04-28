--
-- Project: Compass
--
-- Date: August 19, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Compass sample app
--
-- Demonstrates: heading events, buttons, touch
--
-- File dependencies: none.
--
-- Target devices: iPhone 3GS or newer for compass data.
--
-- Limitations: Heading events not supported on Simulator or iPhone 3G
--
-- Update History:
--	v1.3	Added Simulator warning message
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Labels for digital display
local headingGeo = display.newText( "0°", 0, 0, "Helvetica-Bold", 38 )
headingGeo:setTextColor( 35, 170, 255 )
headingGeo:setReferencePoint( display.CenterRightReferencePoint )
headingGeo.x, headingGeo.y = 133 - headingGeo.contentWidth * 0.5, 72

local directionGeo = display.newText( "N", 0, 0, "Helvetica-Bold", 16 )
directionGeo:setTextColor( 35, 170, 255 )
directionGeo:setReferencePoint( display.CenterLeftReferencePoint )
directionGeo.x, directionGeo.y = 106 + directionGeo.contentWidth * 0.5, 76

local headingMag = display.newText( "0°", 0, 0, "Helvetica-Bold", 38 )
headingMag:setTextColor( 153, 153, 153 )
headingMag:setReferencePoint( display.CenterRightReferencePoint )
headingMag.x, headingMag.y = 283 - headingMag.contentWidth * 0.5, 72

local directionMag = display.newText( "N", 0, 0, "Helvetica-Bold", 16 )
directionMag:setTextColor( 153, 153, 153 )
directionMag:setReferencePoint( display.CenterLeftReferencePoint )
directionMag.x, directionMag.y = 256 + directionGeo.contentWidth * 0.5, 76


local dial = display.newImage("compass_dial.png", 40, 150)
local background = display.newImage("compass_bkg.png")

local compassMode = "geo"

local showGeo = function( event )
	if event.phase == "began" then
		print("geo")
		headingGeo:setTextColor( 35, 170, 255, 255 )
		directionGeo:setTextColor( 35, 170, 255, 255 )
		headingMag:setTextColor( 153, 153, 153, 255 )
		directionMag:setTextColor( 153, 153, 153, 255 )
		compassMode = "geo"
	end
	
	return true
end

local showMag = function( event )
	if event.phase == "began" then
		print("mag")
		headingGeo:setTextColor( 153, 153, 153, 255 )
		directionGeo:setTextColor( 153, 153, 153, 255 )
		headingMag:setTextColor( 35, 170, 255, 255 )
		directionMag:setTextColor( 35, 170, 255, 255 )
		compassMode = "mag"
	end
	
	return true
end

-- Add touch events to textfields (for switching between geographic/magnetic display modes)
headingGeo:addEventListener( "touch", showGeo )
headingMag:addEventListener( "touch", showMag )

local directionForAngle = function( angle )
	local text

	if ( angle <= 22 or angle > 337 ) then
		text = "N"
	elseif ( angle > 22 and angle <= 67 ) then
		text = "NE"
	elseif ( angle > 67 and angle <= 112 ) then
		text = "E"
	elseif ( angle > 112 and angle <= 157 ) then
		text = "SE"
	elseif ( angle > 157 and angle <= 202 ) then
		text = "S"
	elseif ( angle > 202 and angle <= 247 ) then
		text = "SW"
	elseif ( angle > 247 and angle <= 292 ) then
		text = "W"
	elseif ( angle > 292 and angle <= 337 ) then
		text = "NW"
	end
	
	return text
end

local dstRotation = 0

local updateCompass = function( event )

	local angleMag, angleGeo
	
	-- Note: "magnetic" = magnetic north heading, and "geographic" = "true north" heading as seen on a map
	-- (The variance between these heading values depends on your position on the Earth)

	angleMag = event.magnetic

	-- Android does not support geographic headings, so we use magnetic headings for Android builds
	if system.getInfo( "platformName" ) ~= "Android" then
		angleGeo = event.geographic
	else
		angleGeo = angleMag
	end
	
	if ( "geo" == compassMode ) then
		dstRotation = -angleGeo
	else
		dstRotation = -angleMag
	end
	
	-- Format strings as whole numbers
	local valueGeo = string.format( '%.0f', angleGeo )
	local valueMag = string.format( '%.0f', angleMag )

	headingGeo.text  = valueGeo .. "°"
	headingGeo.x = 133 - headingGeo.contentWidth * 0.5
	directionGeo.text = directionForAngle( angleGeo )
	directionGeo.x = 106 + directionGeo.contentWidth * 0.5
	
	headingMag.text = valueMag .. "°"
	headingMag.x = 283 - headingMag.contentWidth * 0.5
	
	directionMag.text = directionForAngle( angleMag )
	directionMag.x = 256 + directionGeo.contentWidth * 0.5
end

local animateDial = function( event )
	local curRotation = dial.rotation
	local delta = dstRotation - curRotation
	
	if math.abs( delta ) >= 180 then
		if delta < -180 then
			delta = delta + 360
		elseif delta > 180 then
			delta = delta - 360
		end
	end

	dial.rotation = curRotation + delta*0.3
end

local didInitGPS = false
local initGPS = function( event )
	if ( not didInitGPS ) then
		didInitGPS = true

		-- We only need a single location event to calibrate "true north", then we can turn off GPS again
		local initDone = function( event )
			Runtime:removeEventListener( "location", initGPS )
		end

		-- Delay removal to let the hardware activate
		timer.performWithDelay( 1000, initDone )
	end
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Heading Events are not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Heading events not supported on Simulator!", 0, 20, "Verdana-Bold", 12 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

-- Location event listener
if system.getInfo( "platformName" ) ~= "Android" then
	Runtime:addEventListener( "location", initGPS )
end
-- This is not required if you only want the heading relative to magnetic north, but to calculate 
-- your "true north" offset, the iPhone needs at least one location reading. Location may already 
-- be cached by the OS, but if not, then geographic north heading defaults to "-1".
-- Again, this is not required for Android, since Android does not support true north headings.

-- Compass event listener
Runtime:addEventListener( "heading", updateCompass )

-- Adaptive tweening to smooth the dial animation
Runtime:addEventListener( "enterFrame", animateDial )