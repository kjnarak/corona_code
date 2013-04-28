-- 
-- Abstract: In-App Purchase Sample Project
-- 
-- This project demonstrates Corona In-App Purchase support.
-- The code attempts to connect to a store such as iTunes or Google's Android Marketplace
-- to retrieve valid product information and handle transactions.
--
-- IMPORTANT:  Parts of this code can be exercised in Corona Simulator for 
-- testing, but Corona Simulator cannot do in-app purchases.
--
-- To test with the iTunes store, you must:
--   1. Set up your own In App Purchase products in iTunes Connect.
--   2. Modify the code below to suit your products.
--   3. Set up a test user account and provisioning for your iOS test device.
--   3. Build and deploy on device.
--
-- Version: 1.1
--
-- Updated: March 1, 2012
-- 
-- Update History:
--  1.0    Initial version supporting iTunes in-app purchasing only.
--  1.1    Adding Google's Android Marketplace support.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- You must call this first in order to use the "store" API.
local store = require("store")   -- Available in Corona build #261 or later

-- This is needed for the UI controls.
local widget = require("widget")

-- Determing if this app is running within the Corona Simulator.
local isSimulator = "simulator" == system.getInfo("environment")

-- Hide the status bar.
display.setStatusBar( display.HiddenStatusBar )

-- Unbuffer console output for debugging 
io.output():setvbuf('no')  -- Remove me for production code

-- Function used to display a splashscreen.
local titlecard
function showTitle()
	titlecard = display.newImage( "titlecard.png", true )
	titlecard.x = display.contentCenterX
	titlecard.y = display.contentCenterY
end

local bg
local validProducts, invalidProducts = {}, {}
local descriptionArea

-------------------------------------------------------------------------------
--  Product IDs should match the In App Purchase products set up in iTunes Connect.
--  We cannot get them from the iTunes store so here they are hard coded;
--  your app could obtain them dynamically from your server.
-------------------------------------------------------------------------------

-- To be assigned a product list from one of the arrays below after we've connected to a store.
-- Will be nil if no store is supported on this system/device.
local currentProductList = nil

-- Product IDs for the "apple" app store.
local appleProductList =
{
	-- These Product IDs must already be set up in your store
	-- We'll use this list to retrieve prices etc. for each item
	-- Note, this simple test only has room for about 4 items, please adjust accordingly
	-- The iTunes store will not validate bad Product IDs 
	"com.anscamobile.NewExampleInAppPurchase.ConsumableTier1",
	"com.anscamobile.NewExampleInAppPurchase.NonConsumableTier1",
	"com.anscamobile.NewExampleInAppPurchase.SubscriptionTier1",
}

-- Product IDs for the "google" Android Marketplace store.
local googleProductList =
{
	-- These product IDs are used for testing and is supported by all Android apps.
	-- Purchasing these products will not bill your account.
	"android.test.purchased",			-- Marketplace will always successfully purchase this product ID.
	"android.test.canceled",			-- Marketplace will always cancel a purchase of this product ID.
	"android.test.item_unavailable",	-- Marketplace will always indicate this product ID as unavailable.
}

-------------------------------------------------------------------------------
-- Displays a warning indicating that store access is not available,
-- meaning that Corona does not support in-app purchases on this system/device.
-- To be called when the store.isActive property returns false.
-------------------------------------------------------------------------------
function showStoreNotAvailableWarning()
	if isSimulator then
		native.showAlert("Notice", "In-app purchases is not supported by the Corona Simulator.", { "OK" } )
	else
		native.showAlert("Notice", "In-app purchases is not supported on this device.", { "OK" } )
	end
end

-------------------------------------------------------------------------------
-- Process and display product information obtained from store.
-- Constructs a button for each item
-------------------------------------------------------------------------------
function addProductFields()

	-- Utility function to build a buy button.
	function newBuyButton (index)
		--	Handler for buy button 
		local buttonDefault = "buttonBuy.png"
		local buttonOver = "buttonBuyDown.png"
		local buyThis = function ( productId )
			-- Check if it is possible to purchase the item, then attempt to buy it.
			if store.isActive == false then
				showStoreNotAvailableWarning()
			elseif store.canMakePurchases == false then
				native.showAlert("Store purchases are not available, please try again later", {"OK"})
			elseif productId then
				print("Ka-ching! Purchasing " .. tostring(productId))
				store.purchase( {productId} )
			end
		end
		function buyThis_closure ( index )            
			-- Closure wrapper for buyThis() to remember which button
			return function ( event )
				buyThis(validProducts[index].productIdentifier)
				return true
			end        
		end
		local hideDescription = function ( )
			descriptionArea.text = "Select a product..."
		end
		local describeThis = function ( description )
			-- Display product description for testing
			print ("About this product:  " ..description)
			-- TODO wrap if necessary
			descriptionArea.text = description
			timer.performWithDelay( 2000, hideDescription)  
		end
		function describeThis_closure ( index )            
			-- Closure wrapper for describeThis() to remember which button
			return function ( event )
					describeThis (validProducts[index].description)		 
				return true
			end        
		end
		local label = validProducts[index].title
		if validProducts[index].price then
			-- Product price is known. In this case, display the price in the button.
			label = label .. "  " string.format("%.2f", validProducts[index].price)
		else
			-- Product price is not known. In this case we expect a localized price to be
			-- displayed via the in-app purchase system's own UI.
		end
		
		local myButton = widget.newButton
		{ 
			defaultFile = buttonDefault, 
			overFile = buttonOver,
			label = "", 
			labelColor = 
			{ 
				default = { 2, 0, 127 }, 
				over = { 2, 0, 127 } 
			}, 
			font = "Marker Felt", 
			fontSize = 14, 
			emboss = false,
			onPress = describeThis_closure (index),
			onRelease = buyThis_closure (index),
		}
		myButton:setReferencePoint(display.CenterLeftReferencePoint)
		myButton:setLabel(label)
		return myButton
	end

	-- Utility to build a restore button
	function newRestoreButton ()
		local buttonDefault = "buttonRestore.png"
		local buttonOver = "buttonRestoreDown.png"
		local restore = function ( product )
			-- Request the store to restore all previously purchased products.
			if store.isActive then
				print ("Restoring " )
				store.restore()
			else
				showStoreNotAvailableWarning()
			end
		end
		local hideDescription = function ( )
			descriptionArea.text = "Select a product..."
		end
		local describeThis = function ()
			-- Display info in description area
			print ("Test restore feature")
			descriptionArea.text = "Test restore feature"
			timer.performWithDelay( 2000, hideDescription)  
		end
			local label = "Test restore"
			local myButton = widget.newButton
			{ 
				defaultFile = buttonDefault, 
				overFile = buttonOver,
				label = "", 
				labelColor = 
				{ 
					default = { 2, 0, 127 }, 
					over = { 2, 0, 127 } 
				}, 
				font = "Marker Felt", 
				fontSize = 14, 
				emboss = false,
				onPress = describeThis,
				onRelease = restore,
			}
			myButton:setReferencePoint(display.CenterLeftReferencePoint)
			myButton:setLabel(label) 
			return myButton
	end
	
	-- Show store UI
	titlecard:removeSelf()
	bg = display.newImage( "storebg.png", true )
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	
	-- Display product purchasing options
	print ("Loading product list")
	if (not validProducts) or (#validProducts <= 0) then
		-- There are no products to purchase. This indicates that in-app purchasing is not supported.
		local noProductsLabel = display.newText(
					"Sorry!\nIn-App purchases is not supported on this device.",
					display.contentWidth / 2, display.contentHeight / 3,
					display.contentWidth / 2, 0,
					native.systemFont, 16)
		noProductsLabel:setTextColor(0, 0, 0)
		showStoreNotAvailableWarning()
	else
		-- Products for purchasing have been received. Create options to purchase them below.
		print("Product list loaded")
		print("Country: " .. tostring(system.getPreference("locale", "country")))
		
		-- Set up native text box for displaying current transaction status.
		descriptionArea = native.newTextBox(
					10, 0.7 * display.contentHeight,
					display.contentCenterX - 20, display.contentCenterY - 10)
		descriptionArea.text = "Select a product..."
		descriptionArea:setTextColor (2, 0, 127)
		descriptionArea.size = 18
		descriptionArea.hasBackground = false
		local buttonSpacing = 5
		print( "Found " .. #validProducts .. " valid items ")
		
		-- display the valid products in buttons 
		for i=1, #validProducts do            
			-- Debug:  print out product info 
			print("Item " .. tostring(i) .. ": " .. tostring(validProducts[i].productIdentifier)
							.. " (" .. tostring(validProducts[i].price) .. ")")
			print(validProducts[i].title .. ",  ".. validProducts[i].description)

			-- create and position product button
			local myButton = newBuyButton(i)
			myButton.x = display.contentWidth - myButton.width - buttonSpacing
			myButton.y = i * buttonSpacing + (2 * i - 1) * myButton.height / 2
		end
		
		-- Create and position Restore button.
		if store.isActive or isSimulator then
			local myButton = newRestoreButton()
			myButton.x = display.contentWidth - myButton.width - buttonSpacing
			myButton.y = display.contentHeight - myButton.height / 2 - buttonSpacing
		end
        
		-- Debug: Display invalid prodcut info loaded from the store.
		--        You would not normally do this in a relese build of your app.
		for i=1, #invalidProducts do
			native.showAlert( "Item " .. tostring(invalidProducts[i]) .. " is invalid.", {"OK"} )
			print("Item " .. tostring(invalidProducts[i]) .. " is invalid.")
		end
	end
end

-------------------------------------------------------------------------------
-- Handler to receive product information 
-- This callback is set up by store.loadProducts()
-------------------------------------------------------------------------------
function loadProductsCallback( event )
	-- Debug info for testing
	print("In loadProductsCallback()")
	print("event, event.name", event, event.name)
	print(event.products)
	print("#event.products", #event.products)
	io.flush()  -- remove for production

	-- save for later use
	validProducts = event.products
	invalidProducts = event.invalidProducts    
	addProductFields()
end

-------------------------------------------------------------------------------
-- Handler for all store transactions
-- This callback is set up by store.init()
-------------------------------------------------------------------------------
function transactionCallback( event )
	local infoString

	-- Log transaction info.
	print("transactionCallback: Received event " .. tostring(event.name))
	print("state: " .. tostring(event.transaction.state))
	print("errorType: " .. tostring(event.transaction.errorType))
	print("errorString: " .. tostring(event.transaction.errorString))

	if event.transaction.state == "purchased" then
		infoString = "Transaction successful!"
		print(infoString)
		descriptionArea.text = infoString
		print("receipt: " .. tostring(event.transaction.receipt))
		print("signature: " .. tostring(event.transaction.signature))
		
	elseif  event.transaction.state == "restored" then
		-- Reminder: your app must store this information somewhere
		-- Here we just display some of it
		infoString = "Restoring transaction:" ..
							"\n   Original ID: " .. tostring(event.transaction.originalTransactionIdentifier) ..
							"\n   Original date: " .. tostring(event.transaction.originalDate)
		print(infoString)
		descriptionArea.text = infoString
		print("productIdentifier: " .. tostring(event.transaction.productIdentifier))
		print("receipt: " .. tostring(event.transaction.receipt))
		print("transactionIdentifier: " .. tostring(event.transaction.transactionIdentifier))
		print("date: " .. tostring(event.transaction.date))
		print("originalReceipt: " .. tostring(event.transaction.originalReceipt))

	elseif  event.transaction.state == "refunded" then
		-- Refunds notifications is only supported by the Google Android Marketplace.
		-- Apple's app store does not support this.
		-- This is your opportunity to remove the refunded feature/product if you want.
		infoString = "A previously purchased product was refunded by the store."
		print(infoString .. "\nFor product ID = " .. tostring(event.transaction.productIdentifier))
		descriptionArea.text = infoString

	elseif event.transaction.state == "cancelled" then
		infoString = "Transaction cancelled by user."
		print(infoString)
		descriptionArea.text = infoString

	elseif event.transaction.state == "failed" then        
		infoString = "Transaction failed, type: " .. 
			tostring(event.transaction.errorType) .. " " .. tostring(event.transaction.errorString)
		print(infoString)
		descriptionArea.text = infoString
		
	else
		infoString = "Unknown event"
		print(infoString)
		descriptionArea.text = infoString
	end

	-- Tell the store we are done with the transaction.
	-- If you are providing downloadable content, do not call this until
	-- the download has completed.
	store.finishTransaction( event.transaction )
end

-------------------------------------------------------------------------------
-- Displays in-app purchase options.
-- Loads product information from store if possible. 
-------------------------------------------------------------------------------
function setupMyStore(event)
	-- Usually you would only list products for purchase if the device supports in-app purchases.
	-- But for the sake of testing the user interface, you might want to list products if running on the simulator too.
	if store.isActive or isSimulator then
		if store.canLoadProducts then
			-- Property "canLoadProducts" indicates that localized product information such as name and price
			-- can be retrieved from the store (such as iTunes). Fetch all product info here asynchronously.
			store.loadProducts( currentProductList, loadProductsCallback )
			print ("After store.loadProducts, waiting for callback")
		else
			-- Unable to retrieve products from the store because:
			-- 1) The store does not support apps fetching products, such as Google's Android Marketplace.
			-- 2) No store was loaded, in which case we could load dummy items or display no items to purchase
			validProducts[1] = {}
			validProducts[1].title = "Lemonade refill"
			validProducts[1].description = "A wonderful dummy product for testing"
			if currentProductList then
				validProducts[1].productIdentifier = currentProductList[1]
			end
			validProducts[2] = {}
			validProducts[2].title = "Drinking glass"
			validProducts[2].description = "Makes lemonade easier to drink."
			if currentProductList then
				validProducts[2].productIdentifier = currentProductList[2]
			end
			validProducts[3] = {}
			validProducts[3].title = "Daily dose"
			validProducts[3].description = "Made fresh daily!"
			if currentProductList then
				validProducts[3].productIdentifier = currentProductList[3]
			end
			addProductFields()
		end
	else
		-- Don't load any products. In-app purchases is not supported on this device.
		addProductFields()
	end
end


-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

-- Show title card
showTitle()

-- Connect to store at startup, if available.
if store.availableStores.apple then
	currentProductList = appleProductList
	store.init("apple", transactionCallback)
	print("Using Apple's in-app purchase system.")
	
elseif store.availableStores.google then
	currentProductList = googleProductList
	store.init("google", transactionCallback)
	print("Using Google's Android In-App Billing system.")
	
else
	print("In-app purchases is not supported on this system/device.")
end

-- Hide title card, run store
timer.performWithDelay (1000, setupMyStore)

collectgarbage()

