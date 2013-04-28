display.setStatusBar( display.HiddenStatusBar )

-- Example of bezier curve module on how to use it
-- Author: Rajendra Pondel (@neostar20)

-- main.lua

local bezier = require('bezier')

local curve1 =  bezier:curve({0, 160, 320}, {0, 480*1.5, 0})
local x1, y1 = curve1(0.01)
local line1 = display.newLine(x1, y1, x1+1, y1+1)
line1:setColor( 255, 0, 0, 255 )
line1.width = 3

for i=0.02, 1, 0.01 do
	local x, y = curve1(i)
	line1:append(x, y)
end


local curve2 =  bezier:curve({0, 100, 240, 0}, {0, 10, 100, 400})
local x1, y1 = curve2(0.01)
local line2 = display.newLine(x1, y1, x1+1, y1+1)
line2:setColor(0, 255, 0, 255 )
line2.width = 3

for i=0.02, 1.01, 0.01 do
	local x, y = curve2(i)
	line2:append(x, y)
	print(i, x, y)
end


local curve3 =  bezier:curve({320, 240, 100, 320}, {0, 10, 100, 400})
local x1, y1 = curve3(0.01)
local line3 = display.newLine(x1, y1, x1+1, y1+1)
line3:setColor(0, 0, 255, 255 )
line3.width = 3

for i=0.02, 1.01, 0.01 do
	local x, y = curve3(i)
	line3:append(x, y)
	print(i, x, y)
end