module Sensor where

import String
import Dict exposing (..)
import Time exposing (Time)
import QueueBuffer exposing (QueueBuffer)

type alias PhysicalQuantity = String
type alias SensorId = String

type alias SensorBoard = Dict SensorId SensorHistory
type alias SensorHistory = Dict PhysicalQuantity ReadingHistory 
type alias ReadingHistory = QueueBuffer Reading

{-| A snapshot of all the measurements reported by a sensor at a single moment. -}
type alias SensorSnapshot = InternalSensorSnapshot Reading

{-| Internal types. 
 - Only used in Parse.elm and Update.elm before values are timestamped. -}
type alias RawSensorSnapshot = InternalSensorSnapshot RawReading

type alias InternalSensorSnapshot reading =
    { id : String 
    , data : List reading }

{-| A sensor measurement. -}
type alias Reading = InternalReading { timestamp : Time }

{-| Internal types.
 -  Only used in Parse.elm and Update.elm before values are timestamped. -}
type alias RawReading = InternalReading { physicalQuantity : PhysicalQuantity }

type alias InternalReading a = { a 
    | value : Float
    , units : String }


