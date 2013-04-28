-- 
-- Abstract: ManyCrates sample project
-- Demonstrates simple body construction by generating 100 random physics objects
-- 
-- Version: 1.1 (revised for Alpha 2)
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

local physics = require("physics")
physics.start()

display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "bkg_cor.png" )

local grass = display.newImage("grass.png")
grass.x = 160; grass.y = 430

local grass2 = display.newImage("grass2.png") -- non-physical decorative overlay
grass2.x = 160; grass2.y = 440

physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )


function newCrate()	
	rand = math.random( 100 )

	if (rand < 60) then
		j = display.newImage("crate.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.9, friction=0.3, bounce=0.3} )
		
	elseif (rand < 80) then
		j = display.newImage("crateB.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=1.4, friction=0.3, bounce=0.2} )
		
	else
		j = display.newImage("crateC.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.3, friction=0.2, bounce=0.5} )
		
	end	
end

local dropCrates = timer.performWithDelay( 500, newCrate, 100 )