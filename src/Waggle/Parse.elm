module Waggle.Parse where

import String
import Result (Result(..))
import List
import Maybe (Maybe(..), andThen, map)

import Waggle.Sensor (..)
import Util (map3, transpose)

{-| Parse the current list of sensors, as in data/current/current. -}
parse : String -> List (Maybe Sensor)
parse = List.map parseSensor << List.filter (not << String.isEmpty) << String.lines

{-| Parse a single line as a sensor.
 -  If the parse fails at any time, returns Nothing; otherwise, returns (Just sensor). 
 -}
parseSensor : String -> Maybe Sensor
parseSensor s =
    let data = String.split "," s

        temperatureSensor = map TemperatureSensor << simpleSensor parseTemperature
        humiditySensor = map HumiditySensor << simpleSensor parseHumidity
        luminousIntensitySensor = map LuminousIntensitySensor << simpleSensor parseLuminousIntensity
        acousticIntensitySensor = map AcousticIntensitySensor << simpleSensor parseAcousticIntensity
        magneticFieldSensor = map MagneticFieldSensor << simpleSensor parseMagneticField
        infraredCameraSensor = map InfraredCamera << simpleSensor parseTemperatures

        simpleSensor parsePoint sensorType = map fst
            <| parseBasic data sensorType `andThen` parsePoint

        accelerationSensor sensorType = map (AccelerationSensor << fst)
            <| parseBasic data sensorType 
                `andThen` parseAcceleration
                `andThen` parseVibration

        temperatureHumiditySensor sensorType = map (TemperatureHumiditySensor << fst)
            <| parseBasic data sensorType 
                `andThen` parseTemperature 
                `andThen` parseHumidity

        pressureSensor sensorType = map (TemperaturePressureSensor << fst) 
            <| parseBasic data sensorType 
                `andThen` parseTemperature 
                `andThen` parsePressure

    in case data of
        [] -> Nothing
        (name :: _) -> case name of
            "MLX90614ESF-DAA.Melexis.008-2013" -> temperatureSensor MLX90614ESF
            "TMP421.Texas_Instruments.2012" -> temperatureSensor TMP421
            "Thermistor_NTC_PR103J2.US_Sensor.2003" -> temperatureSensor PR103J2
            "DS18B20.Maxim.2008" -> temperatureSensor DS18B20
            "TMP102.Texas_Instruments.2008" -> temperatureSensor TMP102
            "HIH4030.Honeywell.2008" -> humiditySensor HIH4030
            "BMP180.Bosch.2_5-2013" -> pressureSensor BMP180
            "SHT75.Sensirion.5_2011" -> temperatureHumiditySensor SHT75
            "RHT03.Maxdetect.2011" -> temperatureHumiditySensor RHT03
            "HTU21D.MeasSpec.2013" -> temperatureHumiditySensor HTU21D
            "SHT15.Sensirion.4_3-2010" -> temperatureHumiditySensor SHT15
            "HIH6130.Honeywell.2011" -> temperatureHumiditySensor HIH6130
            "GA1A1S201WP.Sharp.2007" -> luminousIntensitySensor GA1A1S201WP
            "PDV_P8104.API.2006" -> luminousIntensitySensor PDV_P8104
            "MAX4466.Maxim.2001" -> acousticIntensitySensor MAX4466
            "MMA8452Q.Freescale.8_1-2013" -> accelerationSensor MMA8452Q
            "HMC5883.Honeywell.2013" -> magneticFieldSensor HMC5883
            "D6T-44L-06.Omron.2012" -> infraredCameraSensor D6T44L06
            _ -> Nothing -- ensure exhaustive case match

parseBasic : List String -> SensorType -> Maybe (BasicSensor {}, List String)
parseBasic data sensorType = case data of
    name :: timestamp :: rest -> Just ({
        name = name,
        timestamp = timestamp,
        sensorType = sensorType
    }, rest)
    _ -> Nothing

parsePressure (record, data) = case data of
    pressure :: rest -> map (\p -> ({ record | pressure = p }, rest))
        <| parseValue pressure
    _ -> Nothing

parseVibration (record, data) = case data of
    vibration :: rest -> map (\v -> ({ record | vibration = v }, rest))
        <| parseValue vibration
    _ -> Nothing

parseHumidity (record, data) = case data of
    humidity :: rest -> map (\h -> ({ record | humidity = h }, rest))
        <| parseValue humidity
    _ -> Nothing

parseTemperature (record, data) = case data of
    temperature :: rest -> map (\t -> ({ record | temperature = t }, rest))
        <| parseValue temperature
    _ -> Nothing

parseTemperatures (record, data) = case transpose (List.map parseValue data) of
    Just temperatures -> Just ({ record | temperatures = temperatures }, [])
    Nothing -> Nothing

parseLuminousIntensity (record, data) = case data of
    luminousIntensity :: rest -> map (\t -> ({ record | luminousIntensity = t }, rest))
        <| parseValue luminousIntensity
    _ -> Nothing

parseAcousticIntensity (record, data) = case data of
    acousticIntensity :: rest -> map (\t -> ({ record | acousticIntensity = t }, rest))
        <| parseValue acousticIntensity
    _ -> Nothing

parseAcceleration (record, data) = case data of
    x :: y :: z :: rest -> map (\a -> ({ record | acceleration = a }, rest))
        <| parseCompoundDataPoint x y z
    _ -> Nothing

parseMagneticField (record, data) = case data of
    x :: y :: z :: rest -> map (\a -> ({ record | magneticField = a }, rest))
        <| parseCompoundDataPoint x y z
    _ -> Nothing

parseValue : String -> Maybe Value
parseValue s = case String.split ";" s of
    _ :: value :: units :: _ -> case String.toFloat value of
        Ok v -> Just { value = v, units = units }
        Err _ -> Nothing
    _ -> Nothing

parseCompoundDataPoint : String -> String -> String -> Maybe { x : Value, y : Value, z : Value }
parseCompoundDataPoint x y z = map3 (\aX -> \aY -> \aZ -> { x = aX, y = aY, z = aZ }) (parseValue x) 
    (parseValue y)
    (parseValue z)
