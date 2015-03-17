module Waggle.Sensor where

import String

type alias Value = { value : Float, units : String, physicalQuantity : String }
type alias Sensor = { timestamp : String, sensorId : String, data : List Value }