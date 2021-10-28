import XMonad
import XMonad.Config.Desktop

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

import XmonadConfig.Workspace
import XmonadConfig.Layouts
import XmonadConfig.Keys

-- StartupHook setting
myStartupHook = do
        spawn     "$HOME/.config/polybar/launch.sh"
        spawnOnce "nm-applet"
        spawnOnce "blueman-applet"
        spawnOnce "fcitx5"
        spawnOnce "$HOME/.xmonad/pentablet"
        spawnOnce "gnome-keyring-daemon --start --components=secrets"
        spawnOnce "albert"
        spawn     "$HOME/.fehbg"
        spawnOnce "picom"
        spawnOnce "light-locker --no-late-locking --lock-on-suspend"
        spawn     "easystroke"
        spawnOnce "xset s 0 dpms 0 0 0"
        spawnOnce "playerctld daemon"

main :: IO ()

myConfig = desktopConfig
    { borderWidth        = borderwidth
    , terminal           = "alacritty"
    , focusFollowsMouse  = False
    , startupHook        = myStartupHook
    , manageHook         = myManageHook
    , layoutHook         = myLayoutHook
    , logHook            = ewmhDesktopsLogHook
    , handleEventHook    = ewmhFullscreen
    , workspaces         = myWorkspaces
    , modMask            = modm
    , mouseBindings      = newMouse
    }
    `removeKeysP` myRemoveKeysP
    `additionalKeysP` myAdditionalKeysP
    `additionalKeys` myAddtionalKeys

main = do
  xmonad . ewmh $ docks myConfig
