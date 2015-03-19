module Main where

import Signal
import Window
import Time (Time)
import Text (Text, leftAligned, rightAligned, fromString, height, typeface, asText, concat)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty, spacer,
    down, right, left, middle, inward, midBottom,
    midRight, bottomRight, bottomLeft,
    relative, absolute,
    widthOf, heightOf,
    opacity, color, above)
import Graphics.Collage (collage)
import List
import Dict
import String

import QueueBuffer
import Chart (chart, toPoint)
import Util (truncateFloat)
import Waggle.Sensor (..)
import Waggle.Update (sensorData)
import Waggle.Pointer (pointer)
import Waggle.Config as Config
import Waggle.View (Side(Right, Left), alignSensor, marginX, marginY, sensorContainer, valueContainer, viewLabel, h1, h2)

import EnvSense (side, name, order, viewAcceleration, viewMagneticField, viewInfraRedCamera)

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions sensorData

-- view
view : (Int, Int) -> SensorBoard -> Element
view (windowWidth, windowHeight) data = 
    let (leftLayout, rightLayout) = Dict.partition (\sensorId _ -> (side sensorId == Left)) data
        center = container windowWidth windowHeight middle
        centerVertically el = container (widthOf el) windowHeight middle el
        alignBottom el = container (widthOf el) (.height Config.image) midBottom el
        info = (center << flow right) [
            (centerVertically << alignBottom)
                <| flow down 
                <| List.map (alignSensor Left << viewSensorHistory) 
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList leftLayout,
            centerVertically 
                <| marginX (.marginX Config.image)
                <| image (.width Config.image) (.height Config.image) Config.sensorImageUrl,
            (centerVertically << alignBottom)
                <| flow down 
                <| List.map (alignSensor Right << viewSensorHistory)
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList rightLayout
        ]
    in layers [
        (h1 Config.title) `above` (h2 Config.secondary),
        info,
        center
            <| collage windowWidth windowHeight 
            <| List.map pointer 
            <| Dict.keys data
    ]

viewSensorHistory : (SensorId, SensorHistory) -> Element
viewSensorHistory (sensorId, sensorHistory) = sensorContainer (name sensorId) (case name sensorId of
    "D6T44L06" -> viewInfraRedCamera sensorId sensorHistory
    "MMA8452Q" -> viewAcceleration sensorId sensorHistory
    "HMC5883" -> viewMagneticField sensorId sensorHistory
    _ -> Dict.toList sensorHistory
            |> List.map viewValueHistory
            |> List.intersperse (spacer (.marginX Config.value) (.height Config.value))
            |> flow right
    )

viewValueHistory : (PhysicalQuantity, ValueHistory) -> Element
viewValueHistory (_, history) = 
    let chartSize = (.width Config.chart, .height Config.chart)
        historyChart = chart (QueueBuffer.maxSize history) chartSize
            <| QueueBuffer.toList (QueueBuffer.map toPoint history)
    in
        flow down [
            QueueBuffer.mapLast viewLabel empty history,
            historyChart
        ]
        