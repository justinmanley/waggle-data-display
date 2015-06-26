module View where

import Color
import Date
import Date.Format as Date exposing (format) 
import Dict
import Graphics.Element exposing 
    ( Element
    , container, image, empty 
    , middle, midBottom, midLeft
    , topRight, leftAligned 
    , widthOf, heightOf, layers
    , flow, down, right, beside )
import Graphics.Collage exposing (collage)
import Maybe exposing (withDefault)
import String
import Text
import Time exposing (Time)

import Chart exposing (chart)
import QueueBuffer
import Util
import Config as Config exposing (physicalQuantity, primaryStyle)
import Sensor exposing 
    ( SensorBoard, SensorId, Value
    , PhysicalQuantity, SensorHistory, ValueHistory )
import EnvSense.View exposing 
    ( side, order, index, name
    , infraRedCamera, magneticField, acceleration
    , viewSensorHistory )
import View.Util exposing 
    ( Side(Left, Right)
    , marginX, marginY
    , h1, h2, primaryText, hline
    , sensorContainer, valueContainer )

view : (Int, Int) -> (Time, SensorBoard) -> Element
view (windowWidth, windowHeight) (currentTime, data) = 
    let (leftLayout, rightLayout) = 
            Dict.partition (\sensorId _ -> (side sensorId == Left)) data
        
        center : Element -> Element 
        center = container windowWidth windowHeight middle
        
        centerVertically : Element -> Element
        centerVertically el = container (widthOf el) windowHeight middle el

        dataDisplay : Element
        dataDisplay = (center << flow right << List.map centerVertically) 
            [ flow down
                <| List.intersperse (hline <| .width Config.sensor)
                <| List.map viewSensorHistory 
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList leftLayout
            , marginX (.marginX Config.image)
                <| image (.width Config.image) (.height Config.image) Config.sensorImageUrl
            , flow down 
                <| List.intersperse (hline <| .width Config.sensor)
                <| List.map viewSensorHistory
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList rightLayout
            ]
    in layers 
        [ h1 Config.title
        , container windowWidth windowHeight topRight (datetime currentTime)
        , dataDisplay
        ]

viewValueHistory : (PhysicalQuantity, ValueHistory) -> Element
viewValueHistory (name, history) = 
    let historyChart : Element
        historyChart = chart Config.chart 
            <| QueueBuffer.map (\{ timestamp, value } -> (timestamp, value)) history

        label : Element
        label = QueueBuffer.mapLast (valueLabel name) empty history

    in historyChart `beside` label

valueLabel : PhysicalQuantity -> Value -> Element
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

datetime : Time -> Element
datetime time = h2 
    <| format "%B %d, %Y at %H:%M:%S" 
    <| Date.fromTime time

