module Waggle.Update where

import Dict
import List
import Maybe
import Signal
import Time
import Time (Time, every, second)
import Http

import QueueBuffer
import Waggle.Sensor (..)
import Waggle.Config (historySize, sensorDataUrl)
import Waggle.Parse (parse)

update : Signal (Time, List Reading) -> Signal HistoricalData
update currentSensorData = 
    let
        addAll : (Time, List Reading) -> HistoricalData -> HistoricalData
        addAll (time, current) history = let
                addValue : Value -> SensorHistory -> SensorHistory
                addValue value history = 
                    let empty = QueueBuffer.empty historySize
                        val = (time, value.value)
                        updateValue maybePrev = case maybePrev of
                            Just previous -> Just <| QueueBuffer.push val previous
                            Nothing -> Just <| QueueBuffer.push val empty
                    in Dict.update value.physicalQuantity updateValue history

                addCurrent : Reading -> HistoricalData -> HistoricalData 
                addCurrent sensor history = 
                    let updateCurrent maybeSensorHistory = case maybeSensorHistory of
                        Just sensorHistory -> Just <| List.foldr addValue sensorHistory sensor.data
                        Nothing -> Just <| Dict.empty
                    in Dict.update sensor.id updateCurrent history 
            in
                List.foldr addCurrent history current

    in 
        Signal.foldp addAll Dict.empty currentSensorData

ticks : Signal Time
ticks = every (1 * second)
    
sensorData : Signal HistoricalData
sensorData = Http.sendGet (Signal.sampleOn ticks (Signal.constant sensorDataUrl)) 
    |> Signal.map handleResponse
    |> (Time.timestamp >> update)

handleResponse : Http.Response String -> List Reading
handleResponse response = case response of
    Http.Success str -> parse str
    Http.Waiting -> []
    Http.Failure err msg -> []