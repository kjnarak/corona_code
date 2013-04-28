display.setStatusBar(display.HiddenStatusBar)

----------------------------------------------
--CBResources Sample App
----------------------------------------------

local originX
local exitX

local wrap

local initiate
local either

local widget

local logo
local toFront

local buttonSheet

local CBE
	local ParticleHelper

local samples
	local sampleLib
	local curSample
	local nextSample
	local prevSample
	local numSamples

local texts
	local centerText
	local leftText
	local rightText
	local centerBkg
	local leftBkg
	local rightBkg
	local updateTexts

local buttons
	local leftButton
	local rightButton
	local leftListener
	local rightListener



errorListener=function(event)
	if event.index==1 then
		system.openURL("http://developer.coronalabs.com/code/cbeffects")
	end
end

either=function(table)
	if #table==0 then
		return nil
	else
		return table[math.random(#table)]
	end
end

initiate=function()
	originX=display.screenOriginX
	exitX=display.contentWidth-originX

	function wrap(num, high)
		return ((num-1)%high)+1
	end

	CBE=require("CBEffects.Library")
	ParticleHelper=package.loaded["CBEffects.ParticleHelper"]
	widget=require("widget")

	samples={}
	curSample=0; nextSample=0; prevSample=0; numSamples=0

	buttonSheet=graphics.newImageSheet("Textures/generic_particle.png", {width=200, height=200, numFrames=1})

	--[[
		Build Preset Samples
	--]]
	for k, v in pairs(ParticleHelper.presets.vents) do
		samples[#samples+1]={title="Preset: "..string.upper(k:sub(1,1))..k:sub(2,#k)}
		local s=samples[#samples]
		s.initiate=function()
			s.sampleVGroup=CBE.VentGroup{
				{preset=k}
			}
			s.sampleVGroup:startMaster()
		end
		s.stop=function()
			s.sampleVGroup:destroyMaster()
			s.sampleVGroup=nil
		end
		numSamples=numSamples+1
	end

	--[[
		Build SampleLib Samples
	--]]
	sampleLib=require("samples")

	for i=1, #sampleLib do
		samples[#samples+1]=sampleLib[i]
		numSamples=numSamples+1
	end

	curSample=numSamples
	prevSample=wrap(curSample-1, numSamples)
	nextSample=wrap(curSample+1, numSamples)

	--[[
		Build Status Texts
	--]]
	texts=display.newGroup()

		centerText=display.newText(samples[curSample].title, 0, 0, "Trebuchet MS", 30)
		centerText.x, centerText.y=512, 47
		centerText:setTextColor(255, 255, 0)
		texts:insert(centerText)

		centerBkg=display.newRoundedRect(0, 0, centerText.width*1.2, centerText.height*1.1, 10)
		centerBkg.x, centerBkg.y=512, 50
		centerBkg:setFillColor(0, 0, 0)
		centerBkg.strokeWidth=6
		centerBkg:setStrokeColor(255, 255, 0)
		texts:insert(centerBkg)


		leftText=display.newText(samples[prevSample].title, 0, 0, "Trebuchet MS", 20)
		leftText:setReferencePoint(display.CenterLeftReferencePoint)
		leftText.x, leftText.y=originX+30, 27
		leftText:setTextColor(255, 255, 0, 127.5)
		texts:insert(leftText)

		leftBkg=display.newRoundedRect(0, 0, leftText.width*1.2, leftText.height*1.1, 10)
		leftBkg.x, leftBkg.y=leftText.x+(leftText.width/2), 30
		leftBkg:setFillColor(0, 0, 0)
		leftBkg.strokeWidth=6
		leftBkg:setStrokeColor(255, 255, 0, 127.5)
		texts:insert(leftBkg)

		rightText=display.newText(samples[nextSample].title, 0, 0, "Trebuchet MS", 20)
		rightText:setReferencePoint(display.CenterRightReferencePoint)
		rightText.x, rightText.y=exitX-30, 27
		rightText:setTextColor(255, 255, 0, 127.5)
		texts:insert(rightText)

		rightBkg=display.newRoundedRect(0, 0, rightText.width*1.2, rightText.height*1.1, 10)
		rightBkg.x, rightBkg.y=rightText.x-(rightText.width/2), 30
		rightBkg:setFillColor(0, 0, 0)
		rightBkg.strokeWidth=6
		rightBkg:setStrokeColor(255, 255, 0, 127.5)
		texts:insert(rightBkg)


		function updateTexts()
			centerBkg.width=centerText.width*1.2

			leftText:setReferencePoint(display.CenterLeftReferencePoint)
			leftText.x, leftText.y=originX+30, 27

			rightText:setReferencePoint(display.CenterRightReferencePoint)
			rightText.x, rightText.y=exitX-30, 27

			leftBkg.width=leftText.width*1.2
			leftBkg.x=leftText.x+(leftText.width/2)

			rightBkg.width=rightText.width*1.2
			rightBkg.x=rightText.x-(rightText.width/2)


			rightText:toFront()
			leftText:toFront()
			centerText:toFront()
		end
		updateTexts()

	buttons=display.newGroup()

		function leftListener()
			samples[curSample].stop()
			curSample=wrap(curSample-1, numSamples)
			prevSample=wrap(curSample-1, numSamples)
			nextSample=wrap(curSample+1, numSamples)

			samples[curSample].initiate()

			centerText.text=samples[curSample].title
			rightText.text=samples[nextSample].title
			leftText.text=samples[prevSample].title
			updateTexts()
		end

		function rightListener()
			samples[curSample].stop()
			curSample=wrap(curSample+1, numSamples)
			prevSample=wrap(curSample-1, numSamples)
			nextSample=wrap(curSample+1, numSamples)

			samples[curSample].initiate()

			centerText.text=samples[curSample].title
			rightText.text=samples[nextSample].title
			leftText.text=samples[prevSample].title
			updateTexts()
		end

		leftButton=widget.newButton{
			defaultFile="Textures/button_default.png",
			overFile="Textures/button_over.png",
			width=64,
			height=64,
			onRelease=leftListener,
			isEnabled=false
		}
		leftButton.x, leftButton.y=originX+32, 384
		buttons:insert(leftButton)
		leftButton:setFillColor(255, 255, 0)
		leftButton._view._over:setFillColor(255, 255, 0)

		rightButton=widget.newButton{
			defaultFile="Textures/button_default.png",
			overFile="Textures/button_over.png",
			width=64,
			height=64,
			onRelease=rightListener,
			isEnabled=false
		}
		rightButton.x, rightButton.y=exitX-32, 384
		buttons:insert(rightButton)
		rightButton:setFillColor(255, 255, 0)
		rightButton._view._over:setFillColor(255, 255, 0)


	logo=display.newImage("Bragging/Emblem.png")
	logo.x, logo.y=512, 384
	logo.alpha=0
	transition.to(logo, {alpha=1, time=500})
	transition.to(logo, {xScale=0.5, yScale=0.5, x=exitX-(logo.width/4), y=display.contentHeight-(logo.height/4), delay=1000, time=500, transition=easing.inOutQuad, onComplete=function() 
			timer.performWithDelay(500, function()
					samples[curSample].initiate()
					leftButton:setEnabled(true)
					rightButton:setEnabled(true)
				end)
		end
	})

	function toFront()
		texts:toFront()
		logo:toFront()
	end
	Runtime:addEventListener("enterFrame", toFront)
end

initiate()