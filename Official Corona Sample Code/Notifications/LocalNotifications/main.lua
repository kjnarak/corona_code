-- Project: LocalNotificaton_test
--
-- File name: main.lua
--
-- Local Notifications sample code
--
-- Update History:
--	v1.1	10/30/12	Layout adapted for Android/iPad/iPhone4
--	v1.2	12/5/12		Modified listener to accept a nil badge number (for Android)
--
-- Limitations: Currently only runs on iOS and Android devices (no simulators)
-- 				Note: Badge is not currently supported on Android
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

local launchArgs = ...

local widget = require( "widget" )

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

print();print("<-========================= Program Start =========================->");print()

local notificationID		-- forward reference
local notificationTime = 10	-- number of seconds until notification
local time = notficationTime
local badge = "none"				-- default value written to icon badge
local setBadge = 0
local running = false			-- used in countdown timer to enable/disable
local startTime				-- time we start the notification

local _centerX = display.contentCenterX
local btnY = 70		-- start of buttons
local btnOff = 60	-- button offset

local msgOff = 400	-- Start of messages

local startText = display.newText( "", 10, msgOff )
local cancelText = display.newText( "", 10, msgOff+20 )
local notificationText = display.newText( "", 10, msgOff+35 )
notificationText:setTextColor( 255,255,0 )

local notificationMsgText = display.newText( "", 10, msgOff+55 )
notificationMsgText:setTextColor( 255,255,0 )

-- Options for iOS 
--
-- Note: options.badge and options.custom are added in the notification start
--
local options = {
   alert = "Wake up!",
   badge = 1,
   sound = "alarm.caf",
   custom = { msg = "bar" }
}

titleMsg = display.newText( "Local Notification Test", 0, 10, "Verdana-Bold", 18 )
titleMsg.x = _centerX

-------------------------------------------
-- *** Buttons Presses ***
-------------------------------------------

-- Start W/Time Button
local startWTimePress = function( event )
	time = notificationTime
	
	-- Add badge paramter if not "none"
	if badge ~= "none" then
		options.badge = badge
	end
	
	options.custom.msg = "Time Notification"

	notificationID = system.scheduleNotification( time, options )
	local displayText = "Notification using Time: " .. tostring( notificationID )
	startText.text = displayText
	startText:setReferencePoint(display.TopLeftReferencePoint)
	startText.x = 10
	
	-- Clear previous text
	notificationText.text = ""
	cancelText.text = ""
	notificationMsgText.text = ""
	
	startTime = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
	running = true
	
	print( displayText )
end

-- Start W/UTC Button
local startWUtcPress = function( event )
	time = os.date( "!*t", os.time() + notificationTime )
	
	-- Add badge paramter if not "none"
	if badge ~= "none" then
		options.badge = badge
	end
	
	options.custom.msg = "UTC Notification"
	
	notificationID = system.scheduleNotification( time, options )
	local displayText = "Notification using UTC: " .. tostring( notificationID )
	startText.text = displayText
	
	startText:setReferencePoint(display.TopLeftReferencePoint)
	startText.x = 10
	
	-- Clear previous text
	notificationText.text = ""
	cancelText.text = ""
	notificationMsgText.text = ""

	startTime = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
	running = true

	print( displayText )
end

-- Badge Button
-- Cycle: none, 0, 1, 2, -1
-- (This is updated when the notification is started)
--
local badgePress = function( event )
	if badge == "none" then
		badge = 0
	elseif badge == 0 then
		badge = 1
	elseif badge == 1 then
		badge = 2
	elseif badge == 2 then
		badge = -1
	else	-- assume badge == -1
		badge = "none"
	end
	
	-- Change button label with value
	badge_bnt:setLabel( "Badge (" .. badge .. ")" )

end

-- Set Badge Button
-- Cycle: 0, 5, 10
-- (Uses native.setProperty to update the badge)
--
local setBadgePress = function( event )
	-- Set badge to either 0, 5 or 10
	native.setProperty( "applicationIconBadgeNumber", setBadge )
	
	-- Now advance to next value
	if setBadge == 0 then
		setBadge = 5
	elseif setBadge == 5 then
		setBadge = 10
	else
		setBadge = 0
	end
	
	-- Change button label with value
	setBadge_bnt:setLabel( "Set Badge (" .. setBadge .. ")" )
	
end

-- Cancel All Button
local cancelAllPress = function( event )
	system.cancelNotification() 
	cancelText.text = "Notification Cancel All"
	cancelText:setReferencePoint(display.TopLeftReferencePoint)
	cancelText.x = 10
end

-- Cancel W/ID Button
local cancelWIdPress = function( event )
	if notificationID then
		system.cancelNotification( notificationID ) 
		cancelText.text = "Notification Cancel ID"
		cancelText:setReferencePoint(display.TopLeftReferencePoint)
		cancelText.x = 10
	end
end

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- "Start W/Time" Button
startWTime_btn = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Start With Time",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = startWTimePress,
}

-- "Start W/UTC" Button
startWUtc_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Start With UTC",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = startWUtcPress,
}

-- "Cancel All" Button
cancelAll_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Cancel All",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = cancelAllPress,
}

-- "Cancel W/ID" Button
cancelWId_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Cancel W/ID",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = cancelWIdPress,
}

-- badge button
badge_bnt = widget.newButton
{
	id = "badge",
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Badge (" .. badge .. ")",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	yOffset = - 3,
	fontSize = 16,
	emboss = true,
	width = 130,
	onPress = badgePress,
}

-- set badge button
setBadge_bnt = widget.newButton
{
	id = "setBadge",
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Set Badge (" .. setBadge .. ")",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	yOffset = - 3,
	fontSize = 16,
	emboss = true,
	onPress = setBadgePress,
}


-- Position the buttons on screen
--
startWTime_btn.x = _centerX;	startWTime_btn.y = btnY
startWUtc_bnt.x = _centerX;		startWUtc_bnt.y = btnY + btnOff*1
cancelAll_bnt.x = _centerX;		cancelAll_bnt.y = btnY + btnOff*2
cancelWId_bnt.x = _centerX;		cancelWId_bnt.y = btnY + btnOff*3
badge_bnt.x = _centerX;				badge_bnt.y = btnY + btnOff*4
setBadge_bnt.x = _centerX;			setBadge_bnt.y = btnY + btnOff*5


-------------------------------------------
-- Local Notification listener
-------------------------------------------
--
local notificationListener = function( event )
	
--- Debug Event parameters printout --------------------------------------------------
--- Prints Events received up to 20 characters. Prints "..." and total count if longer
---
	print( "Notification Listener event:" )

	local maxStr = 20		-- set maximum string length
	local endStr

	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
--- End of debug Event routine -------------------------------------------------------

	local badgeOld = native.getProperty( "applicationIconBadgeNumber" )
	
	notificationText.text = "Notification fired: getProperty " ..
		tostring( badgeOld ) .. ", event.badge " .. tostring( event.badge )
	notificationText:setReferencePoint(display.TopLeftReferencePoint)
	notificationText.x = 10
	
	notificationMsgText.text = "custom.msg = " .. tostring( event.custom.msg ) ..
		", " .. tostring( event.applicationState )
	notificationMsgText:setReferencePoint(display.TopLeftReferencePoint)
	notificationMsgText.x = 10
	print( "event.custom.msg = ", event.custom.msg, event.applicationState )
	
end

-------------------------------------------
-- One Second Listener
-- Called every second to update the countdown
-------------------------------------------
--
local function secondTimer( event )
	if running then
		local t = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
		local e = notificationTime - tonumber( t - startTime )
		
		-- Stop the counter when we reach 0
		if e < 0 then
			running = false
			e = 0
		end
		
		startWTime_btn:setLabel( "Start With Time - " .. e )
	end
end

-------------------------------------------
-- Determine if running on Corona Simulator
-------------------------------------------
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Notifications not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Local Notifications not supported on Sim!", 0, 0, "Verdana-Bold", 12 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

-------------------------------------------
-- Add Listeners
-------------------------------------------
--
Runtime:addEventListener( "notification", notificationListener )

timer.performWithDelay(1000, secondTimer, 0)

-------------------------------------------
-- Check LaunchArgs
-- These ares are only set on a cold start
-------------------------------------------
--
if launchArgs and launchArgs.notification then
	
	native.showAlert( "LaunchArgs Found", launchArgs.notification.alert, { "OK" } )
	
	-- Need to call the notification listener since it won't get called if the
	-- the app was already closed.
	notificationListener( launchArgs.notification )
end

-- Code to show Alert Box if applicationOpen event occurs
-- (This shouldn't happen, but the code is here to prove the fact)
function onSystemEvent( event )
	print (event.name .. ", " .. event.type)
	
	if "applicationOpen" == event.type then
		native.showAlert( "Open via custom url", event.url, { "OK" } )
	end
end

-- Add the System callback event
Runtime:addEventListener( "system", onSystemEvent );
