module Demo where

import Signal
import Window
import Text (Text, leftAligned, rightAligned, fromString, height, typeface, asText)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty, spacer,
    down, right, middle, inward,
    midRight,
    relative, absolute)
import List
import Dict

import Waggle.Sensor (..)
import Waggle.Layout (Side(Left, Right), side)
import Waggle.Update (sensorData)
import Chart (chart)
import QueueBuffer
import Waggle.Config as Config

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions sensorData

-- view
view : (Int, Int) -> HistoricalData -> Element
view (windowWidth, windowHeight) data = 
    let (leftLayout, rightLayout) = Dict.partition (\sensorId _ -> (side sensorId == Left)) data
        center = container windowWidth windowHeight middle
        info = flow right [
                flow down <| List.map viewSensor <| Dict.values leftLayout,
                spacer (.width Config.image) (.height Config.image),
                flow down <| List.map viewSensor <| Dict.values rightLayout
            ]
    in layers <| List.map center [
            info,
            image (.width Config.image) (.height Config.image) Config.sensorImageUrl
        ]

viewSensor : SensorHistory -> Element
viewSensor sensorHistory = Dict.values sensorHistory
        |> List.map viewValue
        |> flow down

viewValue : ValueHistory -> Element
viewValue history = 
    let chartSize = (.width Config.chart, .height Config.chart)
        chartMargins = (2, 2) 
    in
        chart (QueueBuffer.maxSize history) chartSize chartMargins
            <| QueueBuffer.toList history 