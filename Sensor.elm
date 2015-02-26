module Sensor where

import String

type alias Temperature = { value : Maybe Float, units : String }
type alias Pressure = { value : Maybe Float, units : String }
type alias LuminousIntensity = { value : Maybe Float, units : String }
type alias Acceleration = { value : Maybe Float, units : String }
type alias Humidity = { value : Maybe Float, units : String }

type alias BasicSensor a = { a | timestamp : String, name : String }

type SensorData 
    = MLX90614ESF (BasicSensor { temperature : Temperature })
    | TMP421 (BasicSensor { 
        temperature : Temperature })
    | BMP180 (BasicSensor { 
        temperature : Temperature, 
        pressure : Pressure })
    | MMA8452Q (BasicSensor { 
        acceleration : { x : Acceleration, y : Acceleration } })
    | PDV_P8104 (BasicSensor { 
        luminousIntensity : LuminousIntensity })
    | PR103J2 (BasicSensor { 
        temperature : Temperature })
    | HIH6130 (BasicSensor { 
        temperature : Temperature, 
        humidity : Humidity })
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