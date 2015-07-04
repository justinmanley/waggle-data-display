module View (view) where

import Date
import Date.Format as Date exposing (format) 
import Dict
import Graphics.Element exposing 
    ( Element
    , container, image
    , middle, topRight
    , widthOf, layers
    , flow, down, right )
import Time exposing (Time)

import Config exposing ( physicalQuantity, primaryStyle )
import Sensor exposing ( SensorBoard )
import EnvSense.View exposing ( side, order, viewSensor )
import View.Util exposing ( Side(Left, Right), marginX, h1, h2, hline )

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
                <| List.map viewSensor 
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList leftLayout
            , marginX (.marginX Config.image)
                <| image (.width Config.image) (.height Config.image) Config.sensorImageUrl
            , flow down 
                <| List.intersperse (hline <| .width Config.sensor)
                <| List.map viewSensor
                <| List.sortWith (\s1 s2 -> order (fst s1) (fst s2))
                <| Dict.toList rightLayout
            ]
    in layers 
        [ h1 Config.title
        , container windowWidth windowHeight topRight (datetime currentTime)
        , dataDisplay
        ]

datetime : Time -> Element
datetime time = h2 
    <| format "%B %d, %Y at %H:%M:%S" 
    <| Date.fromTime time

