module Waggle.Pointer where

import Graphics.Collage exposing (Form, segment, traced, solid, circle, filled, move, group)

import Waggle.Sensor exposing (SensorId)
import Waggle.View exposing (Side(Right, Left))
import Waggle.Config exposing (sensor, image, pointerStyle)

import EnvSense exposing (pointerStart, side, index)

pointer : SensorId -> Form
pointer sensorId = 
    let start = pointerStart sensorId
        endX = ((toFloat image.width + 2 * image.marginX) / 2) * (case side sensorId of
            Left -> -1
            Right -> 1
        {- end case -})
        endY = -(toFloat (image.height + sensor.height) / 2 ) + (toFloat <| (sensor.height + 2 * sensor.marginY) * (10 - index sensorId))
        dot = circle 6 |> filled pointerStyle.color |> move start
    in group [
        dot,
        segment start (endX, endY)
            |> traced pointerStyle
    ]

