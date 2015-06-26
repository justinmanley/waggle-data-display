module Main where

import Dict
import Graphics.Element exposing (Element)
import Http
import Signal
import Task exposing (Task, andThen)
import Signal exposing (Mailbox, (<~), (~))
import Time exposing (Time, every, second)
import Window

import Config
import Update exposing (update)
import Sensor exposing (SensorBoard)
import View exposing (view)

import EnvSense.Generate exposing (generate)

main : Signal Element
main = view <~ Window.dimensions ~ sensorData

sensorData : Signal (Time, SensorBoard)
sensorData = Signal.map generate (every second)
    |> Time.timestamp 
    |> update

