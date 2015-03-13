module Waggle.Layout where

import Graphics.Element (Element, Position, midRightAt, midLeftAt, absolute)
import Text (Text, leftAligned, rightAligned)

import Waggle.Sensor (..)

type Side = Left | Right

align : Side -> (Text -> Element)
align side = case side of
    Left -> rightAligned
    Right -> leftAligned

pos : (Int, Int) -> (Int, Int) -> SensorType -> Position
pos (windowWidth, windowHeight) (imageWidth, imageHeight) sensor = 
    let
        aspectRatio = (toFloat imageWidth) / (toFloat imageHeight)
        gutter = 10
        midHeight = (windowHeight // 2)
        w = (windowWidth // 2) + (imageWidth // 2) + gutter
        h = case sensor of
            -- Left
            RHT03          -> -0.47
            SHT15          -> -0.3201
            PDVP8104       -> -0.155
            MAX4466        -> -0.06
            HIH4030        -> 0.088
            HIH6130        -> 0.19
            D6T44L06       -> 0.2635
            TMP102         -> 0.339
            HMC5883        -> 0.47

            -- Right
            DS18B20        -> -0.385
            PR103J2        -> -0.2339
            GA1A1S201WP    -> -0.175
            SHT75          -> -0.0862
            TMP421         -> 0.005
            BMP180         -> 0.0985
            MLX90614ESFDAA -> 0.22
            HTU21D         -> 0.3201
            MMA8452Q       -> 0.47
    in
        case side sensor of
            Left -> midRightAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))
            Right -> midLeftAt (absolute w) (absolute <| midHeight + (floor <| h * (toFloat imageHeight)))

side : SensorType -> Side
side sensor = case sensor of
    MLX90614ESFDAA -> Right
    TMP421         -> Right
    BMP180         -> Right
    MMA8452Q       -> Right
    PDVP8104       -> Left
    PR103J2        -> Right
    HIH6130        -> Left
    SHT15          -> Left
    HTU21D         -> Right
    DS18B20        -> Right
    RHT03          -> Left
    TMP102         -> Left
    SHT75          -> Right
    HIH4030        -> Left
    GA1A1S201WP    -> Right 
    MAX4466        -> Left -- matching this with "SOUND" on the image
    D6T44L06       -> Left
    HMC5883        -> Left