--
-- Project: SaveTable demo
--
-- Date: September 10, 2010
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Conveniently save an arbitrary Lua table to a textfile, then reload the data
--
-- Demonstrates: database create and read APIs
--
-- File dependencies: uses small "str.lua" library for convenient string "split" function
--
-- Target devices: Simulator (results in Console) and on Device
--
-- Limitations: none
--
-- Update History:
--
--  v1.1: display results on screen
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 
-- Note: uses string "split" function from str.lua. For reverse process, use table.concat( tablename, gluestring )
------------------------------------------------------------------------------------------------------------------

-- Some forward declarations
local main, saveData, loadData
local dataTable, dataTableNew


-- Load external libraries
local str = require("str")


-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )


---------------
-- Main program

function main()

	dataTable = {}

	-- some test data	
	dataTable.var1 = "hello"
	dataTable.var2 = "world"
	dataTable.numValue = 25
	dataTable.randomValue = math.random(100)
	
	-- show initial data	
	local y = 100
	local t = display.newText( "Data before saving: ", 25, y, nil, 16 );
	t:setTextColor( 255, 255, 136, 255 );
	for k,v in pairs( dataTable ) do
		y = y + 20
		local t = display.newText( k .. " = " .. v, 30, y, nil, 16 );
		t:setTextColor( 255, 255, 255 );
	end
		
	saveData()
	
	loadData()

	-- show retrieved data
	y = y + 30
	local t = display.newText( "Data after reloading: ", 25, y, nil, 16 );
	t:setTextColor( 255, 255, 136, 255 );
	for k,v in pairs( dataTableNew ) do
		y = y + 20
		local t = display.newText( k .. " = " .. v, 30, y, nil, 16 );
		t:setTextColor( 255, 255, 255 );
	end

end


----------------------
-- Save/load functions

function saveData()
	
	--local levelseq = table.concat( levelArray, "-" )

	file = io.open( filePath, "w" )
	
	for k,v in pairs( dataTable ) do
		file:write( k .. "=" .. v .. "," )
	end
	
	io.close( file )
end



function loadData()	
	local file = io.open( filePath, "r" )
	
	if file then

		-- Read file contents into a string
		local dataStr = file:read( "*a" )
		
		-- Break string into separate variables and construct new table from resulting data
		local datavars = str.split(dataStr, ",")
		
		dataTableNew = {}
		
		for i = 1, #datavars do
			-- split each name/value pair
			local onevalue = str.split(datavars[i], "=")
			dataTableNew[onevalue[1]] = onevalue[2]
		end
	
		io.close( file ) -- important!

		-- Note: all values arrive as strings; cast to numbers where numbers are expected
		dataTableNew["numValue"] = tonumber(dataTableNew["numValue"])
		dataTableNew["randomValue"] = tonumber(dataTableNew["randomValue"])	
	
	else
		print ("no file found")
	end
end

-- Add onscreen text
local label1 = display.newText( "SaveTable demo", 20, 30, native.systemFontBold, 20 )
label1:setTextColor( 190, 190, 255 )
local label2 = display.newText( "Saves and loads a Lua table", 20, 50, native.systemFont, 14 )
label2:setTextColor( 190, 190, 255 )

-- Start program execution
main()