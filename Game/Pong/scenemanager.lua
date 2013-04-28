------------------------------------------------
--[[
SceneManager by Danny

http://developer.coronalabs.com/code/scenemanager
--]]
------------------------------------------------

local scene={}

mainView = display.newGroup()
local nextView = display.newGroup()

--Create a overlay view for when switching scenes
local overlayView = display.newGroup()
overlayView.isVisible = false

local disW = display.contentWidth
local disH = display.contentHeight

local timerTable = {}
local transitionTable = {}

--Create a timer (same as timer.performWithDelay)
function scene:createTimer(dur, func, loop)
	local self = {}
	
	self.dur = dur
	self.func = func
	self.loop = loop or 0
	
	if type(self.func) ~= "function" then
		print("Error: Third argument of create timer must be a function")
	end
	
	timerTable[#timerTable+1] = timer.performWithDelay(self.dur, self.func, self.loop)
	
	return self
end


--Cancel all created timers
function scene:cancelAllTimers()
	for i, v in pairs(timerTable) do
		timer.cancel(timerTable[i])
	end
	
	table.remove(timerTable)
	timerTable = nil
	timerTable = {}
	
	return 0
end

--Pause all created timers
function scene:pauseAllTimers()
	for i, v in pairs(timerTable) do
		timer.pause(timerTable[i])
	end
	
	return 0
end

--Resume all created timers
function scene:resumeAllTimers()
	for i, v in pairs(timerTable) do
		timer.resume(timerTable[i])
	end
	
	return 0
end


---Create transition
function scene:createTransition(params)
	local self = {}
	
	self.target = params.target
	self.tranTime = params.tranTime or 500
	self.delay = params.delay or 0
	self.alpha = params.alpha or self.target.alpha
	self.x = params.x or self.target.x
	self.y = params.y or self.target.y
	self.rotation = params.rotation or self.target.rotation
	self.xScale = params.xScale or self.target.xScale
	self.yScale = params.yScale or self.target.yScale
	self.transition = params.transition or easing.linear
	self.onStart = params.onStart
	self.onComplete = params.onComplete
	
	if params.onStart then
		if type(self.onStart) ~= "function" then
			print("Error: onStart must be a function")
		end
	end
	
	if params.onComplete then
		if type(self.onComplete) ~= "function" then
			print("Error: onComplete must be a function")
		end
	end
	
	if params.onStart then
		transitionTable[#transitionTable+1] = transition.to(self.target, {transition = self.transition, delay = self.delay, time = self.tranTime, alpha = self.alpha, x = self.x, y = self.y, rotation = self.rotation, xScale = self.xScale, yScale = self.yScale, onStart = self.onStart})
	elseif params.onComplete then
		transitionTable[#transitionTable+1] = transition.to(self.target, {transition = self.transition, delay = self.delay, time = self.tranTime, alpha = self.alpha, x = self.x, y = self.y, rotation = self.rotation, xScale = self.xScale, yScale = self.yScale, onComplete = self.onComplete})
	elseif params.onStart and params.onComplete then
		transitionTable[#transitionTable+1] = transition.to(self.target, {transition = self.transition, delay = self.delay, time = self.tranTime, alpha = self.alpha, x = self.x, y = self.y, rotation = self.rotation, xScale = self.xScale, yScale = self.yScale, onStart = self.onStart, onComplete = self.onComplete})
	else
		transitionTable[#transitionTable+1] = transition.to(self.target, {transition = self.transition, delay = self.delay, time = self.tranTime, alpha = self.alpha, x = self.x, y = self.y, rotation = self.rotation, xScale = self.xScale, yScale = self.yScale})
	end
	
	return self
end

--Cancel all transitions
function scene:cancelAllTransitions()
	for i, v in pairs(transitionTable) do
		transition.cancel(transitionTable[i])
	end
	
	table.remove(transitionTable)
	transitionTable = nil
	transitionTable = {}
	
	return 0
end


local currentScreen, effectTrans, currentScreenImage

--Function does nothing when touched
local function disableTouchEvents(event)
	return 0
end

--Overlay Rectangle to cover entire screen between scene changes/transitions
local overlayRect = display.newRect(0, 0, disW, disH)
overlayRect.alpha = 0.01
--Add touch and tap event listeners to rect
overlayRect:addEventListener("touch", disableTouchEvents)
overlayRect:addEventListener("tap", disableTouchEvents)
overlayView:insert(overlayRect)

--Variable that signals whether a effect type passed matches a supported one
local effectMatch = false

--Function to clean the selected scene
local function cleanScene()
	if currentScreen then
		if currentScreen["cleanUp"] then
			currentScreen:cleanUp()
		else
			display.remove(currentScreen)
		end
		
		currentScreen = nil
		collectgarbage("collect")
	end
end

--List of supported effects
local supportedEffects = {"fade", "zoomOutIn", "zoomOutInFade", "zoomInOut", "zoomInOutFade", "flip", "flipFadeOutIn", "zoomOutInRotate", "zoomOutInFadeRotate", "zoomInOutRotate", "zoomInOutFadeRotate", "fromRight", "fromLeft", "fromTop", "fromBottom", "crossFade"}

--The effects list with properties
local effectList = {
	["fade"] = {startAlpha = 0, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["zoomOutIn"] = {startAlpha = 1, endAlpha = 1, startXScale = 0.01, endXScale = 1, startYScale = 0.01, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["zoomOutInFade"] = {startAlpha = 0, endAlpha = 1, startXScale = 0.01, endXScale = 1, startYScale = 0.01, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["zoomInOut"] = {startAlpha = 1, endAlpha = 1, startXScale = 2.5, endXScale = 1, startYScale = 2.5, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["zoomInOutFade"] = {startAlpha = 0, endAlpha = 1, startXScale = 2.5, endXScale = 1, startYScale = 2.5, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["flip"] = {startAlpha = 1, endAlpha = 1, startXScale = 0.1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["flipFadeOutIn"] = {startAlpha = 0, endAlpha = 1, startXScale = 0.1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = false},
	["zoomOutInRotate"] = {startAlpha = 1, endAlpha = 1, startXScale = 0.01, endXScale = 1, startYScale = 0.01, endYScale = 1, startRotation = -360, endRotation = 0, saveScreen = false},
	["zoomOutInFadeRotate"] = {startAlpha = 0, endAlpha = 1, startXScale = 0.01, endXScale = 1, startYScale = 0.01, endYScale = 1, startRotation = -360, endRotation = 0, saveScreen = false},
	["zoomInOutRotate"] = {startAlpha = 1, endAlpha = 1, startXScale = 2.5, endXScale = 1, startYScale = 2.5, endYScale = 1, startRotation = -360, endRotation = 0, saveScreen = false},
	["zoomInOutFadeRotate"] = {startAlpha = 0, endAlpha = 1, startXScale = 2.5, endXScale = 1, startYScale = 2.5, endYScale = 1, startRotation = -360, endRotation = 0, saveScreen = false},
	["fromRight"] = {endX = disW * 0.5, startAlpha = 1, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = true, viewX = disW * 2},
	["fromLeft"] = {endX = disW * 0.5, startAlpha = 1, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = true, viewX = -disW * 2},
	["fromTop"] = {endY = disH * 0.5, startAlpha = 1, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = true, viewY = -disH * 2},
	["fromBottom"] = {endY = disH * 0.5, startAlpha = 1, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = true, viewY = disH * 2},
	["crossFade"] = {startAlpha = 0, endAlpha = 1, startXScale = 1, endXScale = 1, startYScale = 1, endYScale = 1, startRotation = 0, endRotation = 0, saveScreen = true, crossFade = true},
}
	
--Function that exectutes a change of scene (with cleaning) with or without effects
function scene:changeScene(newScreen, effect, effectTime)
	 --Display Overlay over entire screen to prevent accidental touches between scene changes/transitions
	 overlayView.isVisible = true
	 overlayView:toFront()
	 
	--Show error if specified effect either doesn't exist or is spelt incorrectly
	if effect then
		for i = 1, #supportedEffects do
			if effect == supportedEffects[i] then
				match = true
				break
			else
				match = false
			end
		end
		--If the effect passed doesn't match a supported effect, throw an error
		if match == false then
			print("Error : Effect specified is either spelt incorrectly or does not exist. Please check your spelling and ensure it matches a string defined in scene.lua > supportedEffects")
		end
	end
	
	--Hide the overlay group when requested
	local function hideOverlay(event)
		overlayView.isVisible = false
		
		if effectList[effect].saveScreen == true then
			currentScreenImage:removeSelf()
			currentScreenImage = nil
			nextView:toBack()
			nextView.alpha = 1
		end
		
		return 0
	end

	--If the scene should change with effects, execute them upon intial transition completion
	local function executeNextEffect(event)
		--Set mainView's reference point to the center
		mainView:setReferencePoint(display.CenterReferencePoint)
		
		--Clean the previous scene
		if effectList[effect].saveScreen == false then			
			--Clean the Current screen / groups
			cleanScene(currentScreen)
				
			--Load the next target screen
			currentScreen = require(newScreen).new()
				
			--Insert the next target screen
			mainView:insert(currentScreen)
		end
		
		--Execute the final transition
		if effectList[effect].endX then
			effectTrans = transition.to(mainView, {x = effectList[effect].endX, alpha = effectList[effect].endAlpha, xScale = effectList[effect].endXScale, yScale = effectList[effect].endYScale, rotation = effectList[effect].endRotation, time = effectTime or 500, onComplete = hideOverlay})
		elseif effectList[effect].endY then
			effectTrans = transition.to(mainView, {y = effectList[effect].endY, alpha = effectList[effect].endAlpha, xScale = effectList[effect].endXScale, yScale = effectList[effect].endYScale, rotation = effectList[effect].endRotation, time = effectTime or 500, onComplete = hideOverlay})
		else
			effectTrans = transition.to(mainView, {alpha = effectList[effect].endAlpha, xScale = effectList[effect].endXScale, yScale = effectList[effect].endYScale, rotation = effectList[effect].endRotation, time = effectTime or 500, onComplete = hideOverlay})
		end
	end
		
	--If there has been an effect specified execute it	
	if effect then
		--Set mainView's reference point to the center
		mainView:setReferencePoint(display.CenterReferencePoint)
		
		local saveScreen = display.save(currentScreen, "entireGroup.jpg", system.DocumentsDirectory)
		
		--Clean the previous scene
		if effectList[effect].saveScreen == true then
			--Clean the Current screen / groups
			cleanScene(currentScreen)
			
			currentScreenImage = display.newImage("entireGroup.jpg", system.DocumentsDirectory)
			nextView:insert(currentScreenImage)
			
			--Load the next target screen
			currentScreen = require(newScreen).new()
			
			--Insert the next target screen
			mainView:insert(currentScreen)
			
			--Set the mainViews X to the starting x specified by transition
			if effectList[effect].viewX then
				mainView.x = effectList[effect].viewX
			end
			
			--Set the mainViews Y to the starting x specified by transition
			if effectList[effect].viewY then
				mainView.y = effectList[effect].viewY
			end
			
			if effectList[effect].crossFade then
				nextView:toFront()
			end
	end
	
		--Execute the first transition
		if effectList[effect].endX then
			effectTrans = transition.to(mainView, {x = effectList[effect].endX, alpha = effectList[effect].startAlpha, xScale = effectList[effect].startXScale, yScale = effectList[effect].startYScale, rotation = effectList[effect].startRotation, time = effectTime or 500, onComplete = executeNextEffect})
		elseif effectList[effect].endY then
			effectTrans = transition.to(mainView, {y = effectList[effect].endY, alpha = effectList[effect].startAlpha, xScale = effectList[effect].startXScale, yScale = effectList[effect].startYScale, rotation = effectList[effect].startRotation, time = effectTime or 500, onComplete = executeNextEffect})
		elseif effectList[effect].crossFade then
			effectTrans = transition.to(nextView, {alpha = effectList[effect].startAlpha, xScale = effectList[effect].endXScale, yScale = effectList[effect].endYScale, rotation = effectList[effect].endRotation, time = effectTime or 500, onComplete = hideOverlay})
		else
			effectTrans = transition.to(mainView, {alpha = effectList[effect].startAlpha, xScale = effectList[effect].startXScale, yScale = effectList[effect].startYScale, rotation = effectList[effect].startRotation, time = effectTime or 500, onComplete = executeNextEffect})
		end
	--If not just clean up and change scenes
	else
		--Clean the Current screen / groups
		cleanScene(currentScreen)
		
		--Load the next target screen
		currentScreen = require(newScreen).new()
		
		--Insert the next target screen
		mainView:insert(currentScreen)
		
		--Hide the overlay
		overlayView.isVisible = false
	end
	
	return true
end

return scene