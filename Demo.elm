module Demo where

import Signal
import Window
import Text (Text, leftAligned, rightAligned, fromString, height, typeface, asText)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty,
    down, right, middle, inward,
    relative, absolute)
import List
import Dict

import Waggle.Sensor (..)
--import Waggle.Layout (Side, side, pos, align)
import Waggle.Update (sensorData)
import Chart (chart)
import QueueBuffer

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions sensorData

-- view
view : (Int, Int) -> HistoricalData -> Element
view (windowWidth, windowHeight) data = flow down <|
    List.concatMap viewSensor <| Dict.values data

viewSensor : SensorHistory -> List Element
viewSensor sensorHistory = 
    let chartBuffer buf = chart (QueueBuffer.maxSize buf) (300, 200) (2, 2) 
        <| QueueBuffer.toList buf
    in List.map chartBuffer <| Dict.values sensorHistory