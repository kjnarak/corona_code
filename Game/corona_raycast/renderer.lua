-- Class: Renderer
-- SDK: Corona - 09/12/11
-- Author: Andrew Burch
-- Date: 08/02/12
-- Site: http://www.newhighscore.net
-- Contact: andrew.burch@newhighscore.net
-- Note: Render a single frame from the raycasting engine
--			Very custom and unoptimised
--			Only handles flat filled walls - no textures (..yet)

local tablex = require('tablex')

local floor = math.floor
local min = math.min

-- basic depth shading
local shadeDistanceMax = 500
local shadeConst = 1 / shadeDistanceMax

local colourTable = {
	{r = 140, g = 0, b = 0},
	{r = 0, g = 140, b = 0},
	{r = 0, g = 90, b = 140},
	{r = 90, g = 0, b = 140},
	{r = 90, g = 140, b = 0},
}


local Renderer = {}
local Renderer_mt = {__index = Renderer}

function Renderer.new(params)
	local displayGroup = display.newGroup()
	local referencePoint = display.TopLeftReferencePoint
	
	displayGroup:setReferencePoint(referencePoint)
	
	local renderer = {
		displayGroup = displayGroup,
	}

	return setmetatable(renderer, Renderer_mt)
end

function Renderer:initialise(params)
	local displayGroup = self.displayGroup
	
	local displayWidth = params.displayWidth
	local columnWidth = params.columnWidth
	local horizon = params.horizon

	local referencePoint = display.TopLeftReferencePoint
	local renderTable = {}
	
	for i = 0, displayWidth do
		local slice = display.newRect(i - 1, horizon, columnWidth, 0)
		slice:setFillColor(0, 0, 0)
		slice:setReferencePoint(referencePoint)
		
		table.insert(renderTable, slice)
	end
	
	self.renderTable = renderTable
end

function Renderer:renderScene(params)
	local renderTable = self.renderTable
	local horizon = params.horizon
	local sceneInfo = params.sceneInfo

	for i, sliceInfo in ipairs(sceneInfo) do
		local sliceHeight = sliceInfo.sliceHeight
		local halfSliceHeight = sliceHeight

		local renderSlice = renderTable[i]
		renderSlice.height = sliceHeight

		local colourId = sliceInfo.wallId
		local col = colourTable[colourId]
		local distance = sliceInfo.distance
		local shadeFactor = 1 - (min(distance, shadeDistanceMax) * shadeConst)
		local r = col.r * shadeFactor
		local g = col.g * shadeFactor
		local b = col.b * shadeFactor
		renderSlice:setFillColor(r, g, b)
	end
end

return Renderer