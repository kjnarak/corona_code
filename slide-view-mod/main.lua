-- 
-- Abstract: Slide View sample app
--  
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Demonstrates how to display a set of "screens" in a series that 
-- the user can swipe from left to right, using the methods 
-- provided in slideView.lua.

display.setStatusBar( display.HiddenStatusBar ) 

local slideView = require("slideView")
	
local mySlides = {
	"screen1",
	"screen2",
	"screen3",
}		

slideView.new( mySlides, "bg.png")


