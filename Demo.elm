module Demo where

import Signal
import Http
import Time (Time, every, second)
import Window
import Text (Text, leftAligned, rightAligned, fromString, height, typeface)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty,
    down, right, middle, inward,
    relative, absolute,
    link)
import List
import Maybe
import String

import Waggle.Sensor (..)
import Waggle.Parse
import Waggle.Layout (Side, side, pos, align)
import Chart
import Util (take, truncateFloat)

{- Configuration -}

-- Assets and data url
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-annotated.png"

-- Content for the banner at the top of the page.
title = "EnvSense V1"
secondary = [{- Any strings added to this list will be displayed below the title. -}]

{- End configuration -}

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
        (imageWidth, imageHeight) = (441, 586)
        sensorImage = image imageWidth imageHeight sensorImageUrl
        banner = flow down 
            ((leftAligned 
                <| height 40 
                <| typeface ["EB Garamond", "serif"]
                <| fromString title) :: 
            (List.map 
                (leftAligned 
                    << height 20 
                    << typeface ["EB Garamond", "serif"] 
                    << fromString) 
                secondary))
    in
        layers [
            banner,
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
        let viewBasic' = viewBasic (side <| sensorType sensor)
            viewPoint' = viewPoint (side <| sensorType sensor)
            element = sensorInfo (sensorType sensor) <| case sensor of
                TemperatureSensor { temperature } -> viewBasic' temperature
                HumiditySensor { humidity } -> viewBasic' humidity
                TemperatureHumiditySensor { temperature, humidity } -> flow right 
                    <| List.map viewBasic' [ temperature, humidity ]
                LuminousIntensitySensor { luminousIntensity } -> viewBasic' luminousIntensity 
                InfraredCamera { temperatures } -> viewInfraredCamera (side <| sensorType sensor) temperatures
                MagneticFieldSensor { magneticField } -> viewPoint' magneticField
                AcousticIntensitySensor { acousticIntensity } -> viewBasic' acousticIntensity 
                TemperaturePressureSensor { temperature, pressure } -> flow right
                    <| List.map viewBasic' [ temperature, pressure]
                AccelerationSensor { acceleration, vibration } -> flow right [viewPoint' acceleration, viewBasic' vibration]                       
        in
            container windowWidth windowHeight (pos (windowWidth, windowHeight) imageDimensions (sensorType sensor)) element
    Nothing -> leftAligned (fromString "") {- Don't show anything if there's a parse error. -}

viewBasic : Side -> Value -> Element
viewBasic side { value, units } = (align side)
        <| (height 26 <| typeface ["EB Garamond", "serif"] <| fromString (toString value)) ++ (viewUnits units) ++ fromString "  "

viewInfraredCamera : Side -> List Temperature -> Element
viewInfraredCamera side temperatures = case temperatures of
    [] -> empty
    casing :: rest -> case rest of
        [] -> viewBasic side casing
        t :: ts ->
            let { units, value } = t
            in flow right [
                viewBasic side casing,
                leftAligned (fromString "  "),
                viewBasic side { 
                    value = truncateFloat 2 <| (List.foldr (+) t.value (List.map .value ts)) / (toFloat <| List.length rest),
                    units = units 
                }
            ]

viewUnits : String -> Text
viewUnits units = height 14
    <| typeface ["EB Garamond", "serif"] 
    <| fromString (case units of
        "C" -> "&deg; C"
        "F" -> "&deg; F"
        _   -> units
        {- end case -})

viewPoint : Side -> { x : Value, y : Value, z : Value } -> Element
viewPoint side { x, y, z } = flow right [viewBasic side x, viewBasic side y, viewBasic side z]

sensorInfo : SensorType -> Element -> Element
sensorInfo sensorType = link ("./assets/SensorDataSheets/" ++ toString sensorType ++ ".pdf")