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
	
	-- Display a background
	local background = display.newImage( "assets/background.png", true )
	group:insert( background )
	
	-- Status text box
	local statusBox = display.newRect( 50, 60, 210, 80 )
	statusBox:setFillColor( 0, 0, 0 )
	statusBox.alpha = 0.4
	group:insert( statusBox )
	
	-- Status text
	local statusText = display.newText( "Press the values button to show the current values.", 80, 350, 200, 0, native.systemFont, 18 )
	statusText.x = statusBox.x
	statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	group:insert( statusText )
	
	---------------------------------------------------------------------------------------------
	-- widget.newPickerWheel()
	---------------------------------------------------------------------------------------------
	
	local days = {}
	local years = {}
	
	for i = 1, 31 do
		days[i] = i
	end
	
	for i = 1, 44 do
		years[i] = 1969 + i
	end
	
	-- Set up the Picker Wheel's columns
	local columnData = 
	{ 
		{ 
			align = "right",
			width = 150,
			startIndex = 5,
			labels = 
			{
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
			},
		},
		
		{
			align = "left",
			width = 60,
			startIndex = 18,
			labels = days,
		},
		
		{
			align = "center",
			width = 80,
			startIndex = 10,
			labels = years,
		},
	}
		
	-- Create a new Picker Wheel
	local pickerWheel = widget.newPickerWheel
	{
		top = 210,
		font = native.systemFontBold,
		columns = columnData,
	}
	group:insert( pickerWheel )
	
	
	
	local function showValues( event )
		-- Retrieve the current values from the picker
		local values = pickerWheel:getValues()
		
		-- Update the status box text
		statusText.text = "Column 1: " .. values[1].value .. "\nColumn 2: " .. values[2].value .. "\nColumn 3: " .. values[3].value
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
		
		--[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			print( "Column", i, "index is:", values[i].index )
		end
		--]]
		
		return true
	end
	
	
	local getValuesButton = widget.newButton
	{
	    left = 10,
	    top = 150,
		width = 298,
		height = 56,
		id = "getValues",
	    label = "Values",
	    onRelease = showValues,
	}
	group:insert( getValuesButton )
end

scene:addEventListener( "createScene" )

return scene
