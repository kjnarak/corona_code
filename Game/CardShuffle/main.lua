-------------------------------------------------------------------------------------------------------
-------------------------------  *** CARD & TABLE DATA SHUFFLING ***  ---------------------------------
-------------------------------------------------------------------------------------------------------

-- By iNSERT.CODE - http://insertcode.co.uk
-- Version: 1.0
-- 
-- Code is MIT licensed

-- Playing card images are from deviantArt Member: Yozzo http://yozzo.deviantart.com/gallery/#/d13kqt7
-- and are NOT to be used commercially in your games or apps.
-- We used them here as a tutorial resource only.

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

-- Set Up Table To Hold Card Deck Data
local currentDeck = {}

-- Set Up Table To Hold Card Deck Data
local dealtCards = {}

-- Set Up Background Image
local bg = display.newImage("images/bg.jpg")


-- Set Up 3 Buttons: Shuffle, Deal, & Reset

local btn_Shuffle = display.newImage("images/btn_Shuffle.png")
btn_Shuffle.x = 470
btn_Shuffle.y = 70

local btn_Deal = display.newImage("images/btn_Deal.png")
btn_Deal.x = btn_Shuffle.x
btn_Deal.y = btn_Shuffle.y + 70

local btn_Reset = display.newImage("images/btn_Reset.png")
btn_Reset.x = btn_Shuffle.x
btn_Reset.y = btn_Shuffle.y + 140


-- Set Up 5 x Card Back Images & Position On The Dealer's Position For Use In Animation Later

local cardBacks = {}

for i = 1, 5 do
	
	cardBacks[i] = display.newImage("images/playingCards/back.png")
	cardBacks[i].x = 127
	cardBacks[i].y = 151
	
end	


-- Set Up An Empty String Variable To Display Deck Order Later

local deckOrder = display.newText( "", 280, 610, 640, 400, "Helvetica", 22 )


-- The All Important Shuffle Function Based On The Modern Method Of The Fisher-Yates Shuffle
-- http://en.wikipedia.org/wiki/Fisher-Yates_shuffle

-- NB: Slightly Edited From The Main Tutorial On The iNSERT.CODE Website To Control The Deck Order Text

local function shuffleDeck(t)
	
	deckOrder.text = ""
		
	local n = #t
	
	math.randomseed( os.time() )
	
	while n >= 2 do
  
		local k = math.random(n) 
		
		t[n], t[k] = t[k], t[n]
		
		n = n - 1
end
  
	for i = 1, #t do
  	
		print(i, t[i])
		
		deckOrder.text = deckOrder.text..currentDeck[i].." | "
  	
	end	
   
	return t
end


-- Function To Deal The Cards From The Deck

local function dealCards()
	
	btn_Deal.isVisible = false -- Hide The Deal Button
	
	btn_Shuffle.isVisible = false -- Hide The Shuffle Button
	
	
	-- Final Part Of The Dealing Animation (Psuedo-Rotating The 5 Dealt Card Images By Increasing The xScale)
		
	local function flipCardsStage2()
		
		local primeDelay = 200
		
		for i = 1, #dealtCards do
			
			transition.to( dealtCards[i], { xScale = 1, delay=( primeDelay * i ), time=100 }  )
			
		end
		
	end	
	
	
	-- Second Part Of The Dealing Animation (Psuedo-Rotating The 5 Back Card Images By Reducing The xScale)
	
	local function flipCardsStage1()
		
		local primeDelay = 200
		
		for i = 1, #cardBacks do
			
			transition.to( cardBacks[i], { xScale = 0.001, delay=( primeDelay * i ), time=100, onComplete = flipCardsStage2 }  )
			
		end
		
	end	
	
	
	-- First Part Of The Dealing Animation (Moving The 5 Back Card Images Into Position)
	
	local function moveCards()
	
		local primeDelay = 200
			
		for i = 1, #cardBacks do
			
			transition.to( cardBacks[i], { x = (193 * i) - 67, y = 430, delay=( primeDelay * i ), time=250, onComplete = flipCardsStage1 }  )
			
		end
	
	end

	moveCards()
	
	
	-- Read The 5 Cards To Be Dealt From The Table & Display The Appropriate Image
	-- Also Reduce The xScale Of The Card Images To Hide Them Ready To Be Animated
	
	for i = 1, 5 do
		
		dealtCards[i] = display.newImage("images/playingCards/"..currentDeck[i]..".png")
		dealtCards[i].xScale = 0.001
		dealtCards[i].x = (193 * i) - 67
		dealtCards[i].y = 430
		
	end	
	
end


-- Remove The Dealt Card Images From The Table Ready For Garbage Collection
-- Also position the 5 x Back Card Images Back To The Original Dealer Position & xScale

local function replaceDealtCards()
	
	if (dealtCards[1] ~= nil) then
				
		for i = 1, 5 do
			
			dealtCards[i]:removeSelf()
			
			dealtCards[i] = nil
						
		end	
			
	end
	
		
	for i = 1, 5 do

		cardBacks[i].xScale = 1 
		cardBacks[i].x = 127
		cardBacks[i].y = 151
		
	end	
		
end


-- Function To Reset The Deck Back To The Original Order
-- Also Called Upon Load To Initiate The Deck

local function resetDeck()
	
	deckOrder.text = ""
	
	if (btn_Shuffle.isVisible == false) or (btn_Deal.isVisible == false) then 
		
		btn_Shuffle.isVisible = true
		
		btn_Deal.isVisible = true
		
	end
		
	replaceDealtCards()
		
	local deckSize = 52
	
	local suits = {"C", "D", "H", "S"}
	
	local cardVals = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
		
	local counter = 0
	
	for i = 1, #suits do
		
		for j = 1, #cardVals do
			
			counter = counter + 1
			
			currentDeck[counter] = suits[i]..cardVals[j]
			
			deckOrder.text = deckOrder.text..currentDeck[counter].." | "
			
			print(counter, currentDeck[counter])
			
		end	
		
	end
	
end

resetDeck()
	

-- Event Listeners For The 3 User Buttons

btn_Shuffle:addEventListener ( "tap", function() btn_Shuffle.isVisible = false; shuffleDeck(currentDeck) end )

btn_Deal:addEventListener ( "tap", dealCards )

btn_Reset:addEventListener ( "tap", resetDeck )
