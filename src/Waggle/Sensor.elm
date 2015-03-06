module Waggle.Sensor where

import String

-- Simple values
type alias Value = { value : Float, units : String }
type alias Temperature = Value
type alias Pressure = Value
type alias LuminousIntensity = Value
type alias Humidity = Value
type alias AcousticIntensity = Value

-- Compound values
type alias Acceleration = { x : Value, y : Value }
type alias MagneticField = { x : Value, y : Value }

type alias BasicSensor a = { a | timestamp : String, name : String, sensorType : SensorType }

type Sensor
    = TemperatureSensor (BasicSensor { temperature : Temperature })
    | HumiditySensor (BasicSensor { humidity : Humidity })
    | TemperatureHumiditySensor (BasicSensor { temperature : Temperature, humidity : Humidity })
    | LuminousIntensitySensor (BasicSensor { luminousIntensity : LuminousIntensity })
    | InfraredCamera (BasicSensor { temperatures : List Temperature })
    | MagneticFieldSensor (BasicSensor { magneticField : MagneticField })
    | AcousticIntensitySensor (BasicSensor { acousticIntensity : AcousticIntensity })
    | TemperaturePressureSensor (BasicSensor { temperature : Temperature, pressure : Pressure })
    | AccelerationSensor (BasicSensor { acceleration : Acceleration })

type SensorType
    = MLX90614ESF
    | TMP421 
    | BMP180
    | MMA8452Q
    | PDV_P8104
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

sensorType : Sensor -> SensorType
sensorType sensor = case sensor of
    TemperatureSensor { sensorType }         -> sensorType
    HumiditySensor { sensorType }            -> sensorType
    TemperatureHumiditySensor { sensorType } -> sensorType
    LuminousIntensitySensor { sensorType }   -> sensorType 
    InfraredCamera { sensorType }            -> sensorType 
    MagneticFieldSensor { sensorType }       -> sensorType
    AcousticIntensitySensor { sensorType }   -> sensorType 
    TemperaturePressureSensor { sensorType } -> sensorType
    AccelerationSensor { sensorType }        -> sensorType