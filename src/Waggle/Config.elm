module Waggle.Config where

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-annotated.png"

title = "EnvSense V1"