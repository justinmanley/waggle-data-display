module Parse where

import String
import Result (toMaybe)
import List (head, drop, map)

import Sensor (..)

parse = map parseSensor << String.lines

parseSensor : String -> Maybe SensorData
parseSensor s =
    let data = String.split "," s
        basic = parseBasicSensor data
    in case head data of
        "MLX90614ESF-DAA.Melexis.008-2013" ->
            Just <| MLX90614ESF { basic | 
                temperature = data |> get 2 |> parseSimpleDataPoint 
            }
        "TMP421.Texas_Instruments.2012" ->
            Just <| TMP421 { basic | 
                temperature = data |> get 2 |> parseSimpleDataPoint 
            }
        "PDV_P8104.API.2006" ->
            Just <| PDV_P8104 { basic |
                luminousIntensity = data |> get 2 |> parseSimpleDataPoint 
            }
        "BMP180.Bosch.2_5-2013" -> 
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| BMP180 { 
                temp | pressure = data |> get 3 |> parseSimpleDataPoint 
            }
        "MMA8452Q.Freescale.8_1-2013" ->
            Just <| MMA8452Q { basic | 
                acceleration = parseAcceleration (data |> get 2) (data |> get 3) 
            }
        "Thermistor_NTC_PR103J2.US_Sensor.2003" ->
            Just <| PR103J2 { 
                basic | temperature = data |> get 2 |> parseSimpleDataPoint 
            }
        "HIH6130.Honeywell.2011" -> 
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| HIH6130 { 
                temp | humidity = data |> get 3 |> parseSimpleDataPoint 
            }
        _ -> Nothing

parseBasicSensor : List String -> { name : String, timestamp : String }
parseBasicSensor d = { name = "hi", timestamp = "yo" }

parseSimpleDataPoint : String -> { value : Maybe Float, units : String }
parseSimpleDataPoint s =
    let data = String.split ";" s
    in 
        { value = data |> get 1 |> String.toFloat |> toMaybe,
          units = data |> get 2 }

parseAcceleration : String -> String -> { x : Acceleration, y : Acceleration }
parseAcceleration x y = 
    let accelerationX = String.split ";" x
        accelerationY = String.split ";" y
    in
        { 
            x = { 
                value = accelerationX |> get 1 |> String.toFloat |> toMaybe,
                units = accelerationX |> get 2
            },
            y = {
                value = accelerationY |> get 1 |> String.toFloat |> toMaybe,
                units = accelerationY |> get 2
            }
        }

-- | Get the nth element of a 0-based list
get : Int -> List a -> a
get n = head << (drop n)
