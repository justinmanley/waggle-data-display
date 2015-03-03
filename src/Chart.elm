module Chart where

import Graphics.Element (Element, empty)
import Graphics.Collage (path, traced, solid, collage)
import Color (black)
import Signal (Signal, map, constant)
import Signal.Extra (runBuffer)
import List (map2, length)

chart : Int -> Int -> (List Float) -> Element
chart width height data = 
    let coordinates = map2 (,) [0..toFloat (length data) - 1] data
    in collage width height [traced (solid black) (path coordinates)]
