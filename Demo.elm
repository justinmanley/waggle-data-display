module Demo where

import Signal
import Http
import Time (Time, every, second)
import Window
import Text (Text, leftAligned, rightAligned, fromString, height, typeface, asText)
import Graphics.Element (
    Element, Position,
    flow, layers,
    image, container, empty,
    down, right, middle, inward,
    relative, absolute)
import List
import Maybe
import String
import Dict

import Waggle.Sensor (..)
import Waggle.Parse (parse)
--import Waggle.Layout (Side, side, pos, align)
import Waggle.Update (update)
import Chart
import Util (take, truncateFloat)

-- assets and data
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-annotated.png"

title = "EnvSense V1"

-- main
main : Signal Element
main = Signal.map2 view Window.dimensions sensorData

-- update
ticks : Signal Time
ticks = every (1 * second)
    
sensorData : Signal HistoricalData
sensorData = Http.sendGet (Signal.sampleOn ticks (Signal.constant sensorDataUrl)) 
    |> Signal.map handleResponse
    |> update

handleResponse : Http.Response String -> List Reading
handleResponse response = case response of
    Http.Success str -> parse str
    Http.Waiting -> []
    Http.Failure err msg -> []

-- view
view : (Int, Int) -> HistoricalData -> Element
view (windowWidth, windowHeight) data = flow down (List.map asText <| Dict.values data)