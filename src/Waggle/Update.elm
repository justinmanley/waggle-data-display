module Waggle.Update where

import Dict
import List
import Maybe
import Signal

import Waggle.Sensor (..)

update : Signal (List Reading) -> Signal HistoricalData
update currentSensorData = 
    let
        addValue : Value -> SensorHistory -> SensorHistory
        addValue value history = 
            let updateValue maybePrev = case maybePrev of
                Just previous -> Just <| value.value :: previous
                Nothing -> Just <| value.value :: []
            in Dict.update value.physicalQuantity updateValue history

        addCurrent : Reading -> HistoricalData -> HistoricalData 
        addCurrent sensor history = 
            let updateCurrent maybeSensorHistory = case maybeSensorHistory of
                Just sensorHistory -> Just <| List.foldr addValue sensorHistory sensor.data
                Nothing -> Just <| Dict.empty
            in Dict.update sensor.id updateCurrent history 

        addAll : List Reading -> HistoricalData -> HistoricalData
        addAll current history = List.foldr addCurrent history current

    in 
        Signal.foldp addAll Dict.empty currentSensorData