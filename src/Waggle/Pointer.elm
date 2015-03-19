module Waggle.Pointer where

import Graphics.Collage (Form, segment, traced, solid)
import Color (blue)

import Waggle.Sensor (SensorId)
import Waggle.Layout (Side(Right, Left), pointerStart, index, side)
import Waggle.Config (sensor, image, pointerStyle)

pointer : SensorId -> Form
pointer sensorId = 
    let start = pointerStart sensorId
        endX = ((toFloat image.width) / 2) * (case side sensorId of
            Left -> -1
            Right -> 1
        {- end case -})
        endY = (toFloat image.height / 2) - (toFloat <| sensor.height * (index sensorId))
    in segment start (endX, endY)
        |> traced pointerStyle