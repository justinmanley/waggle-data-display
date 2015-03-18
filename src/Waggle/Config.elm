module Waggle.Config where

import Time (second)

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

{-| How frequently to poll for data updates. -}
updateInterval = 1 * second

sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-annotated.png"

title = "EnvSense V1"