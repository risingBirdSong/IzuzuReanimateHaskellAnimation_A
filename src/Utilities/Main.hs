{-# OPTIONS_GHC -Wall #-}

{-# LANGUAGE OverloadedStrings #-}

module Utilities.Main
    ( (-<)
    , splitInitLast
    , firaCfg
    , defaultTextScale
    , withDefaultTextStrokeFill
    , withDefaultBoldTextStrokeFill
    , withDefaultLineStrokeFill
    , c10Colormap
    , pairedColormap
    , appleColormap
    , backgroundColors
    , mkBackgroundMajorGrid
    , mkBackgroundMinorGrid
    , latexCfgCenteredYWith
    , forkLag
    , forkAllWithDifferentLags
    , forkAllWithLag
    , forkAll
    , withColor
    , withColorPixel
    , oMoveTo
    , interpolateAsPixel
    , withTweenedColor
    )
where

import Data.Text (Text)
import Control.Lens
import Linear.Vector
import Linear.V2
import Codec.Picture (PixelRGBA8)
import Graphics.SvgTree (Texture (ColorRef))
import Reanimate
import Reanimate.Scene
import Reanimate.LaTeX
import Reanimate.ColorComponents

infixl 1 -<
(-<) :: (a -> b) -> a -> b
(-<) = ($)

{-| From Data.List.Extra in extra. -}
splitInitLast :: [a] -> Maybe ([a], a)
splitInitLast [] = Nothing
splitInitLast [x] = Just ([], x)
splitInitLast (x:xs) = Just (x:a, b)
    where Just (a,b) = splitInitLast xs

firaCfg :: TexConfig
firaCfg = TexConfig LaTeX
    [ "\\usepackage{FiraMono}"
    , "\\renewcommand*\\familydefault{\\ttdefault}"
    , "\\usepackage[T1]{fontenc}"
    ]
    ["\\normalfont"]

defaultTextScale :: Double
defaultTextScale = 0.5

withDefaultTextStrokeFill :: SVG -> SVG
withDefaultTextStrokeFill = withStrokeWidth 0.025 . withFillOpacity 1

withDefaultBoldTextStrokeFill :: SVG -> SVG
withDefaultBoldTextStrokeFill = withStrokeWidth 0.05 . withFillOpacity 1

withDefaultLineStrokeFill :: SVG -> SVG
withDefaultLineStrokeFill = withStrokeWidth 0.05 . withFillOpacity 0

c10Colormap :: [String]
c10Colormap =
    [ "steelblue"
    , "darkorange"
    , "forestgreen"
    , "crimson"
    , "mediumpurple"
    , "sienna"
    , "orchid"
    , "gray"
    , "yellowgreen"
    , "darkturquoise"
    ]

pairedColormap :: [String]
pairedColormap =
    [ "lightblue"
    , "steelblue"
    , "lightgreen"
    , "forestgreen"
    , "lightcoral"
    , "sandybrown"
    , "darkorange"
    , "thistle"
    , "darkslateblue"
    , "khaki"
    , "sienna"
    ]

appleColormap :: String -> String
appleColormap "blue" = "dodgerblue"
appleColormap "brown" = "peru"
appleColormap "cyan" = "deepskyblue"
appleColormap "green" = "limegreen"
appleColormap "indigo" = "slateblue"
appleColormap "mint" = "darkturquoise"
appleColormap "orange" = "darkorange"
appleColormap "pink" = "deeppink"
appleColormap "purple" = "mediumorchid"
appleColormap "red" = "orangered"
appleColormap "teal" = "lightseagreen"
appleColormap "yellow" = "gold"
appleColormap _ = "black"

backgroundColors :: [String]
backgroundColors =
    [ "floralwhite"
    , "ghostwhite"
    , "aliceblue"
    , "oldlace"
    , "mintcream"
    , "seashell"
    , "lavender"]

mkBackgroundMajorGrid :: SVG
mkBackgroundMajorGrid =
    gridLayout
    . replicate 2
    . replicate 2
    . withStrokeWidth 0.03
    . withStrokeColor "gray"
    $ mkRect 8 4.5

mkBackgroundMinorGrid :: SVG
mkBackgroundMinorGrid =
    gridLayout
    . replicate 9
    . replicate 16
    . withStrokeWidth 0.01
    . withStrokeColor "gray"
    $ mkRect 1 1

latexCfgCenteredYWith :: TexConfig -> (SVG -> SVG) -> Text -> SVG
latexCfgCenteredYWith config transformation =
    mkGroup
    . drop 4
    . removeGroups
    . centerY
    . transformation
    . latexCfg config
    . ("$\\biggl \\lvert$" <>)

forkLag :: Double -> Scene s a -> Scene s ()
forkLag time action = fork action >> wait time

forkAllWithDifferentLags :: [Double] -> [Scene s a] -> Scene s ()
forkAllWithDifferentLags _ [] = pure ()
forkAllWithDifferentLags lags scenes =
    sequence_ (zipWith forkLag (lags ++ repeat 0) initScenes)
    >> lastScene
    >> pure ()
    where Just (initScenes, lastScene) = splitInitLast scenes

forkAllWithLag :: Double -> [Scene s a] -> Scene s ()
forkAllWithLag _ [] = pure ()
forkAllWithLag time scenes = forkAllWithDifferentLags (repeat time) scenes

forkAll :: [Scene s a] -> Scene s ()
forkAll = forkAllWithLag 0

withColor :: String -> SVG -> SVG
withColor color =
    withStrokeColor color
    . withFillColor color

withColorPixel :: PixelRGBA8 -> SVG -> SVG
withColorPixel colorPixel =
    withStrokeColorPixel colorPixel
    . withFillColorPixel colorPixel

oMoveTo :: (Double, Double) -> Double -> ObjectData a -> ObjectData a
oMoveTo (x, y) t = oTranslate %~ lerp t (V2 x y)

interpolateAsPixel :: String -> String -> Double -> PixelRGBA8
interpolateAsPixel fromColor toColor =
    interpolateRGBA8 labComponents rgba1 rgba2
    where
        (ColorRef rgba1) = mkColor fromColor
        (ColorRef rgba2) = mkColor toColor

withTweenedColor :: String -> String -> Double -> SVG -> SVG
withTweenedColor fromColor toColor t =
    withColorPixel $ interpolateAsPixel fromColor toColor t
        

