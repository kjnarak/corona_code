-- 
-- Abstract: PhysicsContact sample project
-- Demonstrates physics "event.contact" usage
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

local physics = require("physics") ; physics.setDrawMode( "normal" )
physics.start()
physics.setGravity( 0,9.8 ) ; physics.setPositionIterations( 16 ) ; physics.setVelocityIterations( 6 )

local stage = display.currentStage
local ox, oy, cw, ch = math.abs(display.screenOriginX), math.abs(display.screenOriginY), display.contentWidth, display.contentHeight


-----------------------
-- create world objects
-----------------------
local background = display.newImage( "background.jpg" )
background:setReferencePoint(display.TopCenterReferencePoint)
background.x = cw/2 ; background.y = -oy ; background.alpha = 0.2

local shadow0 = display.newImage( "shadow.png" )
shadow0.width = 800 ; shadow0.x = cw/2 ; shadow0.y = 84 ; shadow0.alpha = 0.7

local shadow1 = display.newImage( "shadow.png" )
shadow1.x = cw/2 ; shadow1.y = 348 ; shadow1.alpha = 0.7

local platform1 = display.newImage( "platform.png" )
platform1.collType = "passthru"
platform1.x = cw/2 ; platform1.y = 288
physics.addBody(platform1, "static", { bounce=0.5, friction=0.3 } )

local shadow2 = display.newImage( "shadow.png" )
shadow2.x = cw/2 ; shadow2.y = 540 ; shadow2.alpha = 0.7

local platform2 = display.newImage( "platform.png" )
platform2.collType = "passthru"
platform2.x = cw/2 ; platform2.y = 480
physics.addBody(platform2, "static", { bounce=0.5, friction=0.3 } )

local shadow3 = display.newImage( "shadow.png" )
shadow3.x = cw/2 ; shadow3.y = 732 ; shadow3.alpha = 0.7

local platform3 = display.newImage( "platform.png" )
platform3.collType = "passthru"
platform3.x = cw/2 ; platform3.y = 672
physics.addBody(platform3, "static", { bounce=0.5, friction=0.3 } )

local wallL = display.newRect( -ox, -oy, 64, ch+oy+oy ) ; wallL.isVisible = false
wallL.collType = "solidV"
physics.addBody(wallL, "static", { bounce=0.1, friction=0.1 } )

local wallR = display.newRect( cw-64+ox, -oy, 64, ch+oy+oy ) ; wallR.isVisible = false
wallR.collType = "solidV"
physics.addBody(wallR, "static", { bounce=0.1, friction=0.1 } )

local wallB = display.newRect( -ox, ch-64+oy, cw+ox+ox, 64 ) ; wallB.isVisible = false
wallB.collType = "none"
physics.addBody(wallB, "static", { bounce=0.6, friction=0.3 } )

local wallT = display.newRect( -ox, -oy, cw+ox+ox, 64 ) ; wallT.isVisible = false
wallT.collType = "solidH"
physics.addBody(wallT, "static", { bounce=0.1, friction=0.3 } )

local cornerL = display.newImage( "cornerL.png" )
cornerL.x = 64-ox ; cornerL.y = ch-64+oy ; cornerL.rotation = 45
cornerL.collType = "none"
physics.addBody(cornerL, "static", { bounce=1.0, friction=0.3 } )

local cornerR = display.newImage( "cornerR.png" )
cornerR.x = cw-64+ox ; cornerR.y = ch-64+oy ; cornerR.rotation = -45
cornerR.collType = "none"
physics.addBody(cornerR, "static", { bounce=1.0, friction=0.3 } )

for i = 1,math.round((ch+oy+oy)/128) do
	local wall = display.newImage( "wall.png" ) ; wall.x = -ox+32 ; wall.y = (i*128)-64-oy
	local flip = math.random(0,1) ; if ( flip == 1 ) then wall.rotation = -90 else wall.rotation = 90 end ; flip = nil
end
for i = 1,math.round((ch+oy+oy)/128) do
	local wall = display.newImage( "wall.png" ) ; wall.x = cw+ox-32 ; wall.y = (i*128)-64-oy
	local flip = math.random(0,1) ; if ( flip == 1 ) then wall.rotation = -90 else wall.rotation = 90 end ; flip = nil
end
for i = 1,math.round((cw+ox+ox)/128) do
	local wall = display.newImage( "wall.png" ) ; wall.x = (i*128)-64-ox ; wall.y = ch+oy-32
	local flip = math.random(0,1) ; if ( flip == 1 ) then wall.rotation = 0 else wall.rotation = 180 end ; flip = nil
end
for i = 1,math.round((cw+ox+ox)/128) do
	local wall = display.newImage( "wall.png" ) ; wall.x = (i*128)-64-ox ; wall.y = -oy+32
	local flip = math.random(0,1) ; if ( flip == 1 ) then wall.rotation = 0 else wall.rotation = 180 end ; flip = nil
end


--------------------
-- create characters
--------------------

local sheetData1 = { width=64, height=64, numFrames=8, sheetContentWidth=512, sheetContentHeight=64 }
local sheet1 = graphics.newImageSheet( "normalspt_sheet.png", sheetData1 )
local seq1 = { { name="spt1", start=1, count=8, time=400, loopCount=0 } }

local char = display.newSprite( sheet1, seq1 )
char.x = 100 ; char.y = 280 ; char:play()
physics.addBody(char, { radius=20, bounce=0.7, friction=0.3 } )
char:setLinearVelocity(100,0)
char.inJump = false
char.preListen = false
char.setAsSensor = false

local sheetData2 = { width=64, height=64, numFrames=4, sheetContentWidth=256, sheetContentHeight=64 }
local sheet2 = graphics.newImageSheet( "firespt_sheet.png", sheetData2 )
local seq2 = { { name="spt2", start=1, count=4, time=200, loopCount=0 } }

local char2 = display.newSprite( sheet2, seq2 )
char2.x = 400 ; char2.y = 150 ; char2:play()
physics.addBody(char2, { radius=20, bounce=1.0, friction=0.3 } )
char2.collType = "enemy"
char2:setLinearVelocity(-100,0)

local char3 = display.newSprite( sheet2, seq2 )
char3.x = 200 ; char3.y = 150 ; char3:play()
physics.addBody(char3, { radius=20, bounce=1.0, friction=0.3 } )
char3.collType = "enemy"
char3:setLinearVelocity(100,100)


function char:preCollision( event )

	if ( event.other.collType == "passthru" ) then

		local charBase = self.y+20
		local platTop = event.other.y-32

		if ( charBase > platTop+8 ) then
			event.contact.isEnabled = false
			self.isSensor = true ; self.setAsSensor = true
		end

		--[[local vx,vy = self:getLinearVelocity()
		if ( vy < 0 ) then
			event.contact.isEnabled = false
			self.isSensor = true ; self.setAsSensor = true
		end]]--

	end
end


function char:collision( event )

	local vx,vy = self:getLinearVelocity()

	if ( event.phase == "began" ) then
		
		local collType = event.other.collType
		if ( vy >= 0 and self.inJump == true ) then self.inJump = false end
		if ( collType == "enemy" ) then self.inJump = true end
		self:applyLinearImpulse( vx*0.0001, nil, self.x, self.y )
		
		if ( self.setAsSensor == true ) then
			if ( collType == "solidV" ) then self:setLinearVelocity( -vx,vy )
			elseif ( collType == "solidH" ) then self:setLinearVelocity( vx,-vy*0.5 )
			elseif ( collType == "enemy" ) then self:setLinearVelocity( -vx,-vy )
			end
		end

	elseif ( event.phase == "ended" ) then
		self.isSensor = false ; self.setAsSensor = false
	end
	
end


local function doJump( event )

	if ( char.inJump == false and event.phase == "began" ) then
		char.inJump = true
		char:applyLinearImpulse( nil, -0.2, char.x, char.y )
	end

end


char:addEventListener( "preCollision" )
char:addEventListener( "collision" )
stage:addEventListener( "touch", doJump )

local msg = display.newText( "Tap to jump or 'double-jump'", 0, 0, "ContenuBook-Display", 40 )
msg:setTextColor(255,235,205) ; msg.x, msg.y = cw/2,800
transition.to( msg, { time=800, delay=2000, alpha=0 } )