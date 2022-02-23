import XMonad
import XMonad.Config.Desktop

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad

import XmonadConfig.Workspace
import XmonadConfig.Layouts
import XmonadConfig.Keys

main = xmonad
      $ ewmhFullscreen . ewmh
      $ withSB (myPolybarConf "$HOME/.config/polybar/launch.sh")
      $ docks 
      myConfig

mydefLogPP
  = filterOutWsPP
      [scratchpadWorkspaceTag]
      def {ppHiddenNoWindows = stickmyfavorit}

stickmyfavorit "home" = "home"
stickmyfavorit _ = ""

myPolybarConf cmd
  = def { sbLogHook
            = xmonadPropLog
              =<<  dynamicLogString polybarPPdef
        , sbStartupHook = spawn cmd
        , sbCleanupHook = spawn "killall polybar"
        }

polybarPPdef
  = mydefLogPP { ppCurrent
                  = polybarColor "#CFD8DC" "#222D32"}

polybarColor :: String -> String -> String -> String
polybarColor fore_color back_color
  = wrap ("%{B" <> back_color <> "} ") " %{B-}" 
  . wrap ("%{F" <> fore_color <> "} ") " %{F-}" 

-- StartupHook setting
myStartupHook = do
        spawn     "$HOME/.config/polybar/launch.sh"
        spawnOnce "nm-applet"
        spawnOnce "blueman-applet"
        spawnOnce "fcitx5"
        spawnOnce "gnome-keyring-daemon --start --components=secrets"
        spawn     "$HOME/.fehbg"
        spawnOnce "picom"
        spawnOnce "light-locker --no-late-locking --lock-on-suspend"
        spawn     "easystroke"

myConfig = desktopConfig
    { borderWidth        = borderwidth
    , terminal           = "alacritty"
    , focusFollowsMouse  = False
    , startupHook        = myStartupHook
    , manageHook         = myManageHook
    , layoutHook         = myLayoutHook
    , workspaces         = myWorkspaces
    , modMask            = modm
    , mouseBindings      = newMouse
    }
    `removeKeysP` myRemoveKeysP
    `additionalKeysP` myAdditionalKeysP
    `additionalKeys` myAddtionalKeys
