module Waggle.View where

import Graphics.Element (
    Element, 
    midRight, midLeft, 
    midBottom, middle,
    widthOf, heightOf,
    container, color, flow, down, above, bottomLeft, link)
import Text (fromString, style, leftAligned)
import List

import Util
import Waggle.Config (sensor, value, primaryStyle, h1Style, h2Style, sensorBackgroundColor)
import Waggle.Sensor (Value, SensorId)

{-| Tag indicating the side of the image corresponding to each sensor. -}
type Side = Left | Right

{-| Generates the visual container for a sensor. -}
sensorContainer : String -> Element -> Element
sensorContainer sensorName = above (primaryText sensorName)
    >> marginX sensor.marginX
    >> color sensorBackgroundColor
    >> marginY sensor.marginY
    >> link ("./assets/SensorDataSheets/" ++ sensorName ++ ".pdf")

{-| Generates the visual container for a single value (i.e. measurement). -}
valueContainer : Element -> Element
valueContainer el = container value.width (heightOf el) bottomLeft el

viewLabel : Value -> Element
viewLabel val = 
    let value = val.value |> Util.truncateFloat 2 |> toString
    in val.physicalQuantity ++ ": " ++ value ++ val.units
        |> primaryText

{- Helpers -}
primaryText : String -> Element
primaryText = fromString
    >> style primaryStyle
    >> leftAligned

h1 = fromString >> style h1Style >> leftAligned >> marginY 10
h2 = fromString >> style h2Style >> leftAligned >> marginY 5

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