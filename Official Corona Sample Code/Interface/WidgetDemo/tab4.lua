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
	local statusBox = display.newRect( 70, 290, 210, 120 )
	statusBox:setFillColor( 0, 0, 0 )
	statusBox.alpha = 0.4
	group:insert( statusBox )
	
	-- Status text
	local statusText = display.newText( "Interact with a widget to begin!", 80, 300, 200, 0, native.systemFont, 20 )
	statusText.x = statusBox.x
	statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	group:insert( statusText )
	
	---------------------------------------------------------------------------------------------
	-- widget.newSegmentedControl()
	---------------------------------------------------------------------------------------------
	
	-- The listener for our segmented control
	local function segmentedControlListener( event )
		local target = event.target
		
		-- Update the status box text
		statusText.text = "Segmented Control\nSegment Pressed: " .. target.segmentLabel
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	end
	
	-- Create a default segmented control (using widget.setTheme)
	local segmentedControl = widget.newSegmentedControl
	{
	    left = 10,
	    top = 60,
	    segments = { "The", "Corona", "SDK", "Widget", "Demo!" },
	    defaultSegment = 1,
	    onPress = segmentedControlListener,
	}
	group:insert( segmentedControl )
	
	---------------------------------------------------------------------------------------------
	-- widget.newSlider()
	---------------------------------------------------------------------------------------------
	
	-- The listener for our slider's
	local function sliderListener( event )
		-- Update the status box text
		statusText.text = event.target.id .. "\nCurrent Percent:\n" .. event.value .. "%"
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	end
	
	-- Create a horizontal slider
	local horizontalSlider = widget.newSlider
	{
		left = 150,
		top = 232,
		width = 150,
		id = "Horizontal Slider",
		listener = sliderListener,
	}
	group:insert( horizontalSlider )
	
	-- Create a vertical slider
	local verticalSlider = widget.newSlider
	{
		left = 10,
		top = 270,
		height = 150,
		id = "Vertical Slider",
		orientation = "vertical",
		listener = sliderListener,
	}
	group:insert( verticalSlider )
	
	---------------------------------------------------------------------------------------------
	-- widget.newSpinner()
	---------------------------------------------------------------------------------------------
	
	-- Create a spinner widget
	local spinner = widget.newSpinner
	{
		left = 274,
		top = 55,
	}
	group:insert( spinner )
	
	-- Start the spinner animating
	spinner:start()
	
	---------------------------------------------------------------------------------------------
	-- widget.newStepper()
	---------------------------------------------------------------------------------------------
	
	-- Create some text for the stepper
	local currentValue = display.newText( "Value: 00", 165, 105, native.systemFont, 20 )
	currentValue:setTextColor( 0 )
	group:insert( currentValue )
	
	-- The listener for our stepper
	local function stepperListener( event )
		local phase = event.phase

		-- Update the text to reflect the stepper's current value
		currentValue.text = "Value: " .. string.format( "%02d", event.value )
	end
	
	-- Create a stepper
	local newStepper = widget.newStepper
	{
	    left = 50,
	    top = 105,
	    initialValue = 0,
	    minimumValue = 0,
	    maximumValue = 50,
	    onPress = stepperListener,
	}
	group:insert( newStepper )
	
	---------------------------------------------------------------------------------------------
	-- widget.newProgressView()
	---------------------------------------------------------------------------------------------
	
	local newProgressView = widget.newProgressView
	{
		left = 20,
		top = 240,
		width = 100,
		isAnimated = true,
	}
	group:insert( newProgressView )
	
	-- Set the progress to 100%
	newProgressView:setProgress( 1.0 )
	
	---------------------------------------------------------------------------------------------
	-- widget.newSwitch()
	---------------------------------------------------------------------------------------------
	
	-- The listener for our radio switch
	local function radioSwitchListener( event )
		-- Update the status box text
		statusText.text = "Radio Switch\nIs on?: " .. tostring( event.target.isOn )
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	end
		
	-- Create some text to label the radio button with
	local radioButtonText = display.newText( "Use?", 40, 150, native.systemFont, 16 )
	radioButtonText:setTextColor( 0 )
	group:insert( radioButtonText )
		
	-- Create a default radio button (using widget.setTheme)
	local radioButton = widget.newSwitch
	{
	    left = 25,
	    top = 180,
	    style = "radio",
	    id = "Radio Button",
	    initialSwitchState = true,
	    onPress = radioSwitchListener,
	}
	group:insert( radioButton )
	
	local otherRadioButton = widget.newSwitch
	{
	    left = 55,
	    top = 180,
	    style = "radio",
	    id = "Radio Button2",
	    initialSwitchState = false,
	    onPress = radioSwitchListener,
	}
	group:insert( otherRadioButton )
	
	-- Create some text to label the checkbox with
	local checkboxText = display.newText( "Sound?", 110, 150, native.systemFont, 16 )
	checkboxText:setTextColor( 0 )
	group:insert( checkboxText )
	
	-- The listener for our checkbox switch
	local function checkboxSwitchListener( event )
		-- Update the status box text
		statusText.text = "Checkbox Switch\nIs on?: " .. tostring( event.target.isOn )
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	end
	
	-- Create a default checkbox button (using widget.setTheme)
	local checkboxButton = widget.newSwitch
	{
	    left = 120,
	    top = 180,
	    style = "checkbox",
	    id = "Checkbox button",
	    onPress = checkboxSwitchListener,
	}
	group:insert( checkboxButton )

	-- Create some text to label the on/off switch with
	local switchText = display.newText( "Music?", 200, 150, native.systemFont, 16 )
	switchText:setTextColor( 0 )
	group:insert( switchText )

	-- The listener for our on/off switch
	local function onOffSwitchListener( event )
		-- Update the status box text
		statusText.text = "On/Off Switch\nIs on?: " .. tostring( event.target.isOn )
		
		-- Update the status box text position
		statusText.x = statusBox.x
		statusText.y = statusBox.y - ( statusBox.contentHeight * 0.5 ) + ( statusText.contentHeight * 0.5 )
	end

	-- Create a default on/off switch (using widget.setTheme)
	local onOffSwitch = widget.newSwitch
	{
	    left = 190,
	    top = 180,
	    initialSwitchState = true,
	    onPress = onOffSwitchListener,
	    onRelease = onOffSwitchListener,
	}
	group:insert( onOffSwitch )	
end

scene:addEventListener( "createScene" )

return scene
