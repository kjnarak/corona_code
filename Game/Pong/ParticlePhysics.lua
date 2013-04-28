------------------------------------------------
--[[
Extremely simplified version of ParticlePhysics from CBEffects

http://developer.coronalabs.com/code/cbeffects
--]]
------------------------------------------------

local ParticlePhysics={}

local function createPhysics()
	local physics={}
	local p={}
		
	function physics.addBody(obj, bodyType, params)
		p=obj
		
		p.velX=0
		p.velY=0
				
		function obj:setLinearVelocity(x, y)
			obj.velX, obj.velY=x, y
		end
	end

	local function physicsLoop()
		p.x, p.y=p.x+p.velX, p.y+p.velY														
	end
	physics.enterFrame=physicsLoop
	
	function physics.start()
		Runtime:addEventListener("enterFrame", physics)
	end
	
	function physics.pause()
		Runtime:removeEventListener("enterFrame", physics)
	end
	
	return physics
end

ParticlePhysics.createPhysics=createPhysics

return ParticlePhysics