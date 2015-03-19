module Waggle.Config where

import Time (second)
import Graphics.Element (heightOf)
import Graphics.Collage (defaultLine)
import Color (lightGrey)
import Text (plainText)

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

{-| How frequently to poll for data updates. -}
updateInterval = 1 * second

----------------------------------------------------------------------
-- STYLES ------------------------------------------------------------
----------------------------------------------------------------------
pointerStyle = { defaultLine | color <- lightGrey , width <- 3 }

mutedTextStyle = {}
primaryTextStyle = {}
----------------------------------------------------------------------
-- SIZES -------------------------------------------------------------
----------------------------------------------------------------------
em = heightOf (plainText "em")

chart = 
    { width = value.width
    , height = 20 }

image = 
    { width = 441
    , height = 586 
    , marginX = 32 }

sensor = 
    { width = value.width * 4 
    , height = chart.height + 1 * em + value.height
    , marginY = 2 }

value = 
    { width = 160
    , height = 1 * em
    , marginX = 16 }

----------------------------------------------------------------------
-- URLS --------------------------------------------------------------
----------------------------------------------------------------------
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense.jpg"

title = "EnvSense V1"