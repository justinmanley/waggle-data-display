module DataPortal where

import Html (..)
import Signal
import Http

-- model
currentSensorDataUrl = "http://localhost:8000/data/current/current"

currentSensorData : Signal String
currentSensorData = Http.sendGet (Signal.constant currentSensorDataUrl) |> Signal.map handleResponse 

handleResponse response = case response of
    Http.Success str -> str
    _ -> ""

-- view
main : Signal Html
main = Signal.map text currentSensorData

