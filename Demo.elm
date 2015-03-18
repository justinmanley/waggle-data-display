module Demo where

import Signal
import Window
import Time (Time)
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
import Waggle.Layout (Side(Left, Right), side, name)
import Waggle.Update (sensorData)
import Chart (chart)
import QueueBuffer
import Waggle.Config as Config
import Util (truncateFloat)

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions sensorData

-- view
view : (Int, Int) -> HistoricalData -> Element
view (windowWidth, windowHeight) data = 
    let (leftLayout, rightLayout) = Dict.partition (\sensorId _ -> (side sensorId == Left)) data
        center = container windowWidth windowHeight middle
    in flow right [
            flow down <| List.map viewSensor <| Dict.toList leftLayout,
            image (.width Config.image) (.height Config.image) Config.sensorImageUrl,
            flow down <| List.map viewSensor <| Dict.toList rightLayout
        ]

viewSensor : (SensorId, SensorHistory) -> Element
viewSensor (sensorId, sensorHistory) = case name sensorId of
    "D6T44L06" -> empty
    _ -> flow down [
            leftAligned (fromString <| name sensorId),    
            Dict.toList sensorHistory
                |> List.map viewValue
                |> flow right
        ]

viewValue : (PhysicalQuantity, ValueHistory) -> Element
viewValue (physicalQuantity, history) = 
    let chartSize = (.width Config.chart, .height Config.chart)
        chartMargins = (2, 2)
        historyChart = chart (QueueBuffer.maxSize history) chartSize chartMargins
            <| QueueBuffer.toList history 
    in
        flow down [
            leftAligned (fromString physicalQuantity),
            QueueBuffer.mapLast viewMostRecentValue empty history,
            historyChart
        ]

viewMostRecentValue : (Time, Float) -> Element
viewMostRecentValue (_, val) = leftAligned (fromString <| toString <| truncateFloat 2 val)
        