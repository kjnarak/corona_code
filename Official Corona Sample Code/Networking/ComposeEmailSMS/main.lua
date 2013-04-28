-- Project: ComposeEmailSMS
--
-- Date: January 17, 2012
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs, Inc.
--
-- Abstract: Native E-mail and SMS client's compose feature is shown, pre-populated with
-- text, recipients, and attachments (E-mail).
--
-- Demonstrates: native.showPopup() API
--
-- Target devices: iOS and Android devices (or Xcode simulator)
--
-- Limitations: Requires build for device (and data access to send email/sms message).
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" )

local emailImage = display.newImage( "email.png" )
emailImage.x = display.contentWidth * 0.5
emailImage.y = 156

-- BUTTON LISTENERS ---------------------------------------------------------------------

-- onRelease listener for 'sendEmail' button
local function onSendEmail( event )
	-- compose an HTML email with two attachments
	local options =
	{
	   to = { "john.doe@somewhere.com", "jane.doe@somewhere.com" },
	   cc = { "john.smith@somewhere.com", "jane.smith@somewhere.com" },
	   subject = "My High Score",
	   isBodyHtml = true,
	   body = "<html><body>I scored over <b>9000</b>!!! Can you do better?</body></html>",
	   attachment =
	   {
		  { baseDir=system.ResourceDirectory, filename="email.png", type="image" },
		  { baseDir=system.ResourceDirectory, filename="coronalogo.png", type="image" },
	   },
	}
	native.showPopup("mail", options)
	
	-- NOTE: options table (and all child properties) are optional
end

-- onRelease listener for 'sendSMS' button
local function onSendSMS( event )
	-- compose an SMS message (doesn't support attachments)
	local options =
	{
	   to = { "1234567890", "9876543210" },
	   body = "I scored over 9000!!! Can you do better?"
	}
	native.showPopup("sms", options)
	
	-- NOTE: options table (and all child properties) are optional
end

-- CREATE BUTTONS -----------------------------------------------------------------------

local sendEmail = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose Email",
	onRelease = onSendEmail
}

-- center horizontally on the screen
sendEmail.x = display.contentWidth * 0.5
sendEmail.y = display.contentHeight - 156

local sendSMS = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose SMS",
	onRelease = onSendSMS
}

-- center horizontally on the screen
sendSMS.x = display.contentWidth * 0.5
sendSMS.y = display.contentHeight - 100