module Waggle.Sensor where

import String

type alias Value = { value : String, units : String }
type alias Temperature = { value : String, units : String }
type alias Pressure = { value : String, units : String }
type alias LuminousIntensity = { value : String, units : String }
type alias Acceleration = { value : String, units : String }
type alias Humidity = { value : String, units : String }
type alias AcousticIntensity = { value : String, units : String }
type alias MagneticField = { value : String, units : String }

type alias BasicSensor a = { a | timestamp : String, name : String }

type Sensor
    = MLX90614ESF (BasicSensor { temperature : Temperature })
    | TMP421 (BasicSensor { temperature : Temperature }) 
    | BMP180 (BasicSensor { temperature : Temperature, pressure : Pressure })
    | MMA8452Q (BasicSensor { acceleration : { x : Acceleration, y : Acceleration } })
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
    | HMC5883 (BasicSensor { magneticField : { x : MagneticField, y : MagneticField } })

--data Sensor -> BasicSensor a
--data sensor = case sensor of
--    Waggle.Sensor.RHT03 r        -> r
--    Waggle.Sensor.SHT15 r        -> r
--    Waggle.Sensor.PDVrP8104 r    -> r
--    Waggle.Sensor.MAX4466 r      -> r
--    Waggle.Sensor.HIH4030 r      -> r
--    Waggle.Sensor.HIH6130 r      -> r
--    Waggle.Sensor.D6T44L06 r     -> r
--    Waggle.Sensor.TMP102 r       -> r
--    Waggle.Sensor.HMC5883 r      -> r
--    Waggle.Sensor.DS18B20 r      -> r
--    Waggle.Sensor.PR103J2 r      -> r
--    Waggle.Sensor.GA1A1S201WP r  -> r
--    Waggle.Sensor.SHT75 r        -> r
--    Waggle.Sensor.TMP421 r       -> r
--    Waggle.Sensor.BMP180 r       -> r
--    Waggle.Sensor.MLX90614ESF r  -> r
--    Waggle.Sensor.HTU21D r       -> r
--    Waggle.Sensor.MMA8452Q r     -> r    