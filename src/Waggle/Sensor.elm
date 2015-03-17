module Waggle.Sensor where

import String
import Dict (..)
import Time (Time)

type alias SensorId = String
type alias SensorHistory = Dict String (List Float)
type alias HistoricalData = Dict SensorId SensorHistory

type alias Value = { value : Float, units : String, physicalQuantity : String }
type alias Reading = { timestamp : String, id : String, data : List Value }