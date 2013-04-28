-----------------------------------------------------------------------------------------
--
-- stackbuster.lua
-- created by Raphael Salgado as BeyondtheTech
-- version 1.0 - November 19, 2011
-- version 1.1 - March 6, 2013
--
-----------------------------------------------------------------------------------------
 
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- initialize variables
local grid = {}
local ball = {}
local ready = false
local selection = 1
local score = 0
local worth = 0
local moves = 0
local total = 0
local i, j, k, m, highlighted, compress_completed, highlight_completed, game_over
local colors = {
        { 0, 0, 0, "black" }, { 255, 0, 0, "red" }, { 0, 255, 0, "green" },
        { 0, 0, 255, "blue" }, { 255, 255, 0, "yellow" } }
local grid_touch
local i2 = 0
local j2 = 0
local score_text = display.newText("", 160, 0, native.systemFont, 16)
local worth_text = display.newText("", 160, 400, native.systemFont, 16)
 
 
-- update score
local function update_score()
        score_text.text = "Score: " .. score
end
 
 
-- return shade value
local function shade( r, g, b )
        local g = graphics.newGradient(
                { r, g, b },
                { r * 0.25, g * 0.25, b * 0.25 },
                "down" )
        return g
end
 
-- create the grid and ball arrays
local function create_grid()
        for i = 0, 11 do
                grid[ i ] = {}
                ball[ i ] = {}
                for j = 0, 11 do
                        if i == 0 or i == 11 or j == 0 or j == 11 then
                                m = 0
                        else
                                m = 1
                        end
                        grid[ i ][ j ] = display.newRect( 0, 0, 29, 29 )
                        grid[ i ][ j ].x = j * 30 - 5
                        grid[ i ][ j ].y = i * 30 + 70
                        grid[ i ][ j ].alpha = m * 0.15
                        grid[ i ][ j ].gridX = j
                        grid[ i ][ j ].gridY = i                        
                        grid[ i ][ j ]:addEventListener( "touch", grid_touch )
                        ball[ i ][ j ] = display.newRect( 0, 0, 19, 19 )                        
                        ball[ i ][ j ].x = j * 30 - 5
                        ball[ i ][ j ].y = i * 30 + 70
                        ball[ i ][ j ].alpha = m
                end
        end
end
 
 
-- fill grid
local function fill_grid()
        for i = 1, 10 do
                for j = 1, 10 do
                        grid[ i ][ j ].alpha = 0.15
                        if math.random( 100 ) > 75 then
                                k = 0
                        else
                                k = math.random( 1, 4 )
                        end
                        local rgb = colors[ k  + 1 ]
                        ball[ i ][ j ]:setFillColor( shade( rgb[ 1 ], rgb[ 2 ], rgb[ 3 ] ) )
                        ball[ i ][ j ].value = k
                end
        end
end                     
                        
 
-- compressing action
local function compressing_action()
        compress_completed = true
        for i = 9, 1, -1 do
                for j = 1, 10 do
                        if ball[ i ][ j ].value > 0 and ball[ i + 1 ][ j ].value == 0 then
                                compress_completed = false
                                k = ball[ i ][ j ].value
                                ball[ i ][ j ].value = 0
                                ball[ i + 1 ][ j ].value = k
                                local rgb = colors[ k + 1 ]
                                local tempball = display.newRect( 0, 0, 19, 19 )
                                tempball:setFillColor( shade( rgb[ 1 ], rgb[ 2 ], rgb[ 3 ] ) )
                                tempball.x = j * 30 - 5
                                tempball.y = i * 30 + 70
                                local function remove_tempball()
                                        tempball:removeSelf()
                                        tempball = nil
                                end
                                transition.to( tempball, {
                                        time = 100,
                                        x = ball[ i + 1 ][ j ].x,
                                        y = ball[ i + 1 ][ j ].y,
                                        alpha = 0, onComplete = remove_tempball } )
                                ball[ i ][ j ]:setFillColor( 0, 0, 0 )
                                ball[ i + 1 ][ j ]:setFillColor( shade( rgb[ 1 ], rgb[ 2 ], rgb[ 3 ] ) )
                                transition.to( ball[ i + 1 ][ j ], { time = 100, alpha = 1 } )                                  
                        end     
                end
        end
 
end
 
 
-- compress grid
local function compress_grid()
        compress_completed = false
        while compress_completed == false do
                compressing_action()
        end
        
        -- compress columns
        for m = 1, 10 do
                for j = 1, 9 do
                        local sum = 0
                        for i = 1, 10 do
                                if ball[ i ][ j ].value > 0 then sum = sum + 1 end
                        end
                        if sum == 0 then
                                for i = 1, 10 do
                                        k = ball[ i ][ j + 1 ].value
                                        local rgb = colors[ k + 1 ]
                                        ball[ i ][ j ].value = k
                                        ball[ i ][ j ]:setFillColor( shade( rgb[ 1 ], rgb[ 2 ], rgb[ 3 ] ) )
                                        ball[ i ][ j + 1 ].value = 0
                                        ball[ i ][ j + 1 ]:setFillColor( 0, 0, 0 )
                                end
                        end
                end
        end
end
 
 
-- check if there are no more moves
local function check_game_over()
        game_over = true
        for i = 1, 10 do
                for j = 1, 10 do
                        k = ball[ i ][ j ].value
                        if k > 0 and ( k == ball[ i + 1 ][ j ].value or k == ball[ i ][ j + 1 ].value ) then
                                game_over = false
                        end
                end
        end
end
 
 
-- clear highlights
local function clear_highlight()
        local i0, j0
        for i0 = 1, 10 do
                for j0 = 1, 10 do                       
                        grid[ i0 ][ j0 ].alpha = 0.15
                end
        end
end
 
 
-- highlight loop
local function highlight_loop( k )
        highlight_completed = true
        local i0, j0
        local function increase_worth()
                highlighted = highlighted + 1
                worth = worth + ( highlighted * 15 )
                highlight_completed = false
        end
        for i0 = 1, 10 do
                for j0 = 1, 10 do                       
                        if grid[ i0 ][ j0 ].alpha == 1 then
                                if grid[ i0 - 1 ][ j0 ].alpha ~= 1 and ball[ i0 - 1 ][ j0 ].value == k then
                                        grid[ i0 - 1 ][ j0 ].alpha = 1
                                        increase_worth()
                                end
                                if grid[ i0 ][ j0 - 1 ].alpha ~= 1 and ball[ i0 ][ j0 - 1 ].value == k then
                                        grid[ i0 ][ j0 - 1 ].alpha = 1
                                        increase_worth()
                                end
                                if grid[ i0 + 1 ][ j0 ].alpha ~= 1 and ball[ i0 + 1 ][ j0 ].value == k then 
                                        grid[ i0 + 1 ][ j0 ].alpha = 1
                                        increase_worth()
                                end
                                if grid[ i0 ][ j0 + 1 ].alpha ~= 1 and ball[ i0 ][ j0 + 1 ].value == k then
                                        grid[ i0 ][ j0 + 1 ].alpha = 1
                                        increase_worth()
                                end
                        end
                end
        end     
end
 
 
-- highlight grid
local function highlight_grid( i, j, k )
        highlight_completed = false     
        highlighted = 1                                 
        grid[ i ][ j ].alpha = 1
        worth = 15
        while highlight_completed == false do
                highlight_loop( k )
        end
        worth_text.text = "Value: " .. worth
end
 
 
-- bust highlighted
local function bust_highlighted()
        local i0, j0
        for i0 = 1, 10 do
                for j0 = 1, 10 do                       
                        if grid[ i0 ][ j0 ].alpha == 1 then
                                grid[ i0 ][ j0 ].alpha = 0.15
                                k = ball[ i0 ][ j0 ].value
                                ball[ i0 ][ j0 ].value = 0
                                ball[ i0 ][ j0 ]:setFillColor( 0, 0, 0 )
                                local rgb = colors[ k + 1 ]
                                local tempball = display.newRect( 0, 0, 19, 19 )
                                tempball:setFillColor( shade( rgb[ 1 ], rgb[ 2 ], rgb[ 3 ] ) )
                                tempball.x = j0 * 30 - 5
                                tempball.y = i0 * 30 + 70
                                local function remove_tempball()
                                        tempball:removeSelf()
                                        tempball = nil
                                end
                                transition.to( tempball, {
                                        time = 1000,
                                        rotation = math.random(360),
                                        x = math.random(320),
                                        y = math.random(480),
                                        alpha = 0, onComplete = remove_tempball } )                             
                        end
                end
        end
        score = score + worth
        update_score()
end
 
        
-- touch event handler
function grid_touch( event )
        if not ready then
                print( "not ready to accept touch event" )
                return
        else
                if event.phase == "ended" then
                        worth_text.text = ""
                        ready = false
                        i = event.target.gridY
                        j = event.target.gridX
                        k = ball[ i ][ j ].value
                        if k > 0 then
                                -- determine if first or second touch
                                if selection == 2 then
                                        if i == i2 and j == j2 then
                                                print( j .. ", " .. i .. " confirmed!" )
                                                bust_highlighted()
                                                compress_grid()
                                                check_game_over()
                                                if game_over then
                                                        worth_text.text = "Game over! Shake device to try again."
                                                else
                                                        ready = 1
                                                end
                                                selection = 3
                                        else
                                                i2 = 0
                                                j2 = 0
                                                selection = 1
                                        end
                                end
                                if selection == 1 then
                                        clear_highlight()
                                        if k == ball[ i - 1 ][ j ].value or k == ball[ i + 1 ][ j ].value or
                                           k == ball[ i ][ j - 1 ].value or k == ball[ i ][ j + 1 ].value then
                                                print( j .. ", " .. i .. " selected, color: " .. colors[ k + 1 ][ 4 ] )
                                                i2 = i
                                                j2 = j
                                                selection = 2
                                                highlight_grid( i, j, k )
                                        else
                                                print( j .. ", " .. i .. " has no nearby match" )
                                        end
                                        ready = true
                                end
                                if selection == 3 then selection = 1 end
                        else
                                print( j .. ", " .. i .. " is empty" )
                                clear_highlight()
                                ready = true
                        end
                end
        end
end
 
 
-- start the game
local function start_game()
        score = 0
        worth_text.text = ""
        update_score()
        compress_grid()
        check_game_over()
        ready = true
end
 
 
-- detect shake
local function accelerometer_detection ( event )
        if event.isShake and game_over then
                fill_grid()
                start_game()
        end
end
 
create_grid()
fill_grid()
start_game()
worth_text.text = "Welcome to Stackbuster!"
 
Runtime:addEventListener( "accelerometer", accelerometer_detection )