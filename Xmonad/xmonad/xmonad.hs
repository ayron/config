import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import System.IO
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

myManageHook = composeAll
    [ isFullscreen                  --> doFullFloat 
    , className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , title     =? "Osmos"          --> doFloat
    , title     =? "Pong"           --> doFloat
    , title     =? "Float"          --> doFloat
    , title     =? "Hello World"    --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myLayout = (avoidStruts . smartBorders) (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2))) |||
    noBorders (fullscreenFull Full)

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/ayron/.xmobarrc"
    xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
        { manageHook = manageDocks <+> myManageHook
        , layoutHook = myLayout
        , logHook = dynamicLogWithPP $ xmobarPP
              { ppOutput = hPutStrLn xmproc
              , ppTitle = xmobarColor "green" "" . shorten 50
              , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
              }
        , modMask = mod4Mask
        , startupHook = setWMName "LG3D"
        , terminal = "urxvtc"
        } `additionalKeys`
        [ ((mod4Mask, xK_z), spawn "sudo pm-suspend")
        , ((mod4Mask, xK_s), spawn "setxkbmap us dvp")
        , ((mod4Mask, xK_o), spawn "setxkbmap us")
        , ((mod4Mask, xK_i), spawn "/usr/local/bin/projector2")
        , ((mod4Mask, xK_u), spawn "xrand --auto")
        ]

