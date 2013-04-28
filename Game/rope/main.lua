
-- Rope Demo
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
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
--> Setup Display

display.setStatusBar (display.HiddenStatusBar)
require "gameUI"
 
display.newImage("bg.jpg"); 
 
--> Start Physics
local physics = require ("physics")
physics.start ()
physics.setGravity (0, 10)
 
--physics.setDrawMode ("hybrid")
 
--> Create Walls
local leftWall  = display.newRect (0, 0, 1, display.contentHeight)
local rightWall = display.newRect (display.contentWidth, 0, 1, display.contentHeight)
local ceiling   = display.newRect (0, 0, display.contentWidth, 1)
local floor     = display.newRect (0, display.contentHeight, display.contentWidth, 1)
 
physics.addBody (leftWall, "static", {bounce = 0.0, friction = 10})
physics.addBody (rightWall, "static", {bounce = 0.0, friction = 10})
physics.addBody (ceiling, "static", {bounce = 0.0, friction = 10})
physics.addBody (floor, "static", {bounce = 0.0, friction = 10})

local xCenter = 160
local wCeil = 120
local hCeil = -5
--local ceiling = display.newRect( xCenter - wCeil*0.5, 0, wCeil, hCeil )
physics.addBody( ceiling, "static", { density=0, friction=0.5,bounce=0.2 } )

local prevBody = ceiling

local w,h = 10,10
local halfW,halfH = 0.5*w,0.5*h

-- center of body
local x = xCenter
local y = hCeil - halfH
local yJoint = y - halfH

-- rope
for i = 1, 20 do
	y = y + h
	yJoint = yJoint + h
	
	local body = display.newImage("rope.png" ,x-halfW, y-halfH) --) display.newRect( x-halfW, y-halfH, w, h )
	
	--body:setFillColor( 128, 0, 0 )
	physics.addBody( body, { density=15, friction=0.5, bounce = .2 })
	local joint = physics.newJoint( "pivot", prevBody, body, xCenter, yJoint )

	prevBody = body
end

-- final body

local body = display.newImage("soccerball.png", x,y -30); -- display.newCircle( x, y, r )
local r = body.height *0.5


--body:setFillColor( 0, 0, 255, 128)
physics.addBody( body, { density=2, friction=0.5, bounce=.2, radius=r  })
local joint = physics.newJoint( "pivot", prevBody, body, xCenter, y )

local ball = body
-- Give the ball a push
body:applyLinearImpulse(200,200, ball.x, ball.y)

ball:addEventListener ( "touch", gameUI.dragBody )

