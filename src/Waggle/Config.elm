module Waggle.Config where

import Time (second)
import Graphics.Element (heightOf)
import Graphics.Collage (defaultLine)
import Color (blue)
import Text (plainText)

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

{-| How frequently to poll for data updates. -}
updateInterval = 1 * second

----------------------------------------------------------------------
-- STYLES ------------------------------------------------------------
----------------------------------------------------------------------
pointerStyle = { defaultLine | color <- blue , width <- 4 }

----------------------------------------------------------------------
-- SIZES -------------------------------------------------------------
----------------------------------------------------------------------
em = heightOf (plainText "em")

chart = { width = 100, height = 20 }
image = { width = 441, height = 586 }

sensor = 
    { width = value.width * 4 
    , height = chart.height + 1 * em + value.height }

value = 
    { width = 200
    , height = 1 * em }

----------------------------------------------------------------------
-- URLS --------------------------------------------------------------
----------------------------------------------------------------------
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense.jpg"

title = "EnvSense V1"