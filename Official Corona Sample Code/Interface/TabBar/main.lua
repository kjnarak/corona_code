-- 
-- Abstract: Tab Bar sample app
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates how to create a tab bar that allows the user to navigate between screens,
-- using the Widget & Storyboard libraries.


local widget = require ( "widget" )
local storyboard = require ( "storyboard" )

display.setDefault( "background", 255, 255, 255 )

-- Create buttons table for the tab bar
local tabButtons = 
{
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Screen 1",
		onPress = function() storyboard.gotoScene( "screen1" ); end,
		selected = true
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Screen 2",
		onPress = function() storyboard.gotoScene( "screen2" ); end,
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Screen 3",
		onPress = function() storyboard.gotoScene( "screen3" ); end,
	}
}

--Create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar
{
	top = display.contentHeight - 50,
	width = display.contentWidth,
	backgroundFile = "assets/tabbar.png",
	tabSelectedLeftFile = "assets/tabBar_tabSelectedLeft.png",
	tabSelectedMiddleFile = "assets/tabBar_tabSelectedMiddle.png",
	tabSelectedRightFile = "assets/tabBar_tabSelectedRight.png",
	tabSelectedFrameWidth = 20,
	tabSelectedFrameHeight = 52,
	buttons = tabButtons
}

storyboard.gotoScene( "screen1" )