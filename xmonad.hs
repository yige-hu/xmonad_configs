module Main (main) where

import XMonad
--import XMonad.Actions.Volume   -- cannot install xmonad-extras
import XMonad.Util.Dzen
import Data.Map    (fromList)
import Data.Monoid (mappend)
import XMonad.Prompt.XMonad
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Util.Run	(spawnPipe)
import System.IO	(hPutStrLn)

main :: IO ()
main = xmonad =<< yigeConfig

alert = dzenConfig centered . show . round
centered =
		onCurr (center 150 66)
	>=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
	>=> addArgs ["-fg", "#80c0ff"]
	>=> addArgs ["-bg", "#000040"]

yigeConfig = do
	xmobar <- spawnPipe "xmobar" -- REMOVE this line if you do not have xmobar installed!
	return $ defaultConfig
		{ workspaces	= ["home","var","dev","mail","web","doc"] ++
				map show [7 .. 9 :: Int]
		, logHook	= myDynLog xmobar -- REMOVE this line if you do not have xmobar installed!

		, keys =
		keys defaultConfig `mappend`
		\c -> fromList [
		-- Find multimedia keys with 'xev'

--		((0, 0x1008FF12), toggleMute >> return ()),
--		((0, 0x1008FF11), lowerVolume 4 >>= alert),
--		((0, 0x1008FF13), raiseVolume 4 >>= alert)

		-- mute button
		((0, 0x1008FF12), spawn "pulse-volume.sh toggle")
		-- volumeup button
--		,((0, 0x1008FF13), spawn "pulse-volume.sh increase" >> getVolume >>= alert)
		,((0, 0x1008FF13), spawn "pulse-volume.sh increase")
		-- volumedown button
--		,((0, 0x1008FF11), spawn "pulse-volume.sh decrease" >> getVolume >>= alert)
		,((0, 0x1008FF11), spawn "pulse-volume.sh decrease")

		,((0, 0x1008ffb2), spawn "amixer set Capture toggle")

		-- keybinding (Shift + Meta + L) is for locking the screen
		-- put "xscreensaver -no-splash &" in ~/.xsessionrc to run xscreensaver daemon when loading xserver
		, ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock; xset dpms force off")
		, ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
		, ((0, xK_Print), spawn "scrot")
		]
		}
	where

-- xmobar
	myDynLog	h = dynamicLogWithPP $ defaultPP
			{ ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
			, ppTitle   = xmobarColor "green"  "" . shorten 40
			, ppVisible = wrap "(" ")"
			, ppOutput  = hPutStrLn h
			}
