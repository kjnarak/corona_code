--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 2.0
--
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by Corona Labs, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
--*********************************************************************************************

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Set the background to white
display.setDefault( "background", 255, 255, 255 )

-- Require the widget & storyboard libraries
local widget = require( "widget" )
local storyboard = require( "storyboard" )

-- The gradient used by the title bar
local titleGradient = graphics.newGradient( 
	{ 189, 203, 220, 255 }, 
	{ 89, 116, 152, 255 }, "down" )
	
-- Create a title bar
local titleBar = display.newRect( 0, 0, display.contentWidth, 32 )
titleBar.y = titleBar.contentHeight * 0.5
titleBar:setFillColor( titleGradient )	

-- Create the title bar text
local titleBarText = display.newText( "Widget Demo", 0, 0, native.systemFontBold, 16 )
titleBarText.x = titleBar.x
titleBarText.y = titleBar.y
	
-- Create buttons table for the tab bar
local tabButtons = 
{
	{
		width = 32, 
		height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "TableView",
		onPress = function() storyboard.gotoScene( "tab1" ); end,
		selected = true
	},
	{
		width = 32, 
		height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "ScrollView",
		onPress = function() storyboard.gotoScene( "tab2" ); end,
	},
	{
		width = 32, 
		height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "PickerWheel",
		onPress = function() storyboard.gotoScene( "tab3" ); end,
	},
	{
		width = 32, 
		height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Other",
		onPress = function() storyboard.gotoScene( "tab4" ); end,
	}
}

-- Create a tab-bar and place it at the bottom of the screen
local tabBar = widget.newTabBar
{
	top = display.contentHeight - 50,
	width = display.contentWidth,
	buttons = tabButtons
}

-- Start at tab1
storyboard.gotoScene( "tab1" )