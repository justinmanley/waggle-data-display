module Waggle.Layout where

import Graphics.Element (Element, Position, midRightAt, midLeftAt, absolute)
import Text (Text, leftAligned, rightAligned)

import Waggle.Sensor (..)

type Side = Left | Right

--align : Side -> (Text -> Element)
--align side = case side of
--    Left -> rightAligned
--    Right -> leftAligned

--pos : (Int, Int) -> (Int, Int) -> SensorType -> Position
--pos (windowWidth, windowHeight) (imageWidth, imageHeight) sensor = 
--    let
--        aspectRatio = (toFloat imageWidth) / (toFloat imageHeight)
--        gutter = 10
--        midHeight = (windowHeight // 2)
--        w = (windowWidth // 2) + (imageWidth // 2) + gutter
--        h = case sensor of
--            -- Left
--            RHT03         -> -0.47
--            SHT15         -> -0.3201
--            PDV_P8104      -> -0.155
--            MAX4466       -> -0.06
--            HIH4030       -> 0.088
--            HIH6130       -> 0.19
--            D6T44L06      -> 0.2635
--            TMP102        -> 0.339
--            HMC5883       -> 0.47

--            -- Right
--            DS18B20       -> -0.385
--            PR103J2       -> -0.2339
--            GA1A1S201WP   -> -0.175
--            SHT75         -> -0.0862
--            TMP421        -> 0.005
--            BMP180        -> 0.0985
--            MLX90614ESF   -> 0.22
--            HTU21D        -> 0.3201
--            MMA8452Q      -> 0.47
--    in
--        case side sensor of
--            Left -> midRightAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))
--            Right -> midLeftAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))

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