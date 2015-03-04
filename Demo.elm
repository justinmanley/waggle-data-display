module Demo where

import Signal
import Http
import Time (Time, every, second)
import Window
import Text (Text, leftAligned, rightAligned, fromString, height, typeface)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container,
    down, right, middle, inward,
    relative, absolute)
import List
import Maybe
import String

import Waggle.Sensor (..)
import Waggle.Parse
import Waggle.Layout (Side, side, pos, align)
import Chart
import Util (take)

-- assets and data
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-annotated.png"

title = "The Waggle Platform"

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions (take 60 <| currentSensorData)

-- update
ticks : Signal Time
ticks = every (1 * second)
    
currentSensorData : Signal (List (Maybe Sensor))
currentSensorData = Http.sendGet (Signal.sampleOn ticks (Signal.constant sensorDataUrl)) 
    |> Signal.map handleResponse

handleResponse : Http.Response String -> List (Maybe Sensor)
handleResponse response = case response of
    Http.Success str -> Waggle.Parse.parse str
    Http.Waiting -> []
    Http.Failure err msg -> []

-- view
view : (Int, Int) -> List (List (Maybe Sensor)) -> Element
view (windowWidth, windowHeight) data = 
    let 
        innerWidth = min 980 windowWidth
        (imageWidth, imageHeight) = (459, 609)
        sensorImage = image imageWidth imageHeight sensorImageUrl
        pageTitle = leftAligned 
            <| height 40 
            <| typeface ["EB Garamond", "serif"]
            <| fromString title
    in
        layers [
            pageTitle,
            container windowWidth windowHeight middle sensorImage,
            flow inward
                <| List.map (container windowWidth windowHeight middle)
                <| List.map (viewSensor (windowWidth, windowHeight) (imageWidth, imageHeight)) (case data of
                    [] -> [] 
                    x :: _ -> x
                {- end case -})
        ]

viewSensor : (Int, Int) -> (Int, Int) -> Maybe Sensor -> Element
viewSensor (windowWidth, windowHeight) imageDimensions maybeSensor = case maybeSensor of 
    Just sensor -> 
        let viewBasic' = viewBasic (side sensor)
            viewPoint' = viewPoint (side sensor)
            element = case sensor of
                MLX90614ESF { temperature, timestamp, name } -> viewBasic' temperature
                TMP421 { temperature, timestamp, name } -> viewBasic' temperature
                BMP180 { temperature, pressure, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, pressure]
                MMA8452Q { acceleration, timestamp, name } -> viewPoint' acceleration
                PDV_P8104 { luminousIntensity, timestamp, name } -> viewBasic' luminousIntensity
                PR103J2 { temperature, timestamp, name } -> viewBasic' temperature
                HIH6130 { temperature, humidity, timestamp, name } -> flow down 
                    <| List.map viewBasic' [temperature, humidity]
                SHT15 { temperature, humidity, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, humidity]
                HTU21D { temperature, humidity, timestamp, name } -> flow down 
                    <| List.map viewBasic' [temperature, humidity]
                DS18B20 { temperature, timestamp, name } -> viewBasic' temperature
                RHT03 { temperature, humidity, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, humidity]
                TMP102 { temperature, timestamp, name } -> viewBasic' temperature
                SHT75 { temperature, humidity, timestamp, name } -> flow down 
                    <| List.map viewBasic' [temperature, humidity]
                HIH4030 { humidity, timestamp, name } -> viewBasic' humidity
                GA1A1S201WP { luminousIntensity, timestamp, name } -> viewBasic' luminousIntensity
                MAX4466 { acousticIntensity, timestamp, name } -> viewBasic' acousticIntensity
                D6T44L06 { temperatures, timestamp, name } -> flow right 
                    <| List.map viewBasic' temperatures
                HMC5883 { magneticField, timestamp, name } -> viewPoint' magneticField
        in
            container windowWidth windowHeight (pos (windowWidth, windowHeight) imageDimensions sensor) element
    Nothing -> leftAligned (fromString "Sensor data parse error.")

viewBasic : Side -> Value -> Element
viewBasic side { value, units } = (align side)
        <| (height 26 <| typeface ["EB Garamond", "serif"] <| fromString (toString value ++ " ")) ++ (viewUnits units)

viewUnits : String -> Text
viewUnits units = height 14
    <| typeface ["EB Garamond", "serif"] 
    <| fromString (case units of
        "C" -> "&deg; C"
        "F" -> "&deg; F"
        _   -> units
        {- end case -})

viewPoint : Side -> { x : Value, y : Value } -> Element
viewPoint side { x, y } = flow down [viewBasic side x, viewBasic side y]
