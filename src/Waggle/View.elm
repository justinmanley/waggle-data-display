module Waggle.View where

import Graphics.Element (
    Element, 
    midRight, midLeft, 
    midBottom, middle,
    widthOf, heightOf,
    container, color, flow, down, above)
import Color (lightGrey)
import Text (plainText)

import Waggle.Config (sensor)
import Waggle.Sensor (SensorId)

{-| Tag indicating the side of the image corresponding to each sensor. -}
type Side = Left | Right

{-| Give an element (the appearance of) top and bottom margins. -}
marginX : Int -> Element -> Element
marginX margin el = container (widthOf el + 2 * margin) (heightOf el) middle el

marginY : Int -> Element -> Element
marginY m el = container (widthOf el) (heightOf el + 2 * m) midBottom el

alignSensor : Side -> Element -> Element
alignSensor side = 
    let alignment = case side of
        Left -> midRight
        Right -> midLeft
    in container sensor.width (sensor.height + 2 * sensor.marginY) alignment

sensorContainer : String -> Element -> Element
sensorContainer sensorName = above (plainText sensorName)
    >> color lightGrey
    >> marginY sensor.marginY
