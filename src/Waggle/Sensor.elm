module Waggle.Sensor where

import String
import Dict (..)
import Time (Time)
import QueueBuffer (QueueBuffer)

type alias SensorId = String
type alias SensorHistory = Dict String (QueueBuffer (Time, Float))
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