{-# OPTIONS_GHC -Wall #-}

{-# LANGUAGE OverloadedStrings #-}

module Utilities.List
    ( list2Offsets
    , list2Boxes
    , list2Brackets
    , list2Labels
    , list3Offsets
    , list3Boxes
    , list3Labels
    )
where

import Data.Text
    ( Text
    , words
    )
import Reanimate

import Utilities.Main

{-
import Reanimate.Scene
import Reanimate.Builtin.Documentation

main :: IO ()
main = reanimate testAnimation

testAnimation :: Animation
testAnimation =
    docEnv
    . addStatic (mkBackground $ "floralwhite")
    . addStatic mkBackgroundMinorGrid
    . addStatic mkBackgroundMajorGrid
    $ scene
    $ do
        xsBrackets <- oNew $ list2Brackets "blue"
        xsLabels <- oNew $ list2Labels "blue" "x" "m"
        oShow xsBrackets
        oShow xsLabels
        wait 1
-}

list2Offsets :: [SVG -> SVG]
list2Offsets =
    [ translate (-2) 0
    , translate (-1) 0
    , translate 0.5 0
    , translate 2 0
    ]

list2Boxes :: String -> SVG
list2Boxes color =
    withColor color
    . withDefaultLineStrokeFill
    . mkGroup
    . zipWith ($) list2Offsets
    $
        [ mkRect 1 1
        , mkRect 1 1
        , mkRect 2 1
        , mkRect 1 1]

list2Brackets :: String -> SVG
list2Brackets color =
    withColor color
    . withDefaultTextStrokeFill
    . mkGroup
    . zipWith ($)
        [ translate (-2.5) 0
        , translate (-1.5) 0
        , translate (-0.5) 0
        , translate 1.5 0
        , translate 2.5 0
        ]
    . map
        ( centerX
        . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
        )
    . Data.Text.words
    $ "[ , , , ]"

list2Labels :: String -> Text -> Text -> SVG
list2Labels color name size =
    withColor color
    . withDefaultTextStrokeFill
    . mkGroup
    . zipWith ($) list2Offsets
    . map
        ( centerX
        . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
        )
    $
        [ name <> "\\textsubscript{0}"
        , name <> "\\textsubscript{1}"
        , "..."
        , name <> "\\textsubscript{" <> size <> "-1}"
        ]

list3Offsets :: [SVG -> SVG]
list3Offsets =
    [ translate (-3) 0
    , translate (-2) 0
    , translate 0 0
    , translate 2 0
    , translate 3 0
    ]

list3Boxes :: String -> SVG
list3Boxes color =
    withColor color
    . withDefaultLineStrokeFill
    . mkGroup
    . zipWith ($) list3Offsets
    $
        [ mkRect 1 1
        , mkRect 1 1
        , mkRect 3 1
        , mkRect 1 1
        , mkRect 1 1]

list3Labels :: String -> Text -> Text -> SVG
list3Labels color name size =
    withColor color
    . withDefaultTextStrokeFill
    . mkGroup
    . zipWith ($) list3Offsets
    . map
        ( centerX
        . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
        )
    $
        [ (name <> "\\textsubscript{0}")
        , (name <> "\\textsubscript{1}")
        , ("...")
        , (name <> "\\textsubscript{" <> size <> "-2}")
        , (name <> "\\textsubscript{" <> size <> "-1}")
        ]
