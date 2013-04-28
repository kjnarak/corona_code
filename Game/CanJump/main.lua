local physics = require("physics") ; physics.start() ; physics.setGravity( 0.0,9.8 ) ; physics.setDrawMode( "normal" )
display.setStatusBar( display.HiddenStatusBar )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight
local stage = display.getCurrentStage()

--set up terrain and background
local back = display.newImageRect( "sky.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2
local wallL = display.newRect( -ox, -oy+200, 80, ch+oy+oy ) ; wallL.objType = "wall"
physics.addBody(wallL, "static", { bounce=1.0, friction=0.1 } )
local wallR = display.newRect( cw-80+ox, -oy+100, 80, ch+oy+oy ) ; wallR.objType = "wall"
physics.addBody(wallR, "static", { bounce=1.0, friction=0.1 } )
local ground = display.newRect( -ox, ch-64+oy, cw+ox+ox, 64 ) ; ground.objType = "ground"
physics.addBody(ground, "static", { bounce=0.0, friction=0.3 } )
local obsL = display.newRect( -ox+80, ch-184+oy, 300, 120 ) ; obsL.objType = "ground"
physics.addBody(obsL, "static", { bounce=0.0, friction=0.3 } )
local obsR = display.newRect( -ox+380, ch-184+oy, 4, 120 ) ; obsR.objType = "wall"
physics.addBody(obsR, "static", { bounce=1.0, friction=0.3, shape={-2,-50,2,-50,2,60,-2,60 } } )
local text = display.newText( "Tap screen to jump", 0, 0, "Times", 44 ) ; text:setTextColor(0,0,0,160) ; text.y = 140 ; text.x = cw/2

--set up character
local character = display.newRect( 100, 300, 120, 120 ) ; character:setFillColor(0)
physics.addBody( character, "dynamic",
	{ density=1.0, friction=0.0, bounce=0.0 },
	{ shape={20,0,20,65,-20,65,-20,0}, isSensor=true }
	)
character.isFixedRotation = true
character.canJump = 0
character:setLinearVelocity( 120,0 )



--screen touch handler
local function touchAction(event)

	if ( event.phase == "began" and character.canJump > 0 ) then
		local vx,vy = character:getLinearVelocity()
		character:setLinearVelocity( vx,0 )
		character:applyLinearImpulse( 0,-180 )
	end
end
stage:addEventListener( "touch", touchAction )



--collision handler
local function charCollide( self,event )
	if ( event.selfElement == 2 and event.other.objType == "ground" ) then
		if ( event.phase == "began" ) then
			self.canJump = self.canJump+1
		elseif ( event.phase == "ended" ) then
			self.canJump = self.canJump-1
		end
	end
end
character.collision = charCollide ; character:addEventListener( "collision", character )