--[[
Tutorial by Caleb Place on line drawing.
 
For those of you who want to know, here's how it works:
It stores two variables, bx and by, as 0, 0. When you touch the screen (or click), it changes the variables to the event.x and event.y. Now bx=event.x and by=event.y. Then, when you move your touch (or click), it draws a line from the bx and by to the event.x and event.y. Then it resets bx and by to the current position, and starts all over again. That's the way you draw a line! Now, of course, moving the touch (or click) too fast makes it a  =bit choppy, so you could add some algorithm to smooth it, but that's the basic way to draw it. 
 
There are two classes: Permanent Drawing and Temporary Drawing.
 
In Permanent Drawing, simply un-comment or comment the effects for color, width, alpha, and removal and test it out! Please Note: If you go too far to the sides or top with an alpha effect, it can pass over the limit, and you'll get an error saying something like this:
 
WARNING: Attempt to set object.alpha to 1.471 which is outside valid range. It will be clamped to the range [0,1]
 
Just don't pay attention. That's because I did not safeguard against that.
 
 
In Temporary Drawing, lines remove themselves automatically. Choose a style and start drawing.
 
To switch, just un-comment the listeners at the bottom that you want to use and comment the ones you don't.
 
--]]
 
display.setStatusBar( display.HiddenStatusBar ) -- Hide the status bar
 
local bx, by=0, 0 -- Create our variables for drawing the line
local lines={}
 
---------------------------------
---------------------------------
--CLASS #1: Permanent Drawing
---------------------------------
---------------------------------
 
local p=1
local e=3
local counter=1
 
local tanShade=1000 -- For the camouflage line effect
 
--For the reference:
        --math.abs returns a positive value of whatever you're trying to get. It's just absolute. So it's perfect for this, as who's ever heard of a line with a width of -3?
 
local function drawALine(event) -- Main function
        if "began"==event.phase then
        bx, by=event.x, event.y -- Store the values, if you don't it starts from 0, 0
        
        elseif "moved"==event.phase then
        
        lines[p]=display.newLine(bx, by, event.x, event.y) -- Make a normal line
        --lines[p]=display.newLine(bx+math.random(15), by+math.random(15), event.x+math.random(15), event.y+math.random(15)) -- Or a jittery line
        
        --Width
        
        --lines[p].width=math.random(1, 30) -- Makes for an interesting "backbone" effect
        lines[p].width=16 -- Just a boring old set width
        --lines[p].width=-3 -- I've heard of a line with a width of -3!
        --lines[p].width=math.abs(event.y/20) -- 3D-ish horizon look
        
        
        --Alpha
        
        lines[p].alpha=1 -- Another boring one
        --lines[p].alpha=0.5 -- Half strength line
        --lines[p].alpha=math.abs((event.y-(1000-event.y))/1000) -- Darker area near the center
        --lines[p].alpha=math.abs(event.y/1000) -- Foggy day
        --lines[p].alpha=math.abs(event.x/1000) -- Foggy day...to the side?
        --lines[p].alpha=(math.random(100, 1000))/1000 -- Random
        
        
        --Color
        
        --Flat color
        --lines[p]:setColor(255,255,255) -- White
        --lines[p]:setColor(255,255,0) -- Yellow
        --lines[p]:setColor(255,0,0) -- Red
        --lines[p]:setColor(0,255,0) -- Green
        --lines[p]:setColor(0,0,255) -- Blue
        --lines[p]:setColor(255,0,255) -- Purple
        
        --Interesting color effects
        --lines[p]:setColor(math.random(255)) -- Grayscale
        lines[p]:setColor(math.random(255), math.random(255), math.random(255)) -- Rainbow
        --lines[p]:setColor(event.x/5, event.x-20/5, event.x+20/5) -- Really odd effect...
        --lines[p]:setColor(event.x-event.y, 0, event.x-event.y) -- Pretty cool, works best with slow movement
        --lines[p]:setColor(tanShade/5, tanShade/10, tanShade/15); tanShade=math.random(500, 1500) -- Camouflage
        --lines[p]:setColor(p*e, e*e, e/p) -- Hm...
        
        
        --Optional effect #1
        --[[
        for i=counter, p do
                if lines[i] then
                        lines[i].width=lines[i].width+1
                end
        end
        
        if p>100 then
                counter=counter+1
        end
        --]]
        
        
        --Optional effect #2
        --[[
        for i=counter, p do
                if lines[i] then
                        if lines[i].width-1>5 then
                                lines[i].width=lines[i].width-1
                        end
                end
        end
        
        if p>100 then
                counter=counter+1
        end
        --]]
        
        
        --Optional effect #3
        --[[
        for i=counter, p do
                if lines[i] then
                        lines[i].x=lines[i].x+math.random(6)
                end
        end
        
        if p>100 then
                counter=counter+1
        end
        --]]
 
        bx, by=event.x, event.y -- Reset the bx and by, comment out for a "starburst" effect
        p=p+1
        e=e+1
        
        elseif "ended"==phase then
                
        end     
end
 
local removedLine=1
 
local function clearLines(event) -- Called with a double tap
        if event.numTaps==2 then
        
        --Technique #1: Instant removal
        ---[[
        for i=1, p-1 do
                lines[i]:removeSelf()
                lines[i]=nil
        end
        p=1
        --]]
        
        --Technique #2: Fade out
        --[[
        for i=1, p-1 do 
                transition.to(lines[i], {alpha=0, time=100, onComplete=function() lines[i]:removeSelf() lines[i]=nil end}) 
        end
        p=1
        --]]
        
        --Technique #3: Draw backwards - my favorite removal effect
        --[[
        local function removeNextLine()
                display.remove(lines[removedLine])
                lines[removedLine]=nil
                removedLine=removedLine+1
                if removedLine==p then
                        removedLine=1
                end
        end
        timer.performWithDelay(1, removeNextLine, p)
        p=1
        --]]
        
        end
end
 
---------------------------------
---------------------------------
--CLASS #2: Temporary Drawing
---------------------------------
---------------------------------
 
-- Looks like the fruit ninja visual effect
 
local function fruitNinja(event)
        if "began"==event.phase then
                bx, by=event.x, event.y
        elseif "moved"==event.phase then
                for i=#lines+1, #lines+1 do
                        lines[i]=display.newLine(bx, by, event.x, event.y)
                        lines[i]:setColor(100, 100, 255)
                        lines[i].width=18
                        local me=lines[i]
                lines[i].transition=transition.to(me, {alpha=0, width=1,  time=300}) -- The key transition
                bx, by=event.x, event.y
                timer.performWithDelay(300, function() me:removeSelf() me=nil end) -- Don't forget to destroy and nil the lines!
          end
  elseif "ended"==event.phase then
        
        end
end
 
 
-- Deletes previous lines as you draw
 
local function deleteBehind(event)
        if "began"==event.phase then
                bx, by=event.x, event.y
        elseif "moved"==event.phase then
                for i=#lines+1, #lines+1 do
                        lines[i]=display.newLine(bx, by, event.x, event.y)
                        lines[i]:setColor(255, 255, 0)
                        lines[i].width=14
                        local me=lines[i]
                bx, by=event.x, event.y
                timer.performWithDelay(300, function() me:removeSelf() me=nil end) -- Instead of the transition, just delete it
          end
  elseif "ended"==event.phase then
        
        end
end
 
 
--Deletes only when you move your finger
 
local r=1
local l=1
 
local function deleteOnTouch(event)
        if "began"==event.phase then
                bx, by=event.x, event.y
        elseif "moved"==event.phase then
                for i=l, l do
                        lines[i]=display.newLine(bx, by, event.x, event.y)
                        lines[i]:setColor(math.random(100,255))
                        lines[i].width=14
                        local me=lines[i]
                bx, by=event.x, event.y
                --timer.performWithDelay(300, function() me:removeSelf() me=nil end) -- Instead of the transition, just delete it
                l=l+1
                if i>50 then
                        display.remove(lines[r])
                        lines[r]=nil
                        r=r+1
                end
          end
          
  elseif "ended"==event.phase then
        
        end
end
 
 
--Add the permanent line listeners
 
--Runtime:addEventListener("tap", clearLines)
--Runtime:addEventListener("touch", drawALine)
 
 
--Or the temporary line listeners
 
Runtime:addEventListener("touch", fruitNinja)
Runtime:addEventListener("touch", deleteBehind)
Runtime:addEventListener("touch", deleteOnTouch)
