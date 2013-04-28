-- 
-- Abstract: Hello World sample app, using native iOS font 
-- To build for Android, choose an available font, or use native.systemFont
--
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.


local background = display.newImage( "world.jpg" )

local myText = display.newText( "Hello, World!", 0, 0, native.systemFont, 40 )
myText.x = display.contentWidth / 2
myText.y = display.contentWidth / 4
myText:setTextColor( 255,110,110 )
