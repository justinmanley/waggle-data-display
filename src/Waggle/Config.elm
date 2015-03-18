module Waggle.Config where

import Time (second)

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

{-| How frequently to poll for data updates. -}
updateInterval = 1 * second

----------------------------------------------------------------------
-- SIZES -------------------------------------------------------------
----------------------------------------------------------------------
chart = { width = 100, height = 50 }
image = { width = 441, height = 586 }

sensor = { width = 300, height = 300 }

----------------------------------------------------------------------
-- URLS --------------------------------------------------------------
----------------------------------------------------------------------
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense.jpg"

title = "EnvSense V1"