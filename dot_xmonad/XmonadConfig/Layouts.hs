module XmonadConfig.Layouts
  ( colorBlue,
    colorGreen,
    colorRed,
    colorGray,
    colorWhite,
    colorNormalbg,
    colorfg,
    borderwidth,
    mynormalBorderColor,
    myfocusedBorderColor,
    moveWD,
    resizeWD,
    myScratchpads,
    myLayoutHook,
    myManageHook,
  )
where

import Control.Monad
import XMonad
import XMonad.Core
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout
import XMonad.Layout.DragPane
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.TwoPane
import XMonad.StackSet qualified as W
import XMonad.Util.NamedScratchpad

-- Color Setting
colorBlue = "#868bae"

colorGreen = "#00d700"

colorRed = "#ff005f"

colorGray = "#666666"

colorWhite = "#bdbdbd"

colorNormalbg = "#1c1c1c"

colorfg = "#a8b6b8"

-- Border width
borderwidth :: Int
borderwidth = 0

-- Border color
mynormalBorderColor = "#262626"

myfocusedBorderColor = "#ededed"

moveWD = borderwidth

resizeWD = 2 * borderwidth

gapwidth = 4

gwU = 0

gwD = 0

gwL = 0

gwR = 0

myFullFloating = customFloating $ W.RationalRect 0 0.030 1 0.973

myTermFloating = customFloating $ W.RationalRect 0 0.030 1 0.473

myLayout =
  spacingRaw
    False
    (Border gwU gwD gwL gwR)
    True
    (Border gwU gwD gwL gwR)
    True
    $ ResizableTall 1 0.03 0.7 []
      ||| TwoPane 0.5 0.5
      ||| Simplest

-- Scatchpad setting
myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS
      "alacritty"
      "XMODIFIERS= alacritty --title 'Alacritty(floating)' -o window.opacity=0.90"
      (title =? "Alacritty(floating)")
      myTermFloating,
    NS
      "bashtop"
      "XMODIFIERS= alacritty -o shell=bashtop"
      (title =? "BashTOP")
      myFullFloating,
    NS
      "vivaldi"
      "vivaldi-stable" 
      (className =? "Vivaldi-stable")
      myFullFloating,
    NS
      "discord"
      "flatpak run com.discordapp.Discord"
      (className =? "discord")
      myFullFloating,
    NS
      "ncmcpp"
      "XMODIFIERS= alacritty -e ncmcpp --title ncmcpp -h mopidy.local"
      (title =? "ncmpcpp")
      myFullFloating,
    NS
      "mpsyt"
      "XMODIFIERS= alacritty --title mpsyt -e $HOME/.local/bin/mpsyt"
      (title =? "mpsyt")
      myFullFloating,
    NS
      "slack"
      "slack"
      (className =? "Slack")
      myFullFloating,
    NS
      "sidekick"
      "sidekick-browser-stable"
      (className =? "Sidekick-browser")
      myFullFloating
  ]

myManageHookFloat =
  composeAll
    [ className =? "Gimp" --> doFloat,
      className =? "Tk" --> doFloat,
      className =? "mplayer2" --> doCenterFloat,
      className =? "mpv" --> doCenterFloat,
      className =? "feh" --> doCenterFloat,
      className =? "Display.im6" --> doCenterFloat,
      className =? "Shutter" --> doCenterFloat,
      className =? "Thunar" --> doCenterFloat,
      className =? "Peek" --> doCenterFloat,
      className =? "Nautilus" --> doCenterFloat,
      className =? "Plugin-container" --> doCenterFloat,
      className =? "Screenkey" --> doRectFloat (W.RationalRect 0.7 0.9 0.3 0.1),
      className =? "Websearch" --> doCenterFloat,
      className =? "XClock" --> doSideFloat NE,
      title =? "Speedbar" --> doCenterFloat,
      title =? "urxvt_float" --> doSideFloat SC,
      isFullscreen --> doFullFloat,
      isDialog --> doCenterFloat,
      stringProperty "WM_NAME" =? "LINE" --> doRectFloat (W.RationalRect 0.60 0.1 0.39 0.82),
      stringProperty "WM_NAME" =? "Google Keep" --> doRectFloat (W.RationalRect 0.3 0.1 0.4 0.82),
      stringProperty "WM_NAME" =? "tmptex.pdf - 1/1 (96 dpi)" --> doRectFloat (W.RationalRect 0.29 0.25 0.42 0.5),
      stringProperty "WM_NAME" =? "Figure 1" --> doFloat,
      isRole =? "pop-up" --> doCenterFloat,
      isRole =? "bubble" --> doCenterFloat
    ]
  where
    isRole = stringProperty "WM_WINDOW_ROLE"

-- ManageHook setting
myManageHookShift =
  composeAll
    [ className =? "Gimp" --> mydoShift "3",
      stringProperty "WM_NAME" =? "Figure 1" --> doShift "5"
    ]
  where
    mydoShift = doF . liftM2 (.) W.greedyView W.shift

myLayoutHook =
  avoidStruts $
    toggleLayouts
      (noBorders Full)
      myLayout

{-
  $ onWorkspace "3" simplestFloat
    $ onWorkspace "5" (
        spacingRaw
        False
        (Border 14 0 14 0)
        True
        (Border 0 14 0 14)
        True
        $ ResizableTall 0 (1 / 42) (1 / 2) [])
    -}

myManageHook :: ManageHook
myManageHook =
  manageDocks
    <+> myManageHookShift
    <+> myManageHookFloat
    <+> namedScratchpadManageHook myScratchpads
