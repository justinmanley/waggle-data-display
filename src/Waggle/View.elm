module Waggle.View where

import Graphics.Element (
    Element, 
    midRight, midLeft, 
    midBottom, middle,
    widthOf, heightOf,
    container, color, flow, down, above, bottomLeft, link)
import Color (lightGrey)
import Text (fromString, style, leftAligned)
import List

import Util
import Waggle.Config (sensor, value, primaryTextStyle)
import Waggle.Sensor (Value, SensorId)

{-| Tag indicating the side of the image corresponding to each sensor. -}
type Side = Left | Right

{-| Give an element (the appearance of) top and bottom margins. -}
marginX : Int -> Element -> Element
marginX margin el = container (widthOf el + 2 * margin) (heightOf el) middle el

marginY : Int -> Element -> Element
marginY m el = container (widthOf el) (heightOf el + 2 * m) midBottom el

padding : Int -> Element -> Element
padding p el = container (widthOf el + 2 * p) (heightOf el + 2 * p) middle el

alignSensor : Side -> Element -> Element
alignSensor side = 
    let alignment = case side of
        Left -> midRight
        Right -> midLeft
    in container sensor.width (sensor.height + 2 * sensor.marginY + 2 * sensor.padding) alignment

sensorContainer : String -> Element -> Element
sensorContainer sensorName = above (primaryText sensorName)
    >> padding sensor.padding
    >> color lightGrey
    >> marginY sensor.marginY

valueContainer : Element -> Element
valueContainer el = container value.width (heightOf el) bottomLeft el

viewLabel : Value -> Element
viewLabel val = 
    let value = val.value |> Util.truncateFloat 2 |> toString
    in val.physicalQuantity ++ ": " ++ value ++ val.units
        |> primaryText

primaryText : String -> Element
primaryText = fromString
    >> style primaryTextStyle
    >> leftAligned