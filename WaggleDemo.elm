module WaggleDemo where

import Html (Html, text, ul)
import Signal
import Http
import Time (Time, every, second)
import Window
import Text (leftAligned, fromString, color, asText)
import Color (red)
import Graphics.Element (
    Element, 
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
    
currentSensorData : Signal (List (Maybe Sensor.SensorData))
currentSensorData = Http.sendGet currentSensorDataUrl |> Signal.map handleResponse

handleResponse : Http.Response String -> List (Maybe Sensor.SensorData)
handleResponse response = case response of
    Http.Success str -> Parse.parse str
    Http.Waiting -> []
    Http.Failure err msg -> []

-- view
view : (Int, Int) -> List (Maybe Sensor.SensorData) -> Element
view (windowWidth, windowHeight) data = 
    let 
        innerWidth = min 980 windowWidth
        sensorImage = image 306 406 "http://localhost:8000/assets/env-sense-annotated.png"
    in
        layers [
            container windowWidth windowHeight middle sensorImage,
            flow inward
                <| List.map (container windowWidth windowHeight middle)
                <| List.map (viewSensor windowWidth windowHeight) data
        ]

viewSensor : Int -> Int -> Maybe Sensor.SensorData -> Element
viewSensor windowWidth windowHeight maybeSensor = case maybeSensor of 
    Just sensor -> 
        let e = case sensor of
            Sensor.MLX90614ESF { temperature, timestamp, name } -> viewBasic temperature
            Sensor.TMP421 { temperature, timestamp, name } -> viewBasic temperature
            Sensor.BMP180 { temperature, pressure, timestamp, name } -> flow down
                <| List.map viewBasic [temperature, pressure]
            Sensor.MMA8452Q { acceleration, timestamp, name } -> viewPoint acceleration
            Sensor.PDV_P8104 { luminousIntensity, timestamp, name } -> viewBasic luminousIntensity
            Sensor.PR103J2 { temperature, timestamp, name } -> viewBasic temperature
            Sensor.HIH6130 { temperature, humidity, timestamp, name } -> flow right 
                <| List.map viewBasic [temperature, humidity]
            Sensor.SHT15 { temperature, humidity, timestamp, name } -> flow down
                <| List.map viewBasic [temperature, humidity]
            Sensor.HTU21D { temperature, humidity, timestamp, name } -> flow right 
                <| List.map viewBasic [temperature, humidity]
            Sensor.DS18B20 { temperature, timestamp, name } -> viewBasic temperature
            Sensor.RHT03 { temperature, humidity, timestamp, name } -> flow down
                <| List.map viewBasic [temperature, humidity]
            Sensor.TMP102 { temperature, timestamp, name } -> viewBasic temperature
            Sensor.SHT75 { temperature, humidity, timestamp, name } -> flow right 
                <| List.map viewBasic [temperature, humidity]
            Sensor.HIH4030 { humidity, timestamp, name } -> viewBasic humidity
            Sensor.GA1A1S201WP { luminousIntensity, timestamp, name } -> viewBasic luminousIntensity
            Sensor.MAX4466 { acousticIntensity, timestamp, name } -> viewBasic acousticIntensity
            Sensor.D6T44L06 { temperatures, timestamp, name } -> flow right 
                <| List.map viewBasic temperatures
            Sensor.HMC5883 { magneticField, timestamp, name } -> viewPoint magneticField
        in
            container windowWidth windowHeight (viewPos sensor) e
    Nothing -> leftAligned (fromString "Sensor data parse error.")

viewPos sensor = 
    let
        { w, h } = case sensor of
            Sensor.RHT03 _        -> { w = -0.09,  h = -0.25 }
            Sensor.TMP421 _       -> { w = 0.09,   h = 0.03 }
            Sensor.BMP180 _       -> { w = 0.12,   h = 0.1 }
            Sensor.MLX90614ESF _  -> { w = 0.09,   h = 0.17 }
            Sensor.SHT15 _        -> { w = -0.095, h = -0.15 }
            Sensor.PDV_P8104 _    -> { w = -0.11,  h = -0.065 }
            Sensor.HIH6130 _      -> { w = -0.117, h = 0.14 }
            Sensor.D6T44L06 _     -> { w = -0.455, h = 0.19 }
            Sensor.DS18B20 _      -> { w = 0.09,   h = -0.2 }
            _                     -> { w = 0,      h = 0 }
    in
        case side sensor of
            Left -> midRightAt (absolute 0) (absolute 0)
            Right -> midLeftAt (absolute 0) (absolute 0)

viewBasic : { value : String, units : String } -> Element
viewBasic { value, units } = leftAligned (fromString (value ++ " " ++ units))

side : Sensor.SensorData -> Side
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

viewPoint : { x : { value : String, units : String }, y : { value : String, units : String } } -> Element
viewPoint { x, y } = flow right [viewBasic x, viewBasic y]
