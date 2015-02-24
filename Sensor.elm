module Sensor where

import String

type alias Temperature = { value : Maybe Float, units : String }
type alias Pressure = { value : Maybe Float, units : String, kind : String }
type alias LuminousIntensity = { value : Maybe Float, units : String }
type alias Acceleration = { value : Maybe Float, units : String, direction : String }

type SensorData = MLX90614ESF { 
        timestamp : String, 
        name : String, 
        temperature : Temperature } 
    | TMP421 { 
        timestamp : String, 
        name : String, 
        temperature : Temperature }
    | BMP180 {
        timestamp : String,
        name : String,
        temperature : Temperature,
        pressure : Pressure }
    | MMA8452Q {
        timestamp : String,
        name : String,
        acceleration : (Acceleration, Acceleration)
    }
    | PDV_P8104 { 
        timestamp : String, 
        name : String, 
        luminousIntensity : LuminousIntensity }
    | PR103J2
    | HIH6130
    | SHT15
    | HTU21D
    | DS18B20
    | RHT03
    | TMP102
    | SHT75
    | HIH4030
    | GA1A1S201WP
    | MAX4466
    | D6T44L06
    | HMC5883