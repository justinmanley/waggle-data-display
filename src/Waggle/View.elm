module Waggle.View where

import Graphics.Element (
    Element, 
    midRight, midLeft, 
    midBottom, middle,
    widthOf, heightOf,
    container)

import Waggle.Config (sensor)

{-| Tag indicating the side of the image corresponding to each sensor. -}
type Side = Left | Right

{-| Give an element (the appearance of) top and bottom margins. -}
marginX : Int -> Element -> Element
marginX margin el = container (widthOf el + 2 * margin) (heightOf el) middle el

marginY : Int -> Element -> Element
marginY m el = container (widthOf el) (heightOf el + 2 * m) midBottom el

alignSensor : Side -> Element -> Element
alignSensor side = 
    let alignment = case side of
        Left -> midRight
        Right -> midLeft
    in container sensor.width (sensor.height + 2 * sensor.marginY) alignment
