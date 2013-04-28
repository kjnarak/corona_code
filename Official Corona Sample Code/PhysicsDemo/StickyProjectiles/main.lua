local physics = require("physics") ; physics.start() ; physics.setGravity( 0.0,9.8 ) ; physics.setDrawMode( "normal" )
physics.setPositionIterations( 16 ) ; physics.setVelocityIterations( 6 )
display.setStatusBar( display.HiddenStatusBar )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight
local stage = display.getCurrentStage()

--set up terrain and background
local back = display.newImageRect( "sky.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2
local wallL = display.newRect( -ox, -oy, 40, ch+oy+oy )
physics.addBody(wallL, "static", { bounce=0.6, friction=1.0 } )
local wallR = display.newRect( cw-40+ox, -oy, 40, ch+oy+oy )
physics.addBody(wallR, "static", { bounce=0.6, friction=1.0 } )
local wallB = display.newRect( -ox, ch-40+oy, cw+ox+ox, 40 )
physics.addBody(wallB, "static", { bounce=0.6, friction=1.0 } )
local wallT = display.newRect( -ox, -oy, cw+ox+ox, 40 )
physics.addBody(wallT, "static", { bounce=0.6, friction=1.0 } )
local text = display.newText( "Tap screen to launch projectiles", 0, 0, "Times", 44 ) ; text:setTextColor(0,0,0,160) ; text.y = 140 ; text.x = cw/2

--set up boolean for projectile firing
local projFiring = false

--set up projectile sheet
local proj
local options = { width=40, height=40, numFrames=2, sheetContentWidth=80, sheetContentHeight=40 }
local projSheet = graphics.newImageSheet( "projspike.png", options )
local seq = { name = "main", frames = {1,2} }



--function to create new projectiles
local function newProj()

	proj = display.newSprite( projSheet, seq ) ; proj.x = 150 ; proj.y = 600
	physics.addBody( proj, "dynamic", { density=15.0, friction=0.8, bounce=0.3, radius=16 } )
	proj.gravityScale = 0
	projFiring = false
	proj.isBodyActive = false
end



--collision handler
local function projCollide( self,event )

	if ( event.phase == "began" ) then

		--get world coordinates of projectile for joint reference	
		self:removeEventListener( "collision", self ) ; self.collision = nil
		
		--delay function to resolve collision
		local function resolveColl( timerRef )
			if ( timerRef.source.action == "makeJoint" ) then
				local weldJoint = physics.newJoint( "weld", self, event.other, self.x, self.y )
			end
			newProj()
		end

		--check if velocity of projectile is sufficient to "stick"
		local vx,vy = self:getLinearVelocity()
		local dirVel = math.sqrt( (vx*vx)+(vy*vy) )

		if ( dirVel > 330 ) then  --if sufficient, stop velocity and trigger joint creation
			self:setLinearVelocity( 0,0 )
			local t = timer.performWithDelay( 10, resolveColl, 1 ) ; t.action = "makeJoint"
		else  --if not sufficient, "break" projectile and create new
			self:setFrame(2)
			local t = timer.performWithDelay( 10, resolveColl, 1 ) ; t.action = "none"
		end

	end
end



--screen touch handler
local function touchAction(event)

	if ( event.phase == "began" and projFiring == false ) then
		
		projFiring = true
		proj.isBodyActive = true
		local px,py = event.x-proj.x, event.y-proj.y

		proj:applyLinearImpulse( px/2, py/2, proj.x, proj.y )
		proj:applyTorque( 1200 )
		proj.gravityScale = 1.0
		proj.collision = projCollide ; proj:addEventListener( "collision", proj )
	end
end
stage:addEventListener( "touch", touchAction )


newProj()