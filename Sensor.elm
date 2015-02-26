module Sensor where

import String

type alias Temperature = { value : Maybe Float, units : String }
type alias Pressure = { value : Maybe Float, units : String }
type alias LuminousIntensity = { value : Maybe Float, units : String }
type alias Acceleration = { value : Maybe Float, units : String }
type alias Humidity = { value : Maybe Float, units : String }
type alias AcousticIntensity = { value : Maybe Float, units : String }
type alias MagneticField = { value : Maybe Float, units : String }

type alias BasicSensor a = { a | timestamp : String, name : String }

type SensorData 
    = MLX90614ESF (BasicSensor { temperature : Temperature })
    | TMP421 (BasicSensor { 
        temperature : Temperature 
    }) 
    | BMP180 (BasicSensor { 
        temperature : Temperature, 
        pressure : Pressure 
    })
    | MMA8452Q (BasicSensor { 
        acceleration : { x : Acceleration, y : Acceleration } 
    })
    | PDV_P8104 (BasicSensor { 
        luminousIntensity : LuminousIntensity 
    })
    | PR103J2 (BasicSensor { 
        temperature : Temperature 
    })
    | HIH6130 (BasicSensor { 
        temperature : Temperature, 
        humidity : Humidity 
    })
    | SHT15 (BasicSensor {
        temperature : Temperature,
        humidity : Humidity 
    })
    | HTU21D (BasicSensor {
        temperature : Temperature,
        humidity : Humidity 
    })
    | DS18B20 (BasicSensor {
        temperature : Temperature 
    })
    | RHT03 (BasicSensor {
        temperature : Temperature,
        humidity : Humidity
    })
    | TMP102 (BasicSensor {
        temperature : Temperature
    })
    | SHT75 (BasicSensor {
        temperature : Temperature,
        humidity : Humidity
    })
    | HIH4030 (BasicSensor {
        humidity : Humidity
    })
    | GA1A1S201WP (BasicSensor {
        luminousIntensity : LuminousIntensity
    })
    | MAX4466 (BasicSensor {
        acousticIntensity : AcousticIntensity
    })
    | D6T44L06 (BasicSensor {
        temperatures : List Temperature
    })
    | HMC5883 (BasicSensor {
        magneticField : { x : MagneticField, y : MagneticField }
    })