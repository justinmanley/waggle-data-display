module Waggle.Parse where

import String
import Result (Result(..))
import List
import Maybe (Maybe(..), andThen, map)

import Waggle.Sensor (..)

{-| Parse the current list of sensors, as in data/current/current. -}
--parse : String -> List (Maybe Sensor)
--parse = List.map parseSensor << List.filter (not << String.isEmpty) << String.lines

{-| Parse a single line as a sensor.
 -  If the parse fails at any time, returns Nothing; otherwise, returns (Just sensor). 
 -}
parseSensor : String -> Maybe Sensor
parseSensor s =
    let data = String.split "," s
    in case data of
        sensorId :: timestamp :: values -> 
            let 
                combine str maybeState = case parseValue str of
                    Just val -> map ((::) val) maybeState
                    Nothing -> Nothing
                vs = List.foldr combine (Just []) values
                mkSensor values = { sensorId = sensorId, timestamp = timestamp, data = values }
            in
                map mkSensor vs
        _ -> Nothing

parseValue : String -> Maybe Value
parseValue s = case String.split ";" s of
    [physicalQuantity, value, units, extra] -> case String.toFloat value of
        Ok val -> Just {
            physicalQuantity = physicalQuantity ++ (if extra == "none" then "" else extra),
            value = val,
            units = units
        } 
        Err _ -> Nothing
    _ -> Nothing

