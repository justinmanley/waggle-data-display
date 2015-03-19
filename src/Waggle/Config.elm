module Waggle.Config where

import Time (second)
import Graphics.Element (heightOf)
import Graphics.Collage (defaultLine)
import Color (lightGrey)
import Text (plainText, defaultStyle, leftAligned, style, fromString)

{-| The number of readings to hold in memory for each sensor. -}
historySize = 60

{-| How frequently to poll for data updates. -}
updateInterval = 1 * second

----------------------------------------------------------------------
-- STYLES ------------------------------------------------------------
----------------------------------------------------------------------
pointerStyle = { defaultLine | color <- lightGrey , width <- 3 }

mutedTextStyle = {}
primaryTextStyle = { defaultStyle
    | typeface <- ["EB Garamond", "serif"] 
    , height <- Just 14 }
----------------------------------------------------------------------
-- SIZES -------------------------------------------------------------
----------------------------------------------------------------------
chart = 
    { width = 190
    , height = 20 }

image = 
    { width = 441
    , height = 586 
    , marginX = 32 }

sensor = 
    { width = value.width * 4 
    , height =  value.height + 1 * primaryEm
    , marginY = 2
    , padding = 0 }

value = 
    { width = chart.width
    , height = chart.height + 1 * primaryEm
    , marginX = 16 }

primaryEm = (fromString >> style primaryTextStyle >> leftAligned >> heightOf) "em"
----------------------------------------------------------------------
-- URLS --------------------------------------------------------------
----------------------------------------------------------------------
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense.jpg"

title = "EnvSense V1"