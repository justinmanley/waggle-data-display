module Waggle.Update (sensorData) where

import Dict
import List
import Maybe
import Signal
import Time
import Time (Time, every)
import Http

import QueueBuffer
import Waggle.Sensor (..)
import Waggle.Config (historySize, sensorDataUrl, updateInterval)
import Waggle.Parse (parse)

{-| Takes a new reading from the sensors and adds it to the collection of historical sensor data. -}
update : Signal (Time, List InternalSensor) -> Signal (Time, SensorBoard)
update signalData = 
    let
        addAll : (Time, List InternalSensor) -> (Time, SensorBoard) -> (Time, SensorBoard)
        addAll (time, currentSensors) (_, history) = let
                addValue : InternalValue {} -> SensorHistory -> SensorHistory
                addValue value history = 
                    let empty = QueueBuffer.empty historySize
                        val = { value | timestamp = time }
                        updateValue maybePrev = case maybePrev of
                            Just previous -> Just <| QueueBuffer.push val previous
                            Nothing -> Just <| QueueBuffer.push val empty
                    in Dict.update value.physicalQuantity updateValue history

                addCurrent : InternalSensor -> SensorBoard -> SensorBoard 
                addCurrent sensor history = 
                    let updateCurrent maybeSensorHistory = case maybeSensorHistory of
                        Just sensorHistory -> Just <| List.foldr addValue sensorHistory sensor.data
                        Nothing -> Just <| Dict.empty
                    in Dict.update sensor.id updateCurrent history 
            in
                (time, List.foldr addCurrent history currentSensors)

    in 
        Signal.foldp addAll (0, Dict.empty) signalData

ticks : Signal Time
ticks = every updateInterval
    
sensorData : Signal (Time, SensorBoard)
sensorData = Http.sendGet (Signal.sampleOn ticks (Signal.constant sensorDataUrl)) 
    |> Signal.map handleResponse
    |> (Time.timestamp >> update)

handleResponse : Http.Response String -> List InternalSensor
handleResponse response = case response of
    Http.Success str -> parse str
    Http.Waiting -> []
    Http.Failure err msg -> []