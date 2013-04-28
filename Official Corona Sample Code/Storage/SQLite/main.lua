--
-- Project: SQLite demo
--
-- Date: August 24, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Shows how to create and read a SQLite database
--
-- Demonstrates: database create and read APIs
--
-- File dependencies: none
--
-- Target devices: Simulator (results onscreen and in Console) and on Device
--
-- Limitations: none
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Add onscreen text
local label1 = display.newText( "SQLite demo", 20, 30, native.systemFontBold, 20 )
label1:setTextColor( 190, 190, 255 )
local label2 = display.newText( "Creates or opens a local database", 20, 50, native.systemFont, 14 )
label2:setTextColor( 190, 190, 255 )
local label3 = display.newText( "(Data is shown below)", 20, 90, native.systemFont, 14 )
label3:setTextColor( 255, 255, 190 )

--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end
 
--Setup the table if it doesn't exist
local tablesetup = [[CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, content, content2);]]
print(tablesetup)
db:exec( tablesetup )
 
--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them
local testvalue = {}
testvalue[1] = 'Hello'
testvalue[2] = 'World'
testvalue[3] = 'Lua'
local tablefill =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[2]..[['); ]]
local tablefill2 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[2]..[[',']]..testvalue[1]..[['); ]]
local tablefill3 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[3]..[['); ]]
db:exec( tablefill )
db:exec( tablefill2 )
db:exec( tablefill3 )
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents
for row in db:nrows("SELECT * FROM test") do
  local text = row.content.." "..row.content2
  local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
  t:setTextColor(255,0,255)
end
 
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )