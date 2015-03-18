module Waggle.Sensor where

import String
import Dict (..)
import Time (Time)
import QueueBuffer (QueueBuffer)

type alias SensorId = String
type alias ValueHistory = QueueBuffer (Time, Float)
type alias SensorHistory = Dict String ValueHistory
type alias HistoricalData = Dict SensorId SensorHistory

type alias Value = { 
    value : Float, 
    units : String, 
    physicalQuantity : String 
}

type alias Reading = { 
    timestamp : String, 
    id : String, 
    data : List Value 
}