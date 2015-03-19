module Waggle.Parse where

import String
import Result (Result(..))
import List
import Maybe (Maybe(..), andThen, map)

import Waggle.Sensor (..)

{-| Parse the current list of sensors, as in data/current/current. -}
parse : String -> List Sensor
parse = let
        parseLine line sensors = case parseSensor line of
            Just sensor -> sensor :: sensors
            Nothing -> sensors
    in
        (List.foldr parseLine []) 
            << List.filter (not << String.isEmpty) 
            << String.lines

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
                mkSensor values = { id = sensorId, timestamp = timestamp, data = values }
            in
                map mkSensor vs
        _ -> Nothing

parseValue : String -> Maybe Value
parseValue s = case String.split ";" s of
    [physicalQuantity, value, units, extra] -> case String.toFloat value of
        Ok val -> Just {
            physicalQuantity = physicalQuantity ++ (case extra of
                "none" -> ""
                "non-standard" -> ""
                "Voltage_Divider_5V_PDV_Tap_4K7_GND" -> ""
                "Voltage_Divider_5V_NTC_Tap_68K_GN" -> ""
                "RH" -> ""
                "Barometric" -> ""
                "RMS_3Axis" -> ""
                _ -> extra
            ),
            value = val,
            units = units
        } 
        Err _ -> Nothing
    _ -> Nothing

