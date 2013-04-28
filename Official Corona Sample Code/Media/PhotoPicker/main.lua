-- Abstract: Photo Library sample app
-- 
-- Demonstrates how to display pick and display a photo from the photo library.
--
-- Update History:
-- 	v1.0	12/1/11		Initial program
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

local photo		-- holds the photo object
local PHOTO_FUNCTION = media.PhotoLibrary 		-- or media.SavedPhotosAlbum

-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "No Photo Library available on iOS Simulator.", { "OK"})    
end
--

print( "display.contentScale x,y: " .. display.contentScaleX, display.contentScaleY )

local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 128, 0, 0 )

local text = display.newText( "Tap to launch Photo Picker", 0, 0, nil, 16 )
text:setTextColor( 255, 255, 255 )
text.x = display.contentCenterX
text.y = display.contentCenterY

-- Media listener
-- Executes after the user picks a photo (or cancels)
--
local sessionComplete = function(event)
	photo = event.target
	
	if photo then

		if photo.width > photo.height then
			photo:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = display.contentWidth / photo.contentWidth
		local yScale = display.contentHeight / photo.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		photo:scale( scale, scale )
		photo.x = display.contentCenterX
		photo.y = display.contentCenterY
		print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )

	else
		text.text = "No Image Selected"
		text.x = display.contentCenterX
		text.y = display.contentCenterY
		print( "No Image Selected" )
	end
end

-- Screen tap comes here to launch Photo Picker
--
local tapListener = function( event )
	display.remove( photo )		-- remove the previous photo object
	text.text = "Select a picture ..."
	text.x = display.contentCenterX
	text.y = display.contentCenterY
	
	-- Delay some to allow the display to refresh before calling the Photo Picker
	timer.performWithDelay( 100, function() media.show( PHOTO_FUNCTION, sessionComplete ) 
	end )
	return true
end

bkgd:addEventListener( "tap", tapListener )
