-- 
-- Abstract: ShapeTumbler sample project
-- Demonstrates polygon body constructor and tilt-based gravity effects (on device only)
-- 
-- Version: 1.1 (revised for Alpha 2)
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

local physics = require("physics")
physics.start()

physics.setScale( 60 )
physics.setGravity( 0, 9.8 ) -- initial gravity points downwards

system.setAccelerometerInterval( 100 ) -- set accelerometer to maximum responsiveness

-- Build this demo for iPhone to see accelerometer-based gravity
function onTilt( event )
	physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
end

Runtime:addEventListener( "accelerometer", onTilt )


display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "bkg_wood.png" )

borderBodyElement = { friction=0.5, bounce=0.3 }

local borderTop = display.newRect( 0, 0, 320, 20 )
borderTop:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderTop, "static", borderBodyElement )

local borderBottom = display.newRect( 0, 460, 320, 20 )
borderBottom:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderBottom, "static", borderBodyElement )

local borderLeft = display.newRect( 0, 20, 20, 460 )
borderLeft:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderLeft, "static", borderBodyElement )

local borderRight = display.newRect( 300, 20, 20, 460 )
borderRight:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderRight, "static", borderBodyElement )

local triangle = display.newImage("triangle.png")
triangle.x = 80; triangle.y = 160

local triangle2 = display.newImage("triangle.png")
triangle2.x = 170; triangle2.y = 160

local pentagon = display.newImage("pentagon.png")
pentagon.x = 80; pentagon.y = 70

local pentagon2 = display.newImage("pentagon.png")
pentagon2.x = 170; pentagon2.y = 70

local crate = display.newImage("crate.png")
crate.x = 150; crate.y = 250

local crateB = display.newImage("crateB.png")
crateB.x = 250; crateB.y = 250

local crateC = display.newImage("crateC.png")
crateC.x = 260; crateC.y = 50

local soccerball = display.newImage("soccer_ball.png")
soccerball.x = 80; soccerball.y = 320

local superball = display.newImage("super_ball.png")
superball.x = 260; superball.y = 340

local superball2 = display.newImage("super_ball.png")
superball2.x = 240; superball2.y = 130

local superball3 = display.newImage("super_ball.png")
superball3.x = 250; superball3.y = 180


triangleShape = { 0,-35, 37,30, -37,30 }
pentagonShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }

physics.addBody( crate, { density=2, friction=0.5, bounce=0.4 } )
physics.addBody( crateB, { density=4, friction=0.5, bounce=0.4 } )
physics.addBody( crateC, { density=1, friction=0.5, bounce=0.4 } )

physics.addBody( triangle, { density=0.9, friction=0.5, bounce=0.3, shape=triangleShape } )
physics.addBody( triangle2, { density=0.9, friction=0.5, bounce=0.3, shape=triangleShape } )

physics.addBody( pentagon, { density=0.9, friction=0.5, bounce=0.4, shape=pentagonShape } )
physics.addBody( pentagon2, { density=0.9, friction=0.5, bounce=0.4, shape=pentagonShape } )

physics.addBody( soccerball, { density=0.9, friction=0.5, bounce=0.6, radius=38 } )
physics.addBody( superball, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )
physics.addBody( superball2, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )
physics.addBody( superball3, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )