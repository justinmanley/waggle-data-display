module Chart (chart) where

import Graphics.Element (Element, empty, spacer)
import Graphics.Collage (path, traced, solid, collage)
import Color (black)
import Signal (Signal, map, constant)
import Signal.Extra (runBuffer)
import List

type alias Point a = (a, a)

-- TODO:
--     * Change List to a QueueBuffer
--     * Add a margin at the top and bottom of the image.
--     * Want there to be a constant x-distance between data points, regardless of how many data
--       points are actually being shown.
-- What about when the max or min is negative?
chart : Point Int -> List (Point Float) -> Element
chart (width, height) data = case List.unzip data of
    (x :: xs, y :: ys) -> 
        let bbox = {
                x = { max = List.foldr max x xs, min = List.foldr min x xs },
                y = { max = List.foldr max y ys, min = List.foldr min y ys }
            }

            xMid = bbox.x.min + (bbox.x.max - bbox.x.min) / 2
            yMid = bbox.y.min + (bbox.y.max - bbox.y.min) / 2

            xScale = (toFloat width) / (bbox.x.max - bbox.x.min)
            yScale = (toFloat height) / (bbox.y.max - bbox.y.min)

            fit (x, y) = ((x - xMid) * xScale, (y - yMid) * yScale)
            coordinates = List.map fit data
        in collage width height [traced (solid black) (path coordinates)]
    _ -> spacer width height

