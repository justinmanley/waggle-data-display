module Main where

import Dict
import Graphics.Element exposing (Element)
import Http
import Signal
import Task exposing (Task, andThen)
import Signal exposing (Mailbox, (<~), (~))
import Time exposing (Time)
import Window

import Config
import Update exposing (update)
import Sensor exposing (SensorBoard)
import View exposing (view)

import EnvSense.Parse exposing (parse)

main : Signal Element
main = view <~ Window.dimensions ~ sensorData

{- Destination for unparsed data retrieved via HTTP request. -}
rawData : Mailbox String
rawData = Signal.mailbox "sensor-data" 

sensorData : Signal (Time, SensorBoard)
sensorData = Signal.map parse rawData.signal
    |> (Time.timestamp >> update)

port getData : Signal (Task Http.Error ())
port getData = 
    let ticks : Signal Time
        ticks = Time.every Config.updateInterval

        getSensorData : String -> Task Http.Error ()
        getSensorData url = 
            Http.getString url `andThen` Signal.send rawData.address

    -- Lifting the URL string to a constant signal which updates periodically
    -- allows us to perform the HTTP request task periodically as well. 
    in Signal.map getSensorData
        <| Signal.sampleOn ticks 
        <| Signal.constant Config.sensorDataUrl       
