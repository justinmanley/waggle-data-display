module Waggle.Sensor where

import String

type alias Value = { value : Float, units : String }
type alias Temperature = Value
type alias Pressure = Value
type alias LuminousIntensity = Value
type alias Humidity = Value
type alias AcousticIntensity = Value

type alias Acceleration = { x : Value, y : Value }
type alias MagneticField = { x : Value, y : Value }

type alias BasicSensor a = { a | timestamp : String, name : String }

type Sensor
    = MLX90614ESF (BasicSensor { temperature : Temperature })
    | TMP421 (BasicSensor { temperature : Temperature }) 
    | BMP180 (BasicSensor { temperature : Temperature, pressure : Pressure })
    | MMA8452Q (BasicSensor { acceleration : Acceleration })
    | PDV_P8104 (BasicSensor { luminousIntensity : LuminousIntensity })
    | PR103J2 (BasicSensor { temperature : Temperature })
    | HIH6130 (BasicSensor { temperature : Temperature, humidity : Humidity })
    | SHT15 (BasicSensor { temperature : Temperature, humidity : Humidity })
    | HTU21D (BasicSensor { temperature : Temperature, humidity : Humidity })
    | DS18B20 (BasicSensor { temperature : Temperature })
    | RHT03 (BasicSensor { temperature : Temperature, humidity : Humidity })
    | TMP102 (BasicSensor { temperature : Temperature })
    | SHT75 (BasicSensor { temperature : Temperature, humidity : Humidity })
    | HIH4030 (BasicSensor { humidity : Humidity })
    | GA1A1S201WP (BasicSensor { luminousIntensity : LuminousIntensity })
    | MAX4466 (BasicSensor { acousticIntensity : AcousticIntensity })
    | D6T44L06 (BasicSensor { temperatures : List Temperature })
    | HMC5883 (BasicSensor { magneticField : MagneticField })  