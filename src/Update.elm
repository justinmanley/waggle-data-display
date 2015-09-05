module Update (update) where

import Dict
import List
import Time exposing (Time)

import QueueBuffer
import Sensor exposing (..)
import Config as Config

{-| Takes a new reading from the sensors and adds it to the collection of historical sensor data. -}
update : Signal (Time, List RawSensorSnapshot) -> Signal (Time, SensorBoard)
update signalData = 
    let
        addAll : (Time, List RawSensorSnapshot) -> (Time, SensorBoard) -> (Time, SensorBoard)
        addAll (time, currentSensors) (_, history) = let
                addValue : RawReading -> SensorHistory -> SensorHistory
                addValue value history = 
                    let empty = QueueBuffer.empty Config.historySize
                        val = { value - physicalQuantity | timestamp = time }
                        updateValue maybePrev = case maybePrev of
                            Just previous -> Just <| QueueBuffer.push val previous
                            Nothing -> Just <| QueueBuffer.push val empty
                    in Dict.update value.physicalQuantity updateValue history

                addCurrent : RawSensorSnapshot -> SensorBoard -> SensorBoard 
                addCurrent sensor history = 
                    let updateCurrent maybeSensorHistory = case maybeSensorHistory of
                        Just sensorHistory -> Just <| List.foldr addValue sensorHistory sensor.data
                        Nothing -> Just <| Dict.empty
                    in Dict.update sensor.id updateCurrent history 
            in
                (time, List.foldr addCurrent history currentSensors)

    in 
        Signal.foldp addAll (0, Dict.empty) signalData
