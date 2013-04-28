-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012
-- =============================================================
-- SSKCorona Loader 
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

-- ================================================================================
-- Load this module in main.cs to load all of the SSKCorona library with just one call.
-- ================================================================================



-- TheSSKCorona super object; Most libraries will be attached to this.
local ssk = {}
_G.ssk = ssk 

-- =============================================================
--	ROAMING GAMER CONTENTS (Produced or Modified by Ed M.)
-- =============================================================
-- ==
--    Early Loads: This stuff is used by subsequently loaded content
-- ==

ssk.debugprinter	= measureFunc("ssk.libs.debugPrint")				-- Level based debug printer
ssk.advanced		= measureFunc( "ssk.libs.advanced" )				-- Advanced stuff (dig at your own peril; comments and criticisms welcomed)

-- ==
--    Addons - add extra functionality to existing libs, module, and global space.
-- ==
measureFunc( "ssk.libs.global")
measureFunc( "ssk.libs.io")
measureFunc( "ssk.libs.math")
measureFunc( "ssk.libs.string")
measureFunc( "ssk.libs.table")


--EFM split below into game object libs and other?
-- ==
--    libs - 'libs' that produce one or more object types.
-- ==
ssk.buttons		= measureFunc( "ssk.libs.buttons" )					-- Buttons & Sliders Factory
ssk.labels		= measureFunc( "ssk.libs.labels" )					-- Labels Factory
ssk.points		= measureFunc( "ssk.libs.points" )					-- Simple Points Factory (table of points)
ssk.display		= measureFunc( "ssk.libs.display" )  			-- Prototyping Game Objects Factory
ssk.inputs		= measureFunc( "ssk.libs.inputs" )					-- Joysticks and Self-Centering Sliders Factory
ssk.huds		= measureFunc( "ssk.libs.huds" )						-- HUDs Factory
ssk.dbmgr		= measureFunc( "ssk.libs.dbmgr" )					-- (Rudimentary) DB Manager Factory
ssk.spritemgr	= measureFunc( "ssk.libs.imageSheets" )					-- (Easy) Sprite Factory

-- ==
--    libs
-- ==
ssk.behaviors	= measureFunc( "ssk.libs.behaviors" )					-- Behaviors Manager
ssk.bench		= measureFunc( "ssk.libs.benchmarking" )				-- Benchmarking Utilities
ssk.ccmgr		= measureFunc( "ssk.libs.collisionCalculator" )		-- Collision Calculator (EFM actually a factory now)
ssk.component	= measureFunc( "ssk.libs.components" )					-- Misc Game Components (Mechanics, etc.)
ssk.gem			= measureFunc( "ssk.libs.gem")							-- Game Event Manager
ssk.math2d		= measureFunc( "ssk.libs.math2d" )						-- 2D (vector) Math 
ssk.misc		= measureFunc( "ssk.libs.miscellaneous" )				-- Miscellaneous Utilities
ssk.sbc			= measureFunc( "ssk.libs.standardButtonCallbacks" )	-- Standard Button & Slider Callbacks
ssk.sounds		= measureFunc( "ssk.libs.sounds" )						-- Sounds Manager


-- ==
--    Utilities
-- ==
-- Easy Networking (Uses mydevelopersgames free AutoLan to do heavy lifting, but written by Ed M.)
ssk.networking	= measureFunc( "ssk.libs.networking" )  
ssk.networking:registerCallbacks()

-- =============================================================
--	EXTERNALLY PRODUCED (and accredited) CONTENT
-- =============================================================
--ssk.pnglib		= measureFunc( "ssk.external.pngLib.pngLib" )				-- Utility lib for extracting PNG image metrics

-- =============================================================
--	PAID CONTENT - Sorry, not included. 8(
-- I have left stubs here for stuff I think you should buy.
-- This is stuff that I believe will help you develop games better and/or faster.
-- =============================================================
-- ==
--    M.Y. Developers - Profiler (Paid; http://www.mydevelopersgames.com/site/)
-- ==
--profiler = measureFunc "paid.Profiler"
--profiler.startProfiler({time = 30000, delay = 1000, mode = 4})

