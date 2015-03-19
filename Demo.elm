module Demo where

import Signal
import Window
import Time (Time)
import Text (Text, leftAligned, rightAligned, fromString, height, typeface, asText)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty, spacer,
    down, right, left, middle, inward,
    midRight, bottomRight,
    relative, absolute,
    widthOf, heightOf)
import Graphics.Collage (collage)
import List
import Dict

import Waggle.Sensor (..)
import Waggle.Layout (Side(Left, Right), side, name, physicalQuantityName, alignSensor, order)
import Waggle.Update (sensorData)
import Chart (chart)
import Waggle.Pointer (pointer)
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
        centerVertically el = container (widthOf el) windowHeight middle el
        info = (center << flow right << List.map centerVertically) [
            flow down <| List.map (alignSensor Left << viewSensor) 
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList leftLayout,
            image (.width Config.image) (.height Config.image) Config.sensorImageUrl,
            flow down <| List.map (alignSensor Right << viewSensor)
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList rightLayout
        ]
    in layers [
        info,
        center
            <| collage windowWidth windowHeight 
            <| List.map pointer 
            <| Dict.keys data
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
        name = leftAligned (fromString <| physicalQuantityName physicalQuantity)
        lastValue = QueueBuffer.mapLast viewMostRecentValue empty history
        info = [
            name, 
            container 75 (heightOf lastValue) bottomRight lastValue
        ]
    in
        flow down [
            flow right info,
            historyChart
        ]

viewMostRecentValue : (Time, Float) -> Element
viewMostRecentValue (_, val) = leftAligned 
    <| fromString 
    <| toString 
    <| truncateFloat 2 val
        