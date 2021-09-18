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

animation :: Animation
animation =
    docEnv
    . addStatic (mkBackground $ "floralwhite")
    -- . addStatic mkBackgroundMinorGrid
    -- . addStatic mkBackgroundMajorGrid
    . applyE (overEnding 1 fadeOutE)
    $ scene
    $ do
        let
            xsColor = "red"
            headColor = "magenta"

            typeSigGlyph =
                withDefaultBoldTextStrokeFill
                . translate 0 2.5
                . centerX
                . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
                $ "tail :: [a] -> [a]"

            funcDefGlyph =
                withDefaultBoldTextStrokeFill
                . translate 0 1.5
                . centerX
                . latexCfgCenteredYWith firaCfg (scale defaultTextScale)
                $ "tail xs"

            xsBoxesGlyph = translate 0 (-0.5) $ list3Boxes xsColor
            (tailBoxesGlyph, headBoxGlyph) = splitGlyphs [0] xsBoxesGlyph

            xsLabelsGlyph = translate 0 (-0.5) $ list3Labels xsColor "x" "m"
            (tailLabelsGlyph, headLabelGlyph) =
                splitGlyphs [0, 1] xsLabelsGlyph

        typeSig <- oNew typeSigGlyph

        funcDef <- oNew funcDefGlyph

        xsBoxes <- oNew xsBoxesGlyph
        xsLabels <- oNew xsLabelsGlyph
        
        headBox <- oNew headBoxGlyph
        headLabel <- oNew headLabelGlyph
        
        tailBoxes <- oNew tailBoxesGlyph
        tailLabels <- oNew tailLabelsGlyph

        wait 1

        forkAllWithLag 0.25
            [ oShowWith typeSig $ setDuration 1 . oDraw
            , oShowWith funcDef $ setDuration 1 . oDraw
            ]

        wait 0.5

        forkAll
            [ let f t' =
                      withSubglyphs [4, 5]
                          (withTweenedColor "black" xsColor t')
              in oTween funcDef 1 $ \t -> oContext %~ (f t .)
            , oShowWith xsBoxes $ setDuration 1 . oDraw
            , oShowWith xsLabels $ setDuration 1 . oDraw
            ]

        traverse_ oHide [xsBoxes, xsLabels]
        traverse_ oShow [headBox, headLabel, tailBoxes, tailLabels]

        wait 1
        
        forkAll
            [ traverse_
                  (\x ->
                      oModify x $ oEasing .~ cubicBezierS (0, 0.985, 0.995, 1))
                  [headBox, headLabel, tailBoxes, tailLabels]
            , oTween headBox 0.5 $ oMoveTo ((-0.5), 0)
            , oTween headLabel 0.5 $ oMoveTo ((-0.5), 0)
            , oTween tailBoxes 0.5 $ oMoveTo (0.5, 0)
            , oTween tailLabels 0.5 $ oMoveTo (0.5, 0)
            , traverse_
                (\x -> oModify x $ oEasing .~ curveS 2)
                [headBox, headLabel, tailBoxes, tailLabels]
            ]
        
        wait 1
            
        forkAll
            [ let f t' =
                      withSubglyphs [4, 5]
                          (withTweenedColor xsColor headColor t')
                      . withSubglyphs [0, 1, 2, 3]
                          (withTweenedColor "black" headColor t')
              in oTween funcDef 1 $ \t -> oContext %~ (f t .)
            , oTween funcDef 1 $ oMoveTo (0, (-0.5))
            , oHideWith headBox $ setDuration 0.5 . oFadeOut
            , oHideWith headLabel $ setDuration 0.5 . oFadeOut
            , oTween tailBoxes 1 $ oMoveTo ((-0.5), 0)
            , oTween tailLabels 1 $ oMoveTo ((-0.5), 0)
            , let f t' =
                      mkGroup
                      . map (withTweenedColor xsColor headColor t')
                      . removeGroups
              in oTween tailBoxes 1 $ \t -> oContext %~ (f t .)
            , let f t' =
                      withSubglyphs [0..20]
                          ( withTweenedColor xsColor headColor t'
                          -- . withStrokeWidth (0.025 + 0.025 * t')
                          )
              in oTween tailLabels 1 $ \t -> oContext %~ (f t .)
            ]
        
        wait 3

        {-

        forkAll
            [ oShowWith funcDefYs $ setDuration 1 . oFadeIn
            , wait 0.25
            , oShowWith ysBoxes $ setDuration 1 . oDraw
            , oShowWith ysLabels $ setDuration 1 . oDraw
            ]
        oModify funcDef
            $ oContext .~ withSubglyphs [0, 1, 4, 5] (withStrokeWidth 0)

        forkAll
            [ oTween ysBoxes 1 $ oMoveTo ((3.5), (-1.5))
            , wait 0.25
            , oTween ysLabels 1 $ oMoveTo ((3.5), (-1.5))
            , oTween funcDef 1 $ oMoveTo (0, (-1))
            , oTween funcDefXs 1 $ oMoveTo (0, (-1))
            , oTween funcDefYs 1 $ oMoveTo (0, (-1))
            ]

        wait 0.5

        traverse_
            (\x -> oModify x $ oEasing .~ powerS 5)
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

        oHide funcDefXs
        oHide funcDefYs
        traverse_
            (\x -> oModify x $ oContext .~ withColor combinedColor)
            [funcDef, xsBoxes, xsLabels, ysBoxes, ysLabels]

        wait 2

        forkAll $ map
            (\x -> oHideWith x $ setDuration 1 . oFadeOut)
            [typeSig, funcDef, xsBoxes, xsLabels, ysBoxes, ysLabels]

        wait 1
        -}
