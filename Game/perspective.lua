--[[
Project: Perspective
Author: Caleb P
Version: 1.4.0

A library for easily and smoothly integrating a virtual camera into your game.
--]]

local function clamp(t, l, h) return (t<l and l) or (t>h and h) or t end
local abs=math.abs

local perspective={
	version="1.4.0",
	author="Caleb P - Gymbyl Coding"
}

function perspective.createView(numLayers)
	--Localize variables
	local view
	local numLayers
	local layer
	local isTracking

	--Check for manual layer creation
	numLayers=(type(numLayers)=="number" and numLayers) or 8

	--Variables
	isTracking=false -- Local so that you can't change it and mess up the view's inner workings
	layer={}

	--Create the camera view
	view=display.newGroup()
		view.scrollX=0
		view.scrollY=0
		view.damping=10
		view._bounds={
			x1=0, 
			x2=display.contentWidth,
			y1=0,
			y2=display.contentHeight
		}

	--Create the layers
	for i=numLayers, 1, -1 do
		layer[i]=display.newGroup()	
		layer[i].parallaxRatio=1 -- Parallax
		layer[i]._isPerspectiveLayer=true -- Just a flag for future updates, not sure what I'm going to do with it
		view:insert(layer[i])
	end
	
	--Function to add objects to camera
	function view:add(obj, perspective, isFocus)
		local isFocus=isFocus or false
		local perspective=perspective or 4
		
		layer[perspective]:insert(obj)
		obj.layer=perspective

		if isFocus==true then
			view._focus=obj
		end
		
		--Moves an object to a layer
		function obj:toLayer(newLayer)
			if layer[newLayer] then
				layer[newLayer]:insert(obj)
				obj._perspectiveLayer=newLayer
			end
		end
		
		--Moves an object back a layer
		function obj:back()
			if layer[obj._perspectiveLayer+1] then
				layer[obj._perspectiveLayer+1]:insert(obj)
				obj._perspectiveLayer=obj.layer+1
			end
		end
			
		--Moves an object forwards a layer
		function obj:forward()
			if layer[obj._perspectiveLayer-1] then
				layer[obj._perspectiveLayer-1]:insert(obj)
				obj._perspectiveLayer=obj.layer-1
			end
		end
		
		--Moves an object to the very front of the camera
		function obj:toCameraFront()
			layer[1]:insert(obj)
			obj._perspectiveLayer=1
			obj:toFront()
		end

		--Moves an object to the very back of the camera
		function obj:toCameraBack()
			layer[numLayers]:insert(obj)
			obj._perspectiveLayer=numLayers
			obj:toBack()
		end

	end

	--View's tracking function
	function view.trackFocus()
		if view._focus then
			layer[1].parallaxRatio=1
			view.scrollX, view.scrollY=layer[1].x, layer[1].y
			for i=1, numLayers do

				if view._focus.x<=view._bounds.x2 and view._focus.x>=view._bounds.x1 then
					if view.damping~=0 then
						layer[i].x=(layer[i].x-(layer[i].x-(-view._focus.x+display.contentCenterX))/view.damping)*layer[i].parallaxRatio
					else
						layer[i].x=-view._focus.x+display.contentCenterX*layer[i].parallaxRatio
					end
				else
					if abs(view._focus.x-view._bounds.x1)<abs(view._focus.x-view._bounds.x2) then
						if view.damping~=0 then
							layer[i].x=(layer[i].x-(layer[i].x-(-view._bounds.x1+display.contentCenterX))/view.damping)*layer[i].parallaxRatio
						else
							layer[i].x=-view._bounds.x1+display.contentCenterX*layer[i].parallaxRatio
						end
					elseif abs(view._focus.x-view._bounds.x1)>abs(view._focus.x-view._bounds.x2) then
						if view.damping~=0 then
							layer[i].x=(layer[i].x-(layer[i].x-(-view._bounds.x2+display.contentCenterX))/view.damping)*layer[i].parallaxRatio
						else
							layer[i].x=-view._bounds.x2+display.contentCenterX*layer[i].parallaxRatio
						end
					end
				end

				if view._focus.y<=view._bounds.y2 and view._focus.y>=view._bounds.y1 then
					if view.damping~=0 then
						layer[i].y=(layer[i].y-(layer[i].y-(-view._focus.y+display.contentCenterY))/view.damping)*layer[i].parallaxRatio
					else
						layer[i].y=-view._focus.y+display.contentCenterY*layer[i].parallaxRatio
					end
				else
					if abs(view._focus.y-view._bounds.y1)<abs(view._focus.y-view._bounds.y2) then
						if view.damping~=0 then
							layer[i].y=(layer[i].y-(layer[i].y-(-view._bounds.y1+display.contentCenterY))/view.damping)*layer[i].parallaxRatio
						else
							layer[i].y=-view._bounds.y1+display.contentCenterY*layer[i].parallaxRatio
						end
					elseif abs(view._focus.y-view._bounds.y1)>abs(view._focus.y-view._bounds.y2) then
						if view.damping~=0 then
							layer[i].y=(layer[i].y-(layer[i].y-(-view._bounds.y2+display.contentCenterY))/view.damping)*layer[i].parallaxRatio
						else
							layer[i].y=-view._bounds.y2+display.contentCenterY*layer[i].parallaxRatio
						end
					end
				end
			
			end
		end
	end
	
	--Start tracking
	function view:track()
		if not isTracking then
			isTracking=true
			Runtime:addEventListener("enterFrame", view.trackFocus)
		end
	end
	
	--Stop tracking
	function view:cancel()
		if isTracking then
			Runtime:removeEventListener("enterFrame", view.trackFocus)
			isTracking=false
		end
	end
	
	--Set bounding box dimensions
	function view:setBounds(x1, x2, y1, y2)
		local x=x1
		local x2=x2
		local y=y1
		local y2=y2
		
		if type(x)=="boolean" then
			view._bounds.x1, view._bounds.x2, view._bounds.y1, view._bounds.y2=-math.huge, math.huge, -math.huge, math.huge
		else
			view._bounds.x1, view._bounds.x2, view._bounds.y1, view._bounds.y2=x1, x2, y1, y2
		end

		return "Perspective View Bounds Set"
	end
	
	--Move camera to an (x,y) point
	function view:toPoint(x, y)
		local x=x or display.contentCenterX
		local y=y or display.contentCenterY
		
		view:cancel()
		local tempFocus={x=x, y=y}
		view:setFocus(tempFocus)
		view:track()

		return tempFocus
	end
	
	--Set the view's focus
	function view:setFocus(obj)
		view._focus=obj
	end
	
	--Get a layer
	function view:layer(t)
		return layer[t]
	end

	--Remove an object from the camera
	function view:remove(obj)
		if obj~=nil and layer[obj._perspectiveLayer]~=nil then
			layer[obj._perspectiveLayer]:remove(obj)
    end
  end
	
	--Destroy the camera
	function view:destroy()
		for n=1, numLayers do
			for i=1, #layer[n] do
				layer[n]:remove(layer[n][i])
			end
		end
		
		if isTracking then
			Runtime:removeEventListener("enterFrame", view.trackFocus)
		end
		display.remove(view)
		view=nil
		return "Deleted Perspective View"
	end

	return view
end

return perspective