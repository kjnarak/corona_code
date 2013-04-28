local numPoints = 5
local xCenter = 200
local yCenter = 200
local radius = 50
 
local angleStep = 2 * math.pi / numPoints
    
for i = 0, numPoints-1 do
    local circle = display.newCircle(0, 0, 10)
    circle.x = xCenter + radius*math.cos(i*angleStep)
    circle.y = yCenter + radius*math.sin(i*angleStep)
end

