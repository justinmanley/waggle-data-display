module Parse where

import String
import Result (toMaybe)
import List (head, drop, map, filter)
import Debug (log)

import Sensor (..)

parse = map parseSensor << filter (not << String.isEmpty) << String.lines

parseSensor : String -> Maybe Sensor
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
                acceleration = parseCompoundDataPoint (data |> get 2) (data |> get 3) 
            }
        "Thermistor_NTC_PR103J2.US_Sensor.2003" ->
            Just <| PR103J2 { basic | 
                temperature = data |> get 2 |> parseSimpleDataPoint 
            }
        "HIH6130.Honeywell.2011" -> 
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| HIH6130 { temp | 
                humidity = data |> get 3 |> parseSimpleDataPoint 
            }
        "GA1A1S201WP.Sharp.2007" -> 
            Just <| GA1A1S201WP { basic | 
                luminousIntensity = data |> get 2 |> parseSimpleDataPoint
            }
        "MAX4466.Maxim.2001" -> 
            Just <| MAX4466 { basic | 
                acousticIntensity = data |> get 2 |> parseSimpleDataPoint
            }
        "D6T-44L-06.Omron.2012" ->
            Just <| D6T44L06 { basic | 
                temperatures = map parseSimpleDataPoint (drop 2 data)
            }
        "HMC5883.Honeywell.2013" -> 
            Just <| HMC5883 { basic | 
                magneticField = parseCompoundDataPoint (data |> get 2) (data |> get 3)
            }
        "SHT15.Sensirion.4_3-2010" ->
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| SHT15 { temp | 
                humidity = data |> get 3 |> parseSimpleDataPoint
            }
        "HTU21D.MeasSpec.2013" ->
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| HTU21D { temp | 
                humidity = data |> get 3 |> parseSimpleDataPoint
            }
        "DS18B20.Maxim.2008" ->
            Just <| DS18B20 { basic | 
                temperature = data |> get 2 |> parseSimpleDataPoint
            }
        "RHT03.Maxdetect.2011" ->
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| RHT03 { temp | 
                humidity = data |> get 3 |> parseSimpleDataPoint
            }
        "TMP102.Texas_Instruments.2008" ->
            Just <| TMP102 { basic | 
                temperature = data |> get 2 |> parseSimpleDataPoint
            }
        "SHT75.Sensirion.5_2011" -> 
            let temp = { basic | temperature = data |> get 2 |> parseSimpleDataPoint }
            in Just <| SHT75 { temp | 
                humidity = data |> get 3 |> parseSimpleDataPoint
            }
        "HIH4030.Honeywell.2008" ->
            Just <| HIH4030 { basic | 
                humidity = data |> get 2 |> parseSimpleDataPoint
            }     
        _ -> Nothing

parseBasicSensor : List String -> { name : String, timestamp : String }
parseBasicSensor data = { name = data |> get 0, timestamp = data |> get 1 }

parseSimpleDataPoint : String -> { value : String, units : String }
parseSimpleDataPoint s =
    let data = String.split ";" s
    in 
        { value = data |> get 1,
          units = data |> get 2 }

parseCompoundDataPoint : String 
    -> String 
    -> { x : { value : String, units : String }, y : { value : String, units : String } }
parseCompoundDataPoint x y = 
    let xs = String.split ";" x
        ys = String.split ";" y
    in
        { 
            x = { 
                value = xs |> get 1,
                units = xs |> get 2
            },
            y = {
                value = ys |> get 1,
                units = ys |> get 2
            }
        }

-- | Get the nth element of a 0-based list
get : Int -> List a -> a
get n = head << (drop n)
