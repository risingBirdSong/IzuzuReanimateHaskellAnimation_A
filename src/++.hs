{-# OPTIONS_GHC -Wall #-}

{-# LANGUAGE OverloadedStrings #-}

import Data.Foldable
import Control.Lens
import Reanimate
import Reanimate.Scene
import Reanimate.Builtin.Documentation

import Utilities.Main
import Utilities.List

main :: IO ()
main = reanimate animation

env :: Animation -> Animation
env =
    docEnv
    . addStatic (mkBackground $ "floralwhite")
    -- . addStatic mkBackgroundMinorGrid
    -- . addStatic mkBackgroundMajorGrid

animation :: Animation
animation = env . applyE (overEnding 1 fadeOutE) $ scene $ do
    let
        xsColor = "red"
        ysColor = "blue"
        combinedColor = "magenta"
        typeSigGlyph =
            withDefaultBoldTextStrokeFill
            . translate 0 2.5
            . centerX
            . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
            $ "(++) :: [a] -> [a] -> [a]"
        funcDefGlyph =
            withDefaultBoldTextStrokeFill
            . translate 0 1.5
            . centerX
            . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
            $ "xs ++ ys"

    typeSig <- oNew typeSigGlyph
    funcDef <- oNew funcDefGlyph

    xsBoxes <- oNew $ list2Boxes xsColor
    xsLabels <- oNew $ list2Labels xsColor "x" "m"

    ysBoxes <- oNew $ list3Boxes ysColor
    ysLabels <- oNew $ list3Labels ysColor "y" "n"

    let
        showTypeSigFuncDef = forkAllWithLag 0.25
            [ oShowWith typeSig $ setDuration 1 . oDraw
            , oShowWith funcDef $ setDuration 1 . oDraw
            ]

        showXs = do
            forkAllWithDifferentLags [0, 0.25]
                [ let f t' =
                          withSubglyphs [0, 1]
                              (withTweenedColor "black" xsColor t')
                  in oTween funcDef 1 $ \t -> oContext %~ (f t .)
                , oShowWith xsBoxes $ setDuration 1 . oDraw
                , oShowWith xsLabels $ setDuration 1 . oDraw
                ]

        moveXsBottomLeft = forkAll
            [ oTween xsBoxes 1 $ oMoveTo ((-4.5), (-1.5))
            , oTween xsLabels 1 $ oMoveTo ((-4.5), (-1.5))
            ]

        showYs = do
            forkAllWithDifferentLags [0, 0.25]
                [ let f t' =
                        withSubglyphs [4, 5]
                            (withTweenedColor "black" ysColor t')
                  in oTween funcDef 1 $ \t -> oContext %~ (f t .)
                , oShowWith ysBoxes $ setDuration 1 . oDraw
                , oShowWith ysLabels $ setDuration 1 . oDraw
                ]

        moveYsBottomRight = forkAll
            [ oTween ysBoxes 1 $ oMoveTo (3.5, (-1.5))
            , oTween ysLabels 1 $ oMoveTo (3.5, (-1.5))
            ]

        moveFuncDefDown = oTween funcDef 1 $ oMoveTo (0, (-1))

        snapXsYs = do
            traverse_
                (\x ->
                    oModify x $ oEasing .~ powerS 5)
                [xsBoxes, xsLabels, ysBoxes, ysLabels]
            forkAll
                [ oTween xsBoxes 0.5 $ oMoveTo ((-3.5), (-1.5))
                , oTween xsLabels 0.5 $ oMoveTo ((-3.5), (-1.5))
                , oTween ysBoxes 0.5 $ oMoveTo ((2.5), (-1.5))
                , oTween ysLabels 0.5 $ oMoveTo ((2.5), (-1.5))
                ]
            traverse_
                (\x -> oModify x $ oEasing .~ curveS 2)
                [xsBoxes, xsLabels, ysBoxes, ysLabels]

        highlightCombinedXsYs = do
            traverse_
                (\x -> oModify x $ oContext .~ withColor combinedColor)
                [funcDef, xsBoxes, xsLabels, ysBoxes, ysLabels]

    wait 1

    showTypeSigFuncDef

    wait 0.5

    showXs

    moveXsBottomLeft

    showYs

    fork $ moveYsBottomRight
    moveFuncDefDown

    wait 0.5

    snapXsYs

    highlightCombinedXsYs

    wait 3
