module WaggleDemo where

import Html (Html, text, ul)
import Signal
import Http
import Time (Time, every, second)
import Window
import Text (leftAligned, fromString, color, asText)
import Color (red)
import Graphics.Element (Element, flow, down, image, layers, container, middle)
import List

import Sensor
import Parse

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions (Signal.map Parse.parse currentSensorData)

-- model
currentSensorDataUrl : Signal String
currentSensorDataUrl = Signal.sampleOn ticks (Signal.constant "http://localhost:8000/data/current/current")

-- update
ticks : Signal Time
ticks = every (1 * second)
    
currentSensorData : Signal String
currentSensorData = Http.sendGet currentSensorDataUrl |> Signal.map handleResponse

handleResponse : Http.Response String -> String
handleResponse response = case response of
    Http.Success str -> str
    Http.Waiting -> "Loading..."
    Http.Failure err msg -> "Request failed."

-- view
view : (Int, Int) -> List (Maybe Sensor.SensorData) -> Element
view (windowWidth, windowHeight) data = 
    let 
        innerWidth = min 980 windowWidth
        sensorImage = image 306 406 "http://localhost:8000/assets/env-sense.jpg"
    in
        layers [
            container windowWidth windowHeight middle sensorImage,
            flow down <| List.map asText data
        ]