module Parse where

import String
import Result (toMaybe)
import List (head, drop, map)

import Sensor (..)

parse = map parseSensor << String.lines
-- (List.map (split ",") << lines)

parseSensor : String -> Maybe SensorData
parseSensor s =
    let dataPoints = String.split "," <| s
    in case head dataPoints of
        "MLX90614ESF-DAA.Melexis.008-2013" ->
            Just <| MLX90614ESF { 
                name = dataPoints |> get 0, 
                timestamp = dataPoints |> get 1,
                temperature = dataPoints |> get 2 |> parseTemperature
            }
        "TMP421.Texas_Instruments.2012" ->
            Just <| TMP421 {
                name = dataPoints |> get 0, 
                timestamp = dataPoints |> get 1,
                temperature = dataPoints |> get 2 |> parseTemperature
            }
        "PDV_P8104.API.2006" ->
            Just <| PDV_P8104 {
                name = dataPoints |> get 0,
                timestamp = dataPoints |> get 1,
                luminousIntensity = dataPoints |> get 2 |> parseLuminousIntensity
            }
        _ -> Nothing

parseTemperature : String -> Temperature
parseTemperature s = 
    let temperatureData = String.split ";" s
    in
        { 
            value = temperatureData |> get 1 |> String.toFloat |> toMaybe, 
            units = temperatureData |> get 2 
        }

parseLuminousIntensity : String -> LuminousIntensity
parseLuminousIntensity s =
    let temperatureData = String.split ";" s
    in
        {
            value = temperatureData |> get 1 |> String.toFloat |> toMaybe,
            units = temperatureData |> get 2
        }

-- | Get the nth element of a 0-based list
get : Int -> List a -> a
get n = head << (drop n)


