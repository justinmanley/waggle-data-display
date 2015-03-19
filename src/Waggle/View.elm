module Waggle.View where

import Graphics.Element (Element, midRight, midLeft, container)

import Waggle.Config (sensor)

type Side = Left | Right

alignSensor : Side -> Element -> Element
alignSensor side = 
    let alignment = case side of
        Left -> midRight
        Right -> midLeft
    in container sensor.width sensor.height alignment