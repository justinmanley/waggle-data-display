module WaggleDemo where

import Html (Html, text, ul)
import Signal
import Http
import Time (Time, every, second)
import Window
import Text (leftAligned, rightAligned, fromString, color, asText)
import Color (red)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container,
    down, right, middle, outward, inward, middleAt, midTop,  midLeft, midRightAt, midLeftAt,
    relative, absolute)
import List
import Maybe

import Sensor
import Parse

type Side = Left | Right

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions currentSensorData

-- model
currentSensorDataUrl : Signal String
currentSensorDataUrl = Signal.sampleOn ticks (Signal.constant "http://localhost:8000/data/current/current")

-- update
ticks : Signal Time
ticks = every (1 * second)
    
currentSensorData : Signal (List (Maybe Sensor.Sensor))
currentSensorData = Http.sendGet currentSensorDataUrl |> Signal.map handleResponse

handleResponse : Http.Response String -> List (Maybe Sensor.Sensor)
handleResponse response = case response of
    Http.Success str -> Parse.parse str
    Http.Waiting -> []
    Http.Failure err msg -> []

-- view
view : (Int, Int) -> List (Maybe Sensor.Sensor) -> Element
view (windowWidth, windowHeight) data = 
    let 
        innerWidth = min 980 windowWidth
        (imageWidth, imageHeight) = (306, 406)
        sensorImage = image imageWidth imageHeight "http://localhost:8000/assets/env-sense-annotated.png"
    in
        layers [
            container windowWidth windowHeight middle sensorImage,
            flow inward
                <| List.map (container windowWidth windowHeight middle)
                <| List.map (viewSensor (windowWidth, windowHeight) (imageWidth, imageHeight)) data
        ]

viewSensor : (Int, Int) -> (Int, Int) -> Maybe Sensor.Sensor -> Element
viewSensor (windowWidth, windowHeight) imageDimensions maybeSensor = case maybeSensor of 
    Just sensor -> 
        let viewBasic' = viewBasic (side sensor)
            viewPoint' = viewPoint (side sensor)
            element = case sensor of
                Sensor.MLX90614ESF { temperature, timestamp, name } -> viewBasic' temperature
                Sensor.TMP421 { temperature, timestamp, name } -> viewBasic' temperature
                Sensor.BMP180 { temperature, pressure, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, pressure]
                Sensor.MMA8452Q { acceleration, timestamp, name } -> viewPoint' acceleration
                Sensor.PDV_P8104 { luminousIntensity, timestamp, name } -> viewBasic' luminousIntensity
                Sensor.PR103J2 { temperature, timestamp, name } -> viewBasic' temperature
                Sensor.HIH6130 { temperature, humidity, timestamp, name } -> flow down 
                    <| List.map viewBasic' [temperature, humidity]
                Sensor.SHT15 { temperature, humidity, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, humidity]
                Sensor.HTU21D { temperature, humidity, timestamp, name } -> flow right 
                    <| List.map viewBasic' [temperature, humidity]
                Sensor.DS18B20 { temperature, timestamp, name } -> viewBasic' temperature
                Sensor.RHT03 { temperature, humidity, timestamp, name } -> flow down
                    <| List.map viewBasic' [temperature, humidity]
                Sensor.TMP102 { temperature, timestamp, name } -> viewBasic' temperature
                Sensor.SHT75 { temperature, humidity, timestamp, name } -> flow right 
                    <| List.map viewBasic' [temperature, humidity]
                Sensor.HIH4030 { humidity, timestamp, name } -> viewBasic' humidity
                Sensor.GA1A1S201WP { luminousIntensity, timestamp, name } -> viewBasic' luminousIntensity
                Sensor.MAX4466 { acousticIntensity, timestamp, name } -> viewBasic' acousticIntensity
                Sensor.D6T44L06 { temperatures, timestamp, name } -> flow right 
                    <| List.map viewBasic' temperatures
                Sensor.HMC5883 { magneticField, timestamp, name } -> viewPoint' magneticField
        in
            container windowWidth windowHeight (viewPos (windowWidth, windowHeight) imageDimensions sensor) element
    Nothing -> leftAligned (fromString "Sensor data parse error.")

viewPos : (Int, Int) -> (Int, Int) -> Sensor.Sensor -> Position
viewPos (windowWidth, windowHeight) (imageWidth, imageHeight) sensor = 
    let
        gutter = 10
        midHeight = (windowHeight // 2)
        w = (windowWidth // 2) + (imageWidth // 2) + gutter
        h = case sensor of
            -- Left
            Sensor.RHT03 _        -> -180
            Sensor.SHT15 _        -> -130
            Sensor.PDV_P8104 _    -> -60
            Sensor.HIH4030 _      -> 35
            Sensor.HIH6130 _      -> 75
            Sensor.D6T44L06 _     -> 107
            Sensor.TMP102 _       -> 138
            Sensor.HMC5883 _      -> 195

            -- Right
            Sensor.DS18B20 _      -> -150
            Sensor.PR103J2 _      -> -95
            Sensor.GA1A1S201WP _  -> -65
            Sensor.SHT75 _        -> -35
            Sensor.TMP421 _       -> 10 
            Sensor.BMP180 _       -> 40
            Sensor.MLX90614ESF _  -> 95
            Sensor.HTU21D _       -> 130
            Sensor.MMA8452Q _     -> 195
            Sensor.MAX4466 _      -> -25
    in
        case side sensor of
            Left -> midRightAt (absolute w) (absolute <| midHeight + h)
            Right -> midLeftAt (absolute w) (absolute <| midHeight + h)

viewBasic : Side -> { value : String, units : String } -> Element
viewBasic side { value, units } = case side of
    Left -> rightAligned (fromString (value ++ " " ++ units))
    Right -> leftAligned (fromString (value ++ " " ++ units))

side : Sensor.Sensor -> Side
side sensor = case sensor of
    Sensor.MLX90614ESF _ -> Right
    Sensor.TMP421 _ -> Right
    Sensor.BMP180 _ -> Right
    Sensor.MMA8452Q _ -> Right
    Sensor.PDV_P8104 _ -> Left
    Sensor.PR103J2 _ -> Right
    Sensor.HIH6130 _ -> Left
    Sensor.SHT15 _ -> Left
    Sensor.HTU21D _ -> Right
    Sensor.DS18B20 _ -> Right
    Sensor.RHT03 _ -> Left
    Sensor.TMP102 _ -> Left
    Sensor.SHT75 _ -> Right
    Sensor.HIH4030 _ -> Left
    Sensor.GA1A1S201WP _ -> Right 
    Sensor.MAX4466 _ -> Left -- matching this with "SOUND" on the image
    Sensor.D6T44L06 _ -> Left
    Sensor.HMC5883 _ -> Left

viewPoint : Side 
    -> { x : { value : String, units : String }, y : { value : String, units : String } } 
    -> Element
viewPoint side { x, y } = flow right [viewBasic side x, viewBasic side y]
