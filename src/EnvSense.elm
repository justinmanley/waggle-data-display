module EnvSense where

import Graphics.Element (Element, Position, midRight, midLeft, absolute, container, flow, down, bottomLeft, right, empty)
import Text (Text, leftAligned, rightAligned, plainText)
import Maybe
import Dict
import List

import Util
import QueueBuffer
import Waggle.Sensor (..)
import Waggle.Config (sensor, value, em)
import Waggle.View (Side(Left, Right), valueContainer)

{-| Identifies each sensor with its image on the sensor board. -}
pointerStart : SensorId -> (Float, Float)
pointerStart sensorId = case sensorId of
    "MLX90614ESF-DAA.Melexis.008-2013"      -> (35, -187)
    "TMP421.Texas_Instruments.2012"         -> (35, -65)
    "BMP180.Bosch.2_5-2013"                 -> (18, -105)
    "MMA8452Q.Freescale.8_1-2013"           -> (45, -280)
    "Thermistor_NTC_PR103J2.US_Sensor.2003" -> (-10, 80)
    "HTU21D.MeasSpec.2013"                  -> (42, -235)
    "DS18B20.Maxim.2008"                    -> (50, 155)
    "SHT75.Sensirion.5_2011"                -> (45, -10)
    "GA1A1S201WP.Sharp.2007"                -> (45, 40)

    "PDV_P8104.API.2006"                    -> (-32, 35)
    "HIH4030.Honeywell.2008"                -> (-23, -102)
    "SHT15.Sensirion.4_3-2010"              -> (-28, 117)
    "RHT03.Maxdetect.2011"                  -> (-10, 210)
    "TMP102.Texas_Instruments.2008"         -> (-23, -240)
    "MAX4466.Maxim.2001"                    -> (-32, -20) -- sound
    "D6T-44L-06.Omron.2012"                 -> (-65, -160)
    "HMC5883.Honeywell.2013"                -> (-45, -280)
    "HIH6130.Honeywell.2011"                -> (-23, -160)

    _                                       -> (0, 0)

index : SensorId -> Int
index sensorId = case sensorId of
    "MLX90614ESF-DAA.Melexis.008-2013"      -> 7
    "TMP421.Texas_Instruments.2012"         -> 5
    "BMP180.Bosch.2_5-2013"                 -> 6
    "MMA8452Q.Freescale.8_1-2013"           -> 9
    "Thermistor_NTC_PR103J2.US_Sensor.2003" -> 2
    "HTU21D.MeasSpec.2013"                  -> 8
    "DS18B20.Maxim.2008"                    -> 1
    "SHT75.Sensirion.5_2011"                -> 4
    "GA1A1S201WP.Sharp.2007"                -> 3

    "PDV_P8104.API.2006"                    -> 3
    "HIH4030.Honeywell.2008"                -> 5
    "SHT15.Sensirion.4_3-2010"              -> 2
    "RHT03.Maxdetect.2011"                  -> 1
    "TMP102.Texas_Instruments.2008"         -> 8
    "MAX4466.Maxim.2001"                    -> 4
    "D6T-44L-06.Omron.2012"                 -> 7
    "HMC5883.Honeywell.2013"                -> 9
    "HIH6130.Honeywell.2011"                -> 6

    _                                       -> 0

order : SensorId -> SensorId -> Order
order s1 s2 = compare (index s1) (index s2) 

name : SensorId -> String
name sensorId = case sensorId of
    "MLX90614ESF-DAA.Melexis.008-2013"      -> "MLX90614ESF"
    "TMP421.Texas_Instruments.2012"         -> "TMP421"
    "BMP180.Bosch.2_5-2013"                 -> "BMP180"
    "MMA8452Q.Freescale.8_1-2013"           -> "MMA8452Q"
    "Thermistor_NTC_PR103J2.US_Sensor.2003" -> "PR103J2"
    "HTU21D.MeasSpec.2013"                  -> "HTU21D"
    "DS18B20.Maxim.2008"                    -> "DS18B20"
    "SHT75.Sensirion.5_2011"                -> "SHT75"
    "GA1A1S201WP.Sharp.2007"                -> "GA1A1S201WP"

    "PDV_P8104.API.2006"                    -> "PDVP8104"
    "HIH4030.Honeywell.2008"                -> "HIH4030"
    "SHT15.Sensirion.4_3-2010"              -> "SHT15"
    "RHT03.Maxdetect.2011"                  -> "RHT03"
    "TMP102.Texas_Instruments.2008"         -> "TMP102"
    "MAX4466.Maxim.2001"                    -> "MAX4466"
    "D6T-44L-06.Omron.2012"                 -> "D6T44L06"
    "HMC5883.Honeywell.2013"                -> "HMC5883"
    "HIH6130.Honeywell.2011"                -> "HIH6130"

    _                                       -> "Error: " ++ sensorId ++ " not recognized."  

side : SensorId -> Side
side sensorId = case sensorId of
    "MLX90614ESF-DAA.Melexis.008-2013"      -> Right
    "TMP421.Texas_Instruments.2012"         -> Right
    "BMP180.Bosch.2_5-2013"                 -> Right
    "MMA8452Q.Freescale.8_1-2013"           -> Right
    "Thermistor_NTC_PR103J2.US_Sensor.2003" -> Right
    "HTU21D.MeasSpec.2013"                  -> Right
    "DS18B20.Maxim.2008"                    -> Right
    "SHT75.Sensirion.5_2011"                -> Right
    "GA1A1S201WP.Sharp.2007"                -> Right

    "PDV_P8104.API.2006"                    -> Left
    "HIH4030.Honeywell.2008"                -> Left
    "SHT15.Sensirion.4_3-2010"              -> Left
    "RHT03.Maxdetect.2011"                  -> Left
    "TMP102.Texas_Instruments.2008"         -> Left
    "MAX4466.Maxim.2001"                    -> Left
    "D6T-44L-06.Omron.2012"                 -> Left
    "HMC5883.Honeywell.2013"                -> Left
    "HIH6130.Honeywell.2011"                -> Left 

    _                                       -> Left

viewXYZ : String -> SensorId -> SensorHistory -> Element
viewXYZ prefix sensorId history = 
    let component suffix = 
            let measurement : String -- necessary in order to avoid compiler error (see https://github.com/elm-lang/elm-compiler/issues/880).
                measurement = prefix ++ suffix
            in Dict.get measurement history
                |> Maybe.withDefault (QueueBuffer.empty 0)
                |> QueueBuffer.mapLast (.value >> Util.truncateFloat 2 >> toString) ""     
        x = component "X"
        y = component "Y"
        z = component "Z"

        thirds = container (round <| toFloat value.width / 3) em bottomLeft
        
        combined = List.map (thirds << plainText) ["X: " ++ x ++ " ", "Y: " ++ y ++ " ", "Z: " ++ z]
    in valueContainer <| flow right combined

viewAcceleration = viewXYZ "Acceleration"
viewMagneticField = viewXYZ "MagneticField"

viewInfraRedCamera : SensorId -> SensorHistory -> Element
viewInfraRedCamera sensorId history = 
    let casing = "TemperaturePTAT"
        mkCasingTmp = toString >> ((++) "Casing Temperature: ") >> plainText 
        casingTemperature = Dict.get casing history
            |> Maybe.withDefault (QueueBuffer.empty 0)
            |> QueueBuffer.mapLast (.value >> Util.truncateFloat 2 >> mkCasingTmp) empty
    
        values = Dict.values (Dict.remove casing history)

        calculateAverage values = case values of
            v :: vs -> 
                let maybeAdd a b = case a of { Just a' -> Maybe.map ((+) a') b; Nothing -> Nothing }
                in Maybe.map (flip (/) (toFloat <| List.length values))
                    (List.foldr (QueueBuffer.last >> Maybe.map .value >> maybeAdd) (Just 0) values)
            [] -> Nothing
        averageTemperature = case calculateAverage values of
            Just average -> "Average Temperature: " ++ (average |> Util.truncateFloat 2 >> toString) 
                |> plainText
            Nothing -> empty

    in valueContainer <| flow down [casingTemperature, averageTemperature]