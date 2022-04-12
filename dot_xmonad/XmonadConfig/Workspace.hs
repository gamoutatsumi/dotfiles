module XmonadConfig.Workspace
  ( myWorkspaces
  , nextWS'
  , prevWS'
  , shiftToNext'
  , shiftToPrev'
  ) where

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS

myWorkspaces = ["1", "2", "3", "4", "5"]

notSP :: X (WindowSpace -> Bool)
notSP = return $ ("NSP" /=) . W.tag

nextWS' :: X ()
nextWS' = moveTo Next (WSIs notSP)
prevWS' :: X ()
prevWS' = moveTo Prev(WSIs notSP)
shiftToNext' :: X ()
shiftToNext' = shiftTo Next (WSIs notSP)
shiftToPrev' :: X ()
shiftToPrev' = shiftTo Prev (WSIs notSP)
