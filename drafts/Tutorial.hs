{-# OPTIONS_GHC -Wall #-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

import Control.Monad.State.Lazy
import Control.Lens
import Linear.Vector
import Linear.V2
import Reanimate
import Reanimate.Scene
import Reanimate.Builtin.Documentation

import Utilities

main :: IO ()
main = reanimate animation2

animation :: Animation
animation = env $ scene $ do
    play $ staticFrame 1 equation
    play $ staticFrame 1 symb_e
    play $ staticFrame 1 symb_eq
    play $ staticFrame 1 symb_m
    play $ staticFrame 1 symb_c2
  where
    [symb_e, symb_eq, symb_m, symb_c2] = map
        (\i -> snd $ splitGlyphs i equation)
        [[0], [1], [2], [3, 4]]

animation2 :: Animation
animation2 = env $ scene $ do
    newSpriteSVG_ equation
    obj <- oNew symb_e
    oShow obj
    oTweenS obj 1 moveTopLeft
    forkAll
        [ oTweenS obj 1 moveTopRight
        , oTweenS obj 1 moveBottomRight
        ]
    oTweenS obj 1 moveBottomLeft
    oTweenS obj 1 moveToOrigin

moveTopLeft :: Double -> State (ObjectData a) ()
moveTopLeft t = do
    oLeftX %= \origin -> fromToS origin screenLeft t
    oTopY %= \origin -> fromToS origin screenTop t

moveTopRight :: Double -> State (ObjectData a) ()
moveTopRight t = do
    oRightX %= \origin -> fromToS origin screenRight t
    oTopY %= \origin -> fromToS origin screenTop t

moveBottomRight :: Double -> State (ObjectData a) ()
moveBottomRight t = do
    oRightX %= \origin -> fromToS origin screenRight t
    oBottomY %= \origin -> fromToS origin screenBottom t

moveBottomLeft :: Double -> State (ObjectData a) ()
moveBottomLeft t = do
    oLeftX %= \origin -> fromToS origin screenLeft t
    oBottomY %= \origin -> fromToS origin screenBottom t

moveToOrigin :: Double -> State (ObjectData a) ()
moveToOrigin t = oTranslate %= lerp t (V2 0 0)

symb_e :: SVG
symb_e = snd $ splitGlyphs [0] equation

equation :: SVG
equation = scale 3 $ center $ latexAlign "E = mc^2"

env :: Animation -> Animation
env = addStatic bg

bg :: SVG
bg = mkBackground "darkturquoise"


