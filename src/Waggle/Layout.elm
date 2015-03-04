module Waggle.Layout where

import Graphics.Element (Element, Position, midRightAt, midLeftAt, absolute)
import Text (Text, leftAligned, rightAligned)

import Waggle.Sensor

type Side = Left | Right

align : Side -> (Text -> Element)
align side = case side of
    Left -> rightAligned
    Right -> leftAligned

pos : (Int, Int) -> (Int, Int) -> Waggle.Sensor.Sensor -> Position
pos (windowWidth, windowHeight) (imageWidth, imageHeight) sensor = 
    let
        aspectRatio = (toFloat imageWidth) / (toFloat imageHeight)
        gutter = 10
        midHeight = (windowHeight // 2)
        w = (windowWidth // 2) + (imageWidth // 2) + gutter
        h = case sensor of
            -- Left
            Waggle.Sensor.RHT03 _        -> -0.47
            Waggle.Sensor.SHT15 _        -> -0.3201
            Waggle.Sensor.PDV_P8104 _    -> -0.155
            Waggle.Sensor.MAX4466 _      -> -0.06
            Waggle.Sensor.HIH4030 _      -> 0.088
            Waggle.Sensor.HIH6130 _      -> 0.19
            Waggle.Sensor.D6T44L06 _     -> 0.2635
            Waggle.Sensor.TMP102 _       -> 0.339
            Waggle.Sensor.HMC5883 _      -> 0.47

            -- Right
            Waggle.Sensor.DS18B20 _      -> -0.385
            Waggle.Sensor.PR103J2 _      -> -0.2339
            Waggle.Sensor.GA1A1S201WP _  -> -0.175
            Waggle.Sensor.SHT75 _        -> -0.0862
            Waggle.Sensor.TMP421 _       -> 0.005
            Waggle.Sensor.BMP180 _       -> 0.0985
            Waggle.Sensor.MLX90614ESF _  -> 0.22
            Waggle.Sensor.HTU21D _       -> 0.3201
            Waggle.Sensor.MMA8452Q _     -> 0.47
    in
        case side sensor of
            Left -> midRightAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))
            Right -> midLeftAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))

side : Waggle.Sensor.Sensor -> Side
side sensor = case sensor of
    Waggle.Sensor.MLX90614ESF _ -> Right
    Waggle.Sensor.TMP421 _ -> Right
    Waggle.Sensor.BMP180 _ -> Right
    Waggle.Sensor.MMA8452Q _ -> Right
    Waggle.Sensor.PDV_P8104 _ -> Left
    Waggle.Sensor.PR103J2 _ -> Right
    Waggle.Sensor.HIH6130 _ -> Left
    Waggle.Sensor.SHT15 _ -> Left
    Waggle.Sensor.HTU21D _ -> Right
    Waggle.Sensor.DS18B20 _ -> Right
    Waggle.Sensor.RHT03 _ -> Left
    Waggle.Sensor.TMP102 _ -> Left
    Waggle.Sensor.SHT75 _ -> Right
    Waggle.Sensor.HIH4030 _ -> Left
    Waggle.Sensor.GA1A1S201WP _ -> Right 
    Waggle.Sensor.MAX4466 _ -> Left -- matching this with "SOUND" on the image
    Waggle.Sensor.D6T44L06 _ -> Left
    Waggle.Sensor.HMC5883 _ -> Left