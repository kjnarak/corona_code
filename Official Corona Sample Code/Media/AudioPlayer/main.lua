-- Project: AudioPlayer
--
-- Date: August 1, 2012
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract:  Audio Sound Sample Code for audio* api.
--
-- Demonstrates:
--			audio.loadSound, audio.loadStream, audio.play, audio.pause, audio.resume, 
--			audio.setVolume, audio.isChannelPlaying, audio.isChannelPaused.
--			system.getInfo 	-- For determining platform type.
--			Widget library for creating buttons and other gui elements.
--			Use of lua tables.
--			Use of string formatting.
--
-- File dependencies: none
--
-- Target devices: Simulator and iOS / Android Devices
--
-- Limitations: Certain formats will not play on some devices
--
-- Update History:
--	v1.1
--		Fixed file name problem (some file names start with uppercase characters)
--	v1.2
--		Made each file unique to work with Android OS
--		Preloads the EventSound player (for Android)
--		Loads default sound format based on device type
--		Displays message if sound format not supported by device.
--
--	v1.3 
--		Completely remade sample.
--		Supports new openAL audio api.
--
-- Comments: 
--		Supports: .aac, .aif, .caf, .wav, .mp3 and .ogg audio formats
--		Notes: 
--			iOS ( iPhone/iPad/iPod Touch ) doesn't support .ogg format audio.
--			Android only supports .wav, .mp3 and .ogg format audio.			
--
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

--Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

--Require the widget library ( we will use this to create buttons and other gui elements )
local widget = require( "widget" )

--Create a background
local background = display.newImage( "bg.jpg", true )
background.x, background.y = display.contentCenterX, display.contentCenterY

--Box to underlay our audio status text
local gradient = graphics.newGradient(
	{ 255, 255, 255 },
	{ 117, 139, 168, 255 },
	"down")

local statusBox = display.newRect( display.contentWidth * 0.5, 24, display.contentWidth, 44 )
statusBox:setFillColor( gradient )
statusBox.x, statusBox.y = display.contentCenterX, 20
statusBox.alpha = 0.7

--Create a text object to show the current status
local statusText = display.newText( "Audio Player Sample", 0, 0, native.systemFontBold, 18 )
statusText.x, statusText.y = statusBox.x, statusBox.y --Position the text in the middle of the status box

--Variable to store what platform we are on.
local platform

--Check what platform we are running this sample on
if system.getInfo( "platformName" ) == "Android" then
	platform = "Android"
elseif system.getInfo( "platformName" ) == "Mac OS X" then
	platform = "Mac"
elseif system.getInfo( "platformName" ) == "Win" then
	platform = "Win"
else
	platform = "IOS"
end

--Create a table to store what types of audio are supported per platform
local supportedAudio = {
	["Mac"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3", ".ogg" } },
	["IOS"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3" } },
	["Win"] = { extensions = { ".wav", ".mp3", ".ogg" } },
	["Android"] = { extensions = { ".wav", ".mp3", ".ogg" } },
}

--Create a table to store what types of audio files should be streamed or loaded fully into memory.
local loadTypes = {
	["sound"] = { extensions = { ".aac", ".aif", ".caf", ".wav" } },
	["stream"] = { extensions = { ".mp3", ".ogg" } },
}

--Forward references for our buttons/labels
local volumeLabel
local loopButton, playButton, stopButton

--Variables
local audioFiles = { "note2", "bouncing" } --Table to store what audio files are available for playback. (ie included in the app).
local audioLoaded, audioHandle = nil, nil --Variables to hold audio states.
local audioLoops = 0	--Variables to hold audio states.
local audioVolume = 0.5 --Variables to hold audio states.
local audioWasStopped = false -- Variable to hold whether or not we have manually stopped the currently playing audio.

--Set the initial volume to match our initial audio volume variable
audio.setVolume( audioVolume, { channel = 1 } )


--Handle slider events
local function sliderListener( event )
	local value = event.value
		    		    
	--Convert the value to a floating point number we can use it to set the audio volume	
	audioVolume = value / 100
	audioVolume = string.format('%.02f', audioVolume )
	
	--Update the volume text to reflect the new value
	volumeLabel.text = "Volume: " .. audioVolume
				
	--Set the audio volume at the current level
   	audio.setVolume( audioVolume, { channel = 1 } )
end

--Create a slider to control the volume level
local volumeSlider = widget.newSlider
{
	left = 50,
	top = 210,
	width = display.contentWidth - 80,
	orientation = "horizontal",
	listener = sliderListener
}

--Create our volume label to display the current volume on screen
volumeLabel = display.newText( "Volume: " .. audioVolume .. "0", 0, 0, native.systemFontBold, 18 )
volumeLabel.x, volumeLabel.y = display.contentCenterX, volumeSlider.y + volumeLabel.contentHeight


-- Set up the Picker Wheel's columns
local columnData = 
{ 
	{ 
		align = "left",
		width = 200,
		startIndex = 1,
		labels = audioFiles,
	},

	{
		align = "right",
		width = 100,
		startIndex = 1,
		labels = supportedAudio[ platform ].extensions,
	},
}

--Create the picker which will display our audio files & extensions
local audioPicker = widget.newPickerWheel
{
	top = display.contentHeight - 222, 	
	font = native.systemFontBold,
	columns = columnData,
}


--Function to handle all button events
local function manageButtonEvents( event )
	local phase = event.phase
	local buttonPressed = event.target.id
	
	if phase == "began" then
		--Loop Button
		if buttonPressed == "loopAudio" then
			--Toggle the buttons state ( 1 or 0 )
			loopButton.toggle = 1 - loopButton.toggle
			
			--If loop is set to on
			if loopButton.toggle == 1 then
				--Set the audio to loop forever
				audioLoops = -1
				
				--Set the buttons label to true
				loopButton:setLabel( "Loop: Yes" )
				
				--Update status text
				statusText.text = "Audio will loop forever"
				
				--If there is audio playing, stop it so that when it is played again it will reflect the change in loop setting
				if audio.isChannelPlaying( 1 ) then
					audio.stop( 1 )
				end
			--If loop is set to off
			else
				--Set the audio to not loop
				audioLoops = 0
				
				--Set the buttons label to false
				loopButton:setLabel( "Loop: No" )
				
				--Update status text
				statusText.text = "Audio will play once"
				
				--If there is audio playing, stop it so that when it is played again it will reflect the change in loop setting
				if audio.isChannelPlaying( 1 ) then
					audio.stop( 1 )
				end
			end

		
		--Play button
		elseif buttonPressed == "PlayAudio" then
			--Toggle the buttons state ( 1 or 0 )
			playButton.toggle = 1 - playButton.toggle
			
			--Function to reset the play button state when audio completes playback
			local function resetButtonState()
				playButton:setLabel( "Play" ); 
				playButton.toggle = 0
				
				--Only update the status text to finished if we didn't stop the audio manually
				if audioWasStopped == false then
					--Update status text
					statusText.text = "Playback finished on channel 1"
				end
				
				--Set the audioWasStopped flag back to false
				audioWasStopped = false
			end
				
			--Audio playback is set to paused		
			if playButton.toggle == 0 then
				--Pause any currently playing audio
				if audio.isChannelPlaying( 1 ) then
					audio.pause( 1 )
				end
				
				--Set the buttons label to "Resume"
				playButton:setLabel( "Resume" )
				
				--Update status text
				statusText.text = "Audio paused on channel 1"
				
			--Audio playback is set to play	
			else
				--If the audio is paused resume it
				if audio.isChannelPaused( 1 ) then
					audio.resume( 1 )
					
					--Update status text
					statusText.text = "Audio resumed on channel 1"
					
				--If not play it from scratch
				else
				 	local audioFileSelected = audioPicker:getValues()[1].index
				 	local audioExtensionSelected = audioPicker:getValues()[2].index
					
					--Print what sound we have loaded to the terminal
					print( "Loaded sound:", audioFiles[ audioFileSelected ] .. supportedAudio[ platform ].extensions[ audioExtensionSelected ] )
					
					--If we are trying to load a sound, then use loadSound
					if supportedAudio[ platform ].extensions[ audioFileSelected ] == loadTypes[ "sound" ].extensions[ audioExtensionSelected ] then
						--Load the audio file fully into memory
						audioLoaded = audio.loadSound( audioFiles[ audioFileSelected ] .. supportedAudio[ platform ].extensions[ audioExtensionSelected ] )
						--Play audio file
						audioHandle = audio.play( audioLoaded, { channel = 1, loops = audioLoops, onComplete = resetButtonState } )
					else
						--Load the audio file in chunks
						audioLoaded = audio.loadStream( audioFiles[ audioFileSelected ] .. supportedAudio[ platform ].extensions[ audioExtensionSelected ] )
						--Play the audio file
						audioHandle = audio.play( audioLoaded, { channel = 1, loops = audioLoops, onComplete = resetButtonState } )
					end
					
					--Update status text
					statusText.text = "Audio playing on channel 1"
				end
				
				--Set the buttons label to "Pause"
				playButton:setLabel( "Pause" )
			end

			--Stop button
			elseif buttonPressed == "StopAudio" then
				--If there is audio playing on channel 1
				if audio.isChannelPlaying( 1 ) then
					--Stop the audio
					audio.stop( 1 )
					
					--Let the system know we stopped the audio manually
					audioWasStopped = true
					
					--Update status text
					statusText.text = "Stopped Audio on channel 1"
					
				--No audio currently playing
				else
					--Update status text
					statusText.text = "No Audio playing to stop!"
				end
			end
		end
	
	return true
end


--Play/pause/resume Button
playButton = widget.newButton{
	id = "PlayAudio",
	style = "sheetBlack",
	label = "Play",
	yOffset = - 3,
	fontSize = 24,
	emboss = true,
	width = 140,
	onEvent = manageButtonEvents,
}
playButton.toggle = 0
playButton.x, playButton.y = playButton.contentWidth * 0.5 + 10, 80


--Stop button
stopButton = widget.newButton{
	id = "StopAudio",
	style = "sheetBlack",
	label = "Stop",
	yOffset = - 3,
	fontSize = 24,
	emboss = true,
	width = 140,
	onEvent = manageButtonEvents,
}
stopButton.x, stopButton.y = display.contentWidth - stopButton.contentWidth * 0.5 - 10, 80


--Loop Button
loopButton = widget.newButton{
	id = "loopAudio",
	style = "sheetBlack",
	label = "Loop: No",
	yOffset = -3,
	fontSize = 24,
	emboss = true,
	width = 140,
	onEvent = manageButtonEvents,
}
loopButton.toggle = 0
loopButton.x, loopButton.y = display.contentCenterX, stopButton.y + stopButton.contentHeight + loopButton.contentHeight * 0.5 - 10
