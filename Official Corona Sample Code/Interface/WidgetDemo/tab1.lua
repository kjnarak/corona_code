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

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Our scene
function scene:createScene( event )
	local group = self.view
	
	-- Forward reference for our tableView
	local tableView = nil
	
	-- Text to show which item we selected
	local itemSelected = display.newText( "You selected item ", 0, 0, native.systemFontBold, 28 )
	itemSelected:setTextColor( 0 )
	itemSelected.x = display.contentWidth + itemSelected.contentWidth * 0.5
	itemSelected.y = display.contentCenterY - itemSelected.contentHeight
	group:insert( itemSelected )
	
	-- Function to return to the list
	local function goBack( event )
		--Transition in the list, transition out the item selected text and the back button
		transition.to( tableView, { x = 0, time = 400, transition = easing.outExpo } )
		transition.to( itemSelected, { x = display.contentWidth + itemSelected.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		transition.to( event.target, { x = display.contentWidth + event.target.contentWidth * 0.5, time = 400, transition = easing.outQuad } )
	end
	
	-- Back button
	local backButton = widget.newButton
	{
		width = 198,
		height = 59,
		label = "Back",
		onRelease = goBack,
	}
	backButton.x = display.contentWidth + backButton.contentWidth * 0.5
	backButton.y = itemSelected.y + itemSelected.contentHeight + backButton.contentHeight
	group:insert( backButton )
	
	-- Listen for tableView events
	local function tableViewListener( event )
		local phase = event.phase
		
		print( "Event.phase is:", event.phase )
	end

	-- Handle row rendering
	local function onRowRender( event )
		local phase = event.phase
		local row = event.row
		
		local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
		rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
		rowTitle.y = row.contentHeight * 0.5
		rowTitle:setTextColor( 0, 0, 0 )
	end
	
	-- Handle row updates
	local function onRowUpdate( event )
		local phase = event.phase
		local row = event.row
		
		--print( row.index, ": is now onscreen" )
	end
	
	-- Handle touches on the row
	local function onRowTouch( event )
		local phase = event.phase
		local row = event.target
				
		if "release" == phase then
			--Update the item selected text
			itemSelected.text = "You selected item " .. row.index
			
			--Transition out the list, transition in the item selected text and the back button
			transition.to( tableView, { x = - tableView.contentWidth, time = 400, transition = easing.outExpo } )
			transition.to( itemSelected, { x = display.contentCenterX, time = 400, transition = easing.outExpo } )
			transition.to( backButton, { x = display.contentCenterX, time = 400, transition = easing.outQuad } )
		end
	end
	
	-- Create a tableView
	tableView = widget.newTableView
	{
		top = 32,
		width = 320, 
		height = 400,
		listener = tableViewListener,
		onRowRender = onRowRender,
		onRowUpdate = onRowUpdate,
		onRowTouch = onRowTouch,
	}
	group:insert( tableView )
	
	-- Create 100 rows
	for i = 1, 100 do
		local isCategory = false
		local rowHeight = 40
		local rowColor = 
		{ 
			default = { 255, 255, 255 },
			over = { 30, 144, 255 },
		}
		local lineColor = { 220, 220, 220 }
		
		-- Make some rows categories
		if i == 25 or i == 50 or i == 75 then
			isCategory = true
			rowHeight = 24
			rowColor = 
			{ 
				default = { 150, 160, 180, 200 },
			}
		end
		
		-- Insert the row into the tableView
		tableView:insertRow
		{
			isCategory = isCategory,
			rowHeight = rowHeight,
			rowColor = rowColor,
			lineColor = lineColor,
		}
	end
end

scene:addEventListener( "createScene" )

return scene
