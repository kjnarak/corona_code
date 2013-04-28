Bezier Curve for Corona SDK

A Bézier curve is a parametric curve frequently used in computer graphics and related fields. Generalizations of Bézier curves to higher dimensions are called Bézier surfaces, of which the Bézier triangle is a special case.

In vector graphics, Bézier curves are used to model smooth curves that can be scaled indefinitely. "Paths," as they are commonly referred to in image manipulation programs,[note 1] are combinations of linked Bézier curves. Paths are not bound by the limits of rasterized images and are intuitive to modify. Bézier curves are also used in animation as a tool to control motion.

From: http://en.wikipedia.org/wiki/B%C3%A9zier_curve

Forget the Bezier Curve function Carlos created (http://www.carlosicaza.com/2011/01/03/bezier-curve-fitting-in-corona-sdk/) which only accepts two control points, 
putting you in the constrain of having only two control points.

I have created a Bezier Curve function which accepts unlimited number of control points, which allows you do get any type of curve you dreamed of.

Below is the simple Module of Bezier Curve:

<lua>
module(...,package.seeall)
-------------------------------------------------
-- bezier.lua
-- Version: 1.0
-- Author: Rajendra Pondel
-- Email: neostar20@gmail.com
-- Licence: MIT Licence

local bezier = {}

function bezier:curve(xv, yv)
	local reductor = {__index = function(self, ind)
		return setmetatable({tree = self, level = ind}, {__index = function(curves, ind)
			return function(t)
				local x1, y1 = curves.tree[curves.level-1][ind](t)
				local x2, y2 = curves.tree[curves.level-1][ind+1](t)
				return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
				end
			end})
		end
	}
	local points = {}
	for i = 1, #xv do
			points[i] = function(t) return xv[i], yv[i] end
	end
	return setmetatable({points}, reductor)[#points][1]
end

return bezier
</lua>

And below is how to use the beizer curve module:

Remember, first and the last points are initial and ending points respectively when you pass parameter to the bezier:curve() function.

For example:

<lua>
	local curve = bezier:curve({xInitial, xControlPoint1, xControlPoint2, xControlPoint3}, {yInitial, yControlPoint1, yControlPoint2, yControlPoint3})
	
</lua>

Now, "curve" is a local variable, which is a function, so you can pass the granularity to it, for example:

<lua>
for i=1, 10, 0.1 do
	local x, y = curve(i)
	print(i, 'X: ' .. x, 'Y: ' .. y)
end
</lua>

So, this is how you really use it:

<lua>
display.setStatusBar( display.HiddenStatusBar )

-- main.lua

local bezier = require('bezier')

local curve = bezier:curve({10, 20, 30}, {10, 20, 30})

print('curve is a ' .. type(curve))

-- see the terminal for the output of the function

for i=1, 10, 0.1 do
	local x, y = curve(i)
	print(i, 'X: ' .. x, 'Y: ' .. y)
end
</lua>

