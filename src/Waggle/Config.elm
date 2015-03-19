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

{- Styles -}
pointerStyle = { defaultLine | color <- lightGrey , width <- 3 }
sensorBackgroundColor = lightGrey

{- Text styles -}
primaryStyle = { defaultStyle | height <- Just 14 }
headerStyle = { defaultStyle | typeface <- ["EB Garamond", "serif"] }
h1Style = { headerStyle | height <- Just 40 }
h2Style = { headerStyle | height <- Just 30 }

{- Sizes -}
chart = 
    { width = 190
    , height = 20 }

image = 
    { width = 293
    , height = 586 
    , marginX = 32 }

sensor = 
    { width = value.width * 4 
    , height =  value.height + 1 * primaryEm
    , marginY = 2
    , marginX = 8
    , padding = 1 }

value = 
    { width = chart.width
    , height = chart.height + 1 * primaryEm
    , marginX = 16 }

primaryEm = "em" 
    |> fromString 
    |> style primaryStyle 
    |> leftAligned 
    |> heightOf

{- Urls -}
sensorDataUrl = "http://localhost:8000/data/current/current"
sensorImageUrl = "http://localhost:8000/assets/env-sense-cropped.jpg"

{- Content -}
title = "EnvSense V1"
secondary = ""