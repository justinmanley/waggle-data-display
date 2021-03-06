module View.Util where

import Color
import Date
import Dict
import Graphics.Element exposing 
    ( Element, empty 
    , midBottom, middle
    , widthOf, heightOf
    , leftAligned
    , container, color
    , beside, above, bottomLeft, link )
import String
import Text exposing ( fromString, style )

import View.Chart exposing ( chart )
import Config exposing 
    ( sensor, value
    , primaryStyle, h1Style 
    , h2Style
    , physicalQuantity )
import QueueBuffer
import Sensor exposing ( PhysicalQuantity, ReadingHistory, Reading )
import Util

{-| Tag indicating the side of the image corresponding to each sensor. -}
type Side = Left | Right

{-| Generates the visual container for a sensor. -}
sensorContainer : String -> Element -> Element
sensorContainer sensorName = above (primaryText sensorName |> leftAligned)
    >> link ("./assets/SensorDataSheets/" ++ sensorName ++ ".pdf")

{-| Generates the visual container for a single value (i.e. measurement). -}
valueContainer : Element -> Element
valueContainer el = container value.width (heightOf el) bottomLeft el

{- Helpers -}
primaryText : String -> Text.Text
primaryText = fromString >> style primaryStyle

h1 = fromString >> style h1Style >> leftAligned >> marginY 10
h2 = fromString >> style h2Style >> leftAligned >> marginY 10

{-| Give an element (the appearance of) top and bottom margins. -}
marginX : Int -> Element -> Element
marginX margin el = container (widthOf el + 2 * margin) (heightOf el) middle el

marginY : Int -> Element -> Element
marginY m el = container (widthOf el) (heightOf el + 2 * m) midBottom el

padding : Int -> Element -> Element
padding p el = container (widthOf el + 2 * p) (heightOf el + 2 * p) middle el

hline : Int -> Element
hline width = container width (6 + 1) middle
    <| color Color.lightGrey 
    <| container width 1 middle empty

viewReadingHistory : (PhysicalQuantity, ReadingHistory) -> Element
viewReadingHistory (name, history) = 
    let historyChart : Element
        historyChart = chart Config.chart 
            <| QueueBuffer.map (\{ timestamp, value } -> (timestamp, value)) history

        label : Element
        label = QueueBuffer.mapLast (valueLabel name) empty history

    in historyChart `beside` label

valueLabel : PhysicalQuantity -> Reading -> Element
valueLabel quantityName v = 
    let name : Element
        name = quantityName
            |> String.toLower >> primaryText >> leftAligned 
            |> (\el -> container physicalQuantity.width (heightOf el) midBottom el)

        units : Text.Text
        units = v.units |> primaryText

        quantity : Text.Text
        quantity = v.value |> Util.truncateFloat 2 |> toString
            |> (Text.fromString >> Text.style Config.primaryStyle)
            |> Text.color Color.red

    in name `beside` (Text.append quantity units |> leftAligned)
