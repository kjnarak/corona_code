-- simple particle gravity - path prediction
 
--http://board.flashkit.com/board/showthread.php?629375-HELP-2D-gravity-simulator-multiple-mass-points
--http://board.flashkit.com/board/showthread.php?610432-Advanced-Gravity&p=3195515&viewfull=1#post3195515
 
--[[
F=G*m*M/(r*r)
F=force in the direction of the object.
G=Gravitational constant=6.67E-11
m=mass of small object
M=mass of big object
r=distance (radius) between the objects centers
]]--
 
display.setStatusBar(display.HiddenStatusBar)
 
sWidth, sHeight = display.contentWidth, display.contentHeight
 
local universe = display.newGroup()
local paths = display.newGroup()
local gravities = display.newGroup()
local particles = display.newGroup()
universe:insert(gravities)
universe:insert(paths)
universe:insert(particles)
--universe.xScale, universe.yScale = .5, .5
 
local count = display.newText( "0", sWidth/2, 20, nil, 50 )
 
-- create gravities
function newGravity(x,y,g)
        local circle = display.newCircle(gravities, x, y, g)
        circle:setFillColor(255,0,0)
        
        -- our magic constant
        circle.G = g
        
        return circle
end
 
max = 0
-- create particles
function newParticle(x,y,vx,vy,r,max)
        local circle = display.newCircle(particles, x, y, r)
        circle:setFillColor(0,255,0)
        
        -- set up initial velocity
        circle.xv = vx
        circle.yv = vy
        
        -- set speed limit
        circle.max = max or 30
        
        -- we use scale to represent mass, higher mass requires greater force to move...
--      circle.mass = 200/gravities[1].G
        
        function circle:update()
                for i=1, gravities.numChildren do
                        local gravity = gravities[i]
                        
                        -- find distance squared
                        local xd = gravity.x - circle.x
                        local yd = gravity.y - circle.y
                        local d2 = xd*xd + yd*yd
                        
                        -- remove if too close to sun
                        if (math.sqrt(d2) < 10) then
                                circle:removeSelf()
                                return
                        end
                        
                        -- calculate force
                        local xf = xd / d2
                        local yf = yd / d2
                        
                        -- apply force to velocity
                        circle.xv = circle.xv + xf*gravity.G -- /circle.mass
                        circle.yv = circle.yv + yf*gravity.G -- /circle.mass
                end
                
                -- throttle velocity
                local len = math.sqrt(circle.xv*circle.xv + circle.yv*circle.yv)
                if (len > circle.max) then
                        local f = circle.max / len
                        circle.xv = circle.xv * f
                        circle.yv = circle.yv * f
                        print("limited: ",math.sqrt(circle.xv*circle.xv + circle.yv*circle.yv))
                end
                
                -- apply velocity to position
                circle.x = circle.x + circle.xv
                circle.y = circle.y + circle.yv
        end
        
        return circle
end
 
newGravity(sWidth/3*2,sHeight/2,50)
--newGravity(sWidth/4*3,sHeight/2,50)
--newGravity(350,200,5)
speedLimit = 12
 
for i=1, 0 do
        newParticle( math.random(100,200),math.random(100,200), math.random(1,7),math.random(1,7), 15, speedLimit )
end
 
-- create particle path
function newParticlePath(x,y,vx,vy,r,max)
        local group = display.newGroup()
        paths:insert(group)
        
        local circle = display.newCircle(group, x, y, r)
        circle:setFillColor(0,0,255)
        
        -- set up initial velocity
        circle.xv = vx
        circle.yv = vy
        
        -- set speed limit
        circle.max = max or 30
        
        -- path points
        for i=1, 1000 do
                display.newCircle(group,-100,-100,5):setFillColor(50,50,50,200)
        end
        
        local function update(index)
                for i=1, gravities.numChildren do
                        local gravity = gravities[i]
                        
                        -- find distance squared
                        local xd = gravity.x - circle.x
                        local yd = gravity.y - circle.y
                        local d2 = xd*xd + yd*yd
                        
                        -- remove if too close to sun
                        if (math.sqrt(d2) < 10) then
                                return false
                        end
                        
                        -- calculate force
                        local xf = xd / d2
                        local yf = yd / d2
                        
                        -- apply force to velocity
                        circle.xv = circle.xv + xf*gravity.G -- /circle.mass
                        circle.yv = circle.yv + yf*gravity.G -- /circle.mass
                end
                
                -- throttle velocity
                local len = math.sqrt(circle.xv*circle.xv + circle.yv*circle.yv)
                if (len > circle.max) then
                        local f = circle.max / len
                        circle.xv = circle.xv * f
                        circle.yv = circle.yv * f
                        print("limited: ",math.sqrt(circle.xv*circle.xv + circle.yv*circle.yv))
                end
                
                -- apply velocity to position
                circle.x = circle.x + circle.xv
                circle.y = circle.y + circle.yv
                
                -- set path point
                if (index % 2 == 0) then
                        group[index/2].x, group[index/2].y = circle.x, circle.y
                end
                
                -- successfully plotted course
                return true
        end
        
        function group:refresh()
                for i=2, group.numChildren*2 do
                        if (not update(i)) then
                                return
                        end
                end
        end
        group:refresh()
        
        return group
end
 
function redo()
        if (paths[1]) then paths[1]:removeSelf() end
        if (particles[1]) then particles[1]:removeSelf() end
        
        local x, y, vx, vy, r = math.random(100,200),math.random(100,200), math.random(1,7),math.random(1,7), 15
        newParticlePath( x, y, vx, vy, r, speedLimit )
 
        newParticle( x, y, vx, vy, r, speedLimit )
end
 
function tap(e)
        newGravity(e.x,e.y,50)
        
        redo()
        
        return true
end
Runtime:addEventListener("tap",tap)
 
function touch(e)
        if (e.phase == "moved") then
                newParticle(e.x,e.y, math.random(-5,5),math.random(-5,5), 15, speedLimit )
        end
        return true
end
Runtime:addEventListener("touch",touch)
 
function enterFrame()
        for i=particles.numChildren, 1, -1 do
                particles[i]:update()
        end
        count.text = particles.numChildren
        
        if (particles.numChildren == 0) then
                redo()
        end
end
Runtime:addEventListener("enterFrame", enterFrame)

