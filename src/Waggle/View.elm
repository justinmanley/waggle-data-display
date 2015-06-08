module Waggle.View where

import Date
import Date.Format as Date exposing (format) 
import Dict
import Graphics.Element exposing 
    ( Element
    , container, image, empty 
    , middle, midBottom, midLeft
    , topRight 
    , widthOf, heightOf, layers
    , flow, down, right, beside )
import Graphics.Collage exposing (collage)
import Maybe exposing (withDefault)
import String
import Time exposing (Time)

import Chart exposing (chart, toPoint)
import QueueBuffer
import Util
import Waggle.Config as Config exposing (physicalQuantity)
import Waggle.Pointer exposing (pointer)
import Waggle.Sensor exposing 
    ( SensorBoard, SensorId, Value
    , PhysicalQuantity, SensorHistory, ValueHistory )
import Waggle.View.EnvSense exposing 
    ( side, order, index, name
    , pointerStart
    , viewInfraRedCamera, viewMagneticField, viewAcceleration )
import Waggle.View.Util exposing 
    ( Side(Left, Right), alignSensor
    , marginX, marginY
    , h1, h2, primaryText
    , sensorContainer, valueContainer )

view : (Int, Int) -> (Time, SensorBoard) -> Element
view (windowWidth, windowHeight) (currentTime, data) = 
    let (leftLayout, rightLayout) = 
            Dict.partition (\sensorId _ -> (side sensorId == Left)) data
        center = container windowWidth windowHeight middle
        centerVertically el = container (widthOf el) windowHeight middle el
        alignBottom el = container (widthOf el) (.height Config.image) midBottom el
        info = (center << flow right) 
            [ (centerVertically << alignBottom)
                <| flow down 
                <| List.map (alignSensor Left << viewSensorHistory) 
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList leftLayout
            , centerVertically 
                <| marginX (.marginX Config.image)
                <| image (.width Config.image) (.height Config.image) Config.sensorImageUrl
            , (centerVertically << alignBottom)
                <| flow down 
                <| List.map (alignSensor Right << viewSensorHistory)
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList rightLayout
            ]
    in layers 
        [ h1 Config.title
        , container windowWidth windowHeight topRight (datetime currentTime)
        , info
        , center
            <| collage windowWidth windowHeight 
            <| List.map (\sensorId -> pointer sensorId pointerStart side index)
            <| Dict.keys data
    ]

viewSensorHistory : (SensorId, SensorHistory) -> Element
viewSensorHistory (sensorId, sensorHistory) = sensorContainer (name sensorId) <| 
    case name sensorId of
        "D6T44L06" -> viewInfraRedCamera sensorId sensorHistory
        "MMA8452Q" -> viewAcceleration sensorId sensorHistory
        "HMC5883" -> viewMagneticField sensorId sensorHistory
        _ -> Dict.toList sensorHistory
                |> List.map viewValueHistory
                |> flow down

viewValueHistory : (PhysicalQuantity, ValueHistory) -> Element
viewValueHistory (_, history) = 
    let chartSize = (.width Config.chart, .height Config.chart)
        
        historyChart = chart (QueueBuffer.maxSize history) chartSize
            <| QueueBuffer.toList (QueueBuffer.map toPoint history)

        value v = (v.value |> Util.truncateFloat 2 |> toString) ++ v.units

        label = QueueBuffer.mapLast valueLabel empty history

    in historyChart `beside` label

valueLabel : Value -> Element
valueLabel v = 
    let name : Element
        name = v.physicalQuantity
            |> String.toLower >> primaryText 
            |> (\el -> container physicalQuantity.width (heightOf el) midBottom el) 

        quantity : Element
        quantity = String.concat [ v.value |> Util.truncateFloat 2 |> toString, v.units ]
            |> primaryText
            |> valueContainer            

    in name `beside` quantity

datetime : Time -> Element
datetime time = h2 
    <| format "%B %d, %Y at %H:%M:%S" 
    <| Date.fromTime time

