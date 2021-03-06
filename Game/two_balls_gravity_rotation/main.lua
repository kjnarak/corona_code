local physics = require("physics")
physics.start()
physics.setScale( 60 )
physics.setGravity( 0, 0 )

local initialSpeed = 300
local forceFactor = 10
 
local b1 = display.newCircle( 75, 250, 25)
b1:setFillColor(255, 0, 0); 
physics.addBody( b1, { density=1, friction=0, bounce=.9, radius=25 } )
b1:setLinearVelocity( 0, initialSpeed )

local b2 = display.newCircle( 250, 250, 25)
b2:setFillColor(0, 0, 255)
physics.addBody( b2, { density=1, friction=0, bounce=.9, radius=25 } )
b2:setLinearVelocity( 0, -initialSpeed )
 
function ballForce(event) 
	vx = b2.x-b1.x; vy = b2.y-b1.y
	d12 = math.sqrt(vx^2 + vy^2)
	f1x = forceFactor*vx/d12; f1y = forceFactor*vy/d12
	b1:applyForce( f1x, f1y, b1.x, b1.y )
	b2:applyForce( -f1x, -f1y, b2.x, b2.y )
end

Runtime:addEventListener("enterFrame", ballForce)

