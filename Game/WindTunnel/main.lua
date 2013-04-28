local physics = require("physics") ; physics.start() ; physics.setGravity( 0.0,6.8 ) ; physics.setDrawMode( "normal" )
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 255,0,0,0 )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight
local stage = display.getCurrentStage()

--set up collision filters
local intFilter = {categoryBits=1,maskBits=2}
local leafFilter = {categoryBits=2,maskBits=1}

--set up terrain and background
local back = display.newImageRect( "sky.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2
local wallL = display.newRect( -ox, -oy, 40, ch+oy+oy )
physics.addBody(wallL, "static", { bounce=1.0, friction=1.0, filter=intFilter } )
local wallR = display.newRect( cw-40+ox, -oy, 40, ch+oy+oy )
physics.addBody(wallR, "static", { bounce=1.0, friction=1.0, filter=intFilter } )
local wallB = display.newRect( -ox, ch-40+oy, cw+ox+ox, 40 )
physics.addBody(wallB, "static", { bounce=1.0, friction=1.0, filter=intFilter } )
local wallT = display.newRect( -ox, -oy, cw+ox+ox, 40 )
physics.addBody(wallT, "static", { bounce=1.0, friction=1.0, filter=intFilter } )

--set up leaves
local leaf1 = display.newImageRect( "leaf.png", 48, 48 ) ; leaf1.x = 200 ; leaf1.y = 300
physics.addBody( leaf1, "dynamic", { density=1.0, friction=0.3, bounce=0.5, radius=24, filter=leafFilter } )
leaf1.gravityScale = 0.5 ; leaf1:applyTorque( 200 ) ; leaf1.angularDamping = 0.1 ; leaf1.linearDamping = 0.3
leaf1.xF = 0 ; leaf1.yF = 0
local leaf2 = display.newImageRect( "leaf.png", 48, 48 ) ; leaf2.x = 500 ; leaf2.y = 200
physics.addBody( leaf2, "dynamic", { density=1.0, friction=0.3, bounce=0.5, radius=24, filter=leafFilter } )
leaf2.gravityScale = 0.5 ; leaf2:applyTorque( -100 ) ; leaf2.angularDamping = 0.1 ; leaf2.linearDamping = 0.3
leaf2.xF = 0 ; leaf2.yF = 0

--set up sprites
local options = { width=80, height=300, numFrames=6, sheetContentWidth=480, sheetContentHeight=300 }
local ventSheet = graphics.newImageSheet( "ventsheet.png", options )
local seqs = { { name="main1", start=1, count=6, time=200 },
					{ name="main2", frames={4,5,6,1,2,3}, time=160 } }



--function to return force values for vent, depending on angle and power
local function getVentVals( angle, power )
	local xF = math.cos( (angle-90)*(math.pi/180) ) * power
	local yF = math.sin( (angle-90)*(math.pi/180) ) * power
	return xF,yF
end



--set up vents
local vent1 = display.newSprite( ventSheet, seqs )
physics.addBody(vent1, "kinematic", { isSensor=true, filter=intFilter } )
vent1.isVent = true ; vent1.rotation = 14 ; vent1.x = 432 ; vent1.y = 660 ; vent1:setSequence("main2") ; vent1:play()
--for each vent, get angular force values depending on its angle and the "power" you pass to it
vent1.xF, vent1.yF = getVentVals( vent1.rotation, 160 )

local vent2 = display.newSprite( ventSheet, seqs )
physics.addBody(vent2, "kinematic", { isSensor=true, filter=intFilter } )
vent2.isVent = true ; vent2.rotation = 25 ; vent2.x = 302 ; vent2.y = 620 ; vent2:setSequence("main2") ; vent2:play()
vent2.xF, vent2.yF = getVentVals( vent2.rotation, 200 )

local vent3 = display.newSprite( ventSheet, seqs )
physics.addBody(vent3, "kinematic", { isSensor=true, filter=intFilter } )
vent3.isVent = true ; vent3.rotation = -60 ; vent3.x = 872 ; vent3.y = 500 ; vent3:setSequence("main1") ; vent3:play()
vent3.xF, vent3.yF = getVentVals( vent3.rotation, 120 )

local vent4 = display.newSprite( ventSheet, seqs )
physics.addBody(vent4, "kinematic", { isSensor=true, filter=intFilter } )
vent4.isVent = true ; vent4.rotation = 60 ; vent4.x = 152 ; vent4.y = 500 ; vent4:setSequence("main1") ; vent4:play()
vent4.xF, vent4.yF = getVentVals( vent4.rotation, 120 )

local vent5 = display.newSprite( ventSheet, seqs )
physics.addBody(vent5, "kinematic", { isSensor=true, filter=intFilter } )
vent5.isVent = true ; vent5.rotation = -25 ; vent5.x = 722 ; vent5.y = 620 ; vent5:setSequence("main2") ; vent5:play()
vent5.xF, vent5.yF = getVentVals( vent5.rotation, 200 )

local vent6 = display.newSprite( ventSheet, seqs )
physics.addBody(vent6, "kinematic", { isSensor=true, filter=intFilter } )
vent6.isVent = true ; vent6.rotation = -14 ; vent6.x = 592 ; vent6.y = 660 ; vent6:setSequence("main2") ; vent6:play()
vent6.xF, vent6.yF = getVentVals( vent6.rotation, 160 )



--Runtime listener to apply force to leaves within vent(s)
local function constantForce()

	if not ( leaf1.xF == 0 and leaf1.yF == 0 ) then leaf1:applyForce( leaf1.xF, leaf1.yF, leaf1.x, leaf1.y ) end
	if not ( leaf2.xF == 0 and leaf2.yF == 0 ) then leaf2:applyForce( leaf2.xF, leaf2.yF, leaf2.x, leaf2.y ) end
end



--collision handler
local function ventCollide( self,event )

	local vent = event.other
	--add vent's force parameters to leaf's self parameters
	if ( event.phase == "began" and vent.isVent == true ) then
		self.xF = self.xF+vent.xF ; self.yF = self.yF+vent.yF
	--substract vent's force parameters from leaf's self parameters
	elseif ( event.phase == "ended" and vent.isVent == true ) then
		self.xF = self.xF-vent.xF ; self.yF = self.yF-vent.yF
	end			
end
leaf1.collision = ventCollide ; leaf1:addEventListener( "collision", leaf1 )
leaf2.collision = ventCollide ; leaf2:addEventListener( "collision", leaf2 )


Runtime:addEventListener( "enterFrame", constantForce )