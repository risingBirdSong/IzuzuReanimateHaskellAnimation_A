{-# OPTIONS_GHC -Wall #-}

import Reanimate
import Reanimate.Builtin.Documentation

main :: IO ()
main = reanimate drawDynamicRectangle

drawDynamicRectangle :: Animation
drawDynamicRectangle =
    docEnv
    $ addStatic (mkBackground "cyan")
    $ addStatic mkBackgroundGrid
    $ scene
    $ do
        let rect = do
            h <- newVar 10
            w <- newVar 5
            newSprite_ $ mkRect <$> unVar h <*> unVar w
            tweenVar h 1 $ \t -> fromToS t 8 . curveS 2
            tweenVar w 1 $ \t -> fromToS t 4 . curveS 2
            tweenVar h 1 $ \t -> fromToS t 4 . curveS 2
        
        s <- fork $ newSpriteA $ scene rect
        spriteE s $ overBeginning 0.5 fadeInE
        spriteE s $ overEnding 0.5 fadeOutE

mkBackgroundGrid :: SVG
mkBackgroundGrid =
    gridLayout
    . replicate 9
    . replicate 16
    . withStrokeWidth 0.01
    $ mkRect 1 1
