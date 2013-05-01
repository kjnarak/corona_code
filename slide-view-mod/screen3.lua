-- 
-- Abstract: Tab Bar sample app, example content screen
--  
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

module(..., package.seeall)

function new()
	local g = display.newGroup()
	
	local background = display.newRect(0,display.screenOriginY, display.contentWidth, display.contentHeight-display.screenOriginY)
	background:setFillColor(255, 255, 255)
	g:insert(background)
	
	local message = display.newText("Screen 3", 0, 0, native.systemFontBold, 16)
	message:setTextColor(0, 0, 0)
	message.x = display.contentWidth*0.5
	message.y = display.contentHeight*0.5
	g:insert(message)

	function g:cleanUp()
		g:removeSelf()
	end
	
	return g
end
