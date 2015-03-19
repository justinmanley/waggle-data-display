module Waggle.Sensor where

import String
import Dict (..)
import Time (Time)
import QueueBuffer (QueueBuffer)

type alias PhysicalQuantity = String
type alias SensorId = String

type alias SensorBoard = Dict SensorId SensorHistory
type alias SensorHistory = Dict String ValueHistory
type alias ValueHistory = QueueBuffer (Time, Float)

type alias Value = { 
    value : Float, 
    units : String, 
    physicalQuantity : PhysicalQuantity 
}

type alias Sensor = { 
    timestamp : String, 
    id : String, 
    data : List Value 
}