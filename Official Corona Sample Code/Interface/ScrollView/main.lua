-- 
-- Abstract: Scroll View sample app
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates how to make text and graphics move up and down on touch,
-- or scroll, using the widget libraries scrollView methods.

display.setStatusBar( display.HiddenStatusBar ) 

local widget = require( "widget" )

-- Our ScrollView listener
local function scrollListener( event )
	local phase = event.phase
	local direction = event.direction
	
	if "began" == phase then
		--print( "Began" )
	elseif "moved" == phase then
		--print( "Moved" )
	elseif "ended" == phase then
		--print( "Ended" )
	end
	
	-- If the scrollView has reached it's scroll limit
	if event.limitReached then
		if "up" == direction then
			print( "Reached Top Limit" )
		elseif "down" == direction then
			print( "Reached Bottom Limit" )
		elseif "left" == direction then
			print( "Reached Left Limit" )
		elseif "right" == direction then
			print( "Reached Right Limit" )
		end
	end
			
	return true
end

-- Create a ScrollView
local scrollView = widget.newScrollView
{
	left = 0,
	top = 0,
	width = display.contentWidth,
	height = display.contentHeight,
	bottomPadding = 50,
	id = "onBottom",
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	listener = scrollListener,
}

--Create a text object for the scrollViews title
local titleText = display.newText("Move Up to Scroll", 0, 0, native.systemFontBold, 16)
titleText:setTextColor(0, 0, 0)
titleText.x = display.contentCenterX
titleText.y = 48
scrollView:insert( titleText )

--Create a large text string
local lotsOfText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet consectetur euismod. Phasellus non ipsum vel eros vestibulum consequat. Integer convallis quam id urna tristique eu viverra risus eleifend.\n\nAenean suscipit placerat venenatis. Pellentesque faucibus venenatis eleifend. Nam lorem felis, rhoncus vel rutrum quis, tincidunt in sapien. Proin eu elit tortor. Nam ut mauris pellentesque justo vulputate convallis eu vitae metus. Praesent mauris eros, hendrerit ac convallis vel, cursus quis sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fermentum, dui in vehicula dapibus, lorem nisi placerat turpis, quis gravida elit lectus eget nibh. Mauris molestie auctor facilisis.\n\nCurabitur lorem mi, molestie eget tincidunt quis, blandit a libero. Cras a lorem sed purus gravida rhoncus. Cras vel risus dolor, at accumsan nisi. Morbi sit amet sem purus, ut tempor mauris.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet consectetur euismod. Phasellus non ipsum vel eros vestibulum consequat. Integer convallis quam id urna tristique eu viverra risus eleifend.\n\nAenean suscipit placerat venenatis. Pellentesque faucibus venenatis eleifend. Nam lorem felis, rhoncus vel rutrum quis, tincidunt in sapien. Proin eu elit tortor. Nam ut mauris pellentesque justo vulputate convallis eu vitae metus. Praesent mauris eros, hendrerit ac convallis vel, cursus quis sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fermentum, dui in vehicula dapibus, lorem nisi placerat turpis, quis gravida elit lectus eget nibh. Mauris molestie auctor facilisis.\n\nCurabitur lorem mi, molestie eget tincidunt quis, blandit a libero. Cras a lorem sed purus gravida rhoncus. Cras vel risus dolor, at accumsan nisi. Morbi sit amet sem purus, ut tempor mauris. "

--Create a text object containing the large text string and insert it into the scrollView
local lotsOfTextObject = display.newText( lotsOfText, 0, 0, 300, 0, "Helvetica", 14)
lotsOfTextObject:setTextColor( 0 ) 
lotsOfTextObject:setReferencePoint( display.TopCenterReferencePoint )
lotsOfTextObject.x = display.contentCenterX
lotsOfTextObject.y = titleText.y + titleText.contentHeight + 10
scrollView:insert( lotsOfTextObject )
