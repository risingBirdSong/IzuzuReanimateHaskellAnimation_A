module Main(main) where

import Reanimate
import Reanimate.Builtin.Documentation

main :: IO ()
main = reanimate $ docEnv $ drawBox `parA` adjustDuration (*2) drawCircle
