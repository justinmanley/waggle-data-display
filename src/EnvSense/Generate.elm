module EnvSense.Generate (generate) where

import Dict
import Random
import Stateful exposing (Stateful, andThen)
import Time exposing (Time)

import Sensor exposing (SensorId, RawReading, RawSensorSnapshot)

generate : Time -> List RawSensorSnapshot
generate now = 
    let seed = Random.initialSeed <| floor now
    in Stateful.run (Stateful.sequence sensors) seed |> fst

sensors : List (Stateful Random.Seed RawSensorSnapshot)
sensors = 
    [ sensor "MLX90614ESF-DAA.Melexis.008-2013" 
        [ fahrenheit ]
    
    , sensor "TMP421.Texas_Instruments.2012"
        [ celsius ]

    , sensor "BMP180.Bosch.2_5-2013"
        [ pressure, celsius ]

    , sensor "MMA8452Q.Freescale.8_1-2013"
        [ acceleration "X", acceleration "Y", acceleration "Z", vibration ]

    , sensor "Thermistor_NTC_PR103J2.US_Sensor.2003"
        [ rawTemperature ]

    , sensor "HTU21D.MeasSpec.2013"
        [ celsius, humidity ] 

    , sensor "DS18B20.Maxim.2008"
        [ celsius ] 

    , sensor "SHT75.Sensirion.5_2011"
        [ celsius, humidity ]

    , sensor "GA1A1S201WP.Sharp.2007"
        [ luminousIntensity ] 

    , sensor "PDV_P8104.API.2006"
        [ luminousIntensity ]

    , sensor "HIH4030.Honeywell.2008"
        [ humidity ]

    , sensor "SHT15.Sensirion.4_3-2010"
        [ celsius, humidity ]

    , sensor "RHT03.Maxdetect.2011"
        [ fahrenheit, humidity ]

    , sensor "TMP102.Texas_Instruments.2008"
        [ fahrenheit ]

    , sensor "MAX4466.Maxim.2001"
        [ acousticIntensity ]

    , sensor "D6T-44L-06.Omron.2012" <|
        (celsius' "PTAT") :: infraRedCamera

    , sensor "HMC5883.Honeywell.2013"
        [ magneticField "X", magneticField "Y", magneticField "Z" ]

    , sensor "HIH6130.Honeywell.2011"
        [ humidity, celsius ]

    ]

simple : String -> String -> Stateful Random.Seed RawReading
simple physicalQuantity units = Stateful.get `andThen` \seed ->
    let (value, seed') = Random.generate (Random.float 0 200) seed
        reading = 
            { physicalQuantity = physicalQuantity
            , units = units
            , value = value
            }
    in Stateful.put seed' `andThen` \_ -> Stateful.return reading

fahrenheit : Stateful Random.Seed RawReading
fahrenheit = simple "Temperature" "&deg;F"

celsius' : String -> Stateful Random.Seed RawReading
celsius' suffix = simple ("Temperature" ++ suffix) "&deg;C"

celsius : Stateful Random.Seed RawReading
celsius = celsius' ""

humidity : Stateful Random.Seed RawReading
humidity = simple "Humidity" "%RH"

luminousIntensity : Stateful Random.Seed RawReading
luminousIntensity = simple "Luminous Intensity" " raw A/D"

acousticIntensity : Stateful Random.Seed RawReading
acousticIntensity = simple "Acoustic Intensity" " raw A/D"

pressure : Stateful Random.Seed RawReading
pressure = simple "Pressure" "PA"

acceleration : String -> Stateful Random.Seed RawReading
acceleration dimension = simple ("Acceleration" ++ dimension) "g"

vibration : Stateful Random.Seed RawReading
vibration = simple "RMS Vibration" "g"

magneticField : String -> Stateful Random.Seed RawReading
magneticField dimension = simple ("Magnetic Field" ++ dimension) "G" 

rawTemperature : Stateful Random.Seed RawReading
rawTemperature = simple "Temperature" " raw A/D"

infraRedCamera : List (Stateful Random.Seed RawReading)
infraRedCamera = 
    let 
        cs = List.map toString [1..4]
        mkCoord coord = List.map ((++) <| coord ++ "x") cs
    in 
        List.map celsius' <| List.concatMap mkCoord cs 

sensor : SensorId 
    -> List (Stateful Random.Seed RawReading) 
    -> Stateful Random.Seed RawSensorSnapshot
sensor sensorId valueGenerators = 
    Stateful.sequence valueGenerators `andThen` \values -> 
        Stateful.return
            { id = sensorId
            , data = values 
            }
