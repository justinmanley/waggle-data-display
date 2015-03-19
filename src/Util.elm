module Util where

import Signal (Signal, foldp)
import Maybe (Maybe(..), map, andThen, withDefault)
import List
import String
import Result (toMaybe)

-- Get only the (Just a) values from a list of (Maybe a)s.
-- Unlike map fromJust << filter isJust, this function will never throw a runtime error.
filterJust : List (Maybe a) -> List a
filterJust maybes = case maybes of
    []        -> []
    (x :: xs) -> case x of
        Just y  -> y :: (filterJust xs)
        Nothing -> filterJust xs

take : Int -> Signal a -> Signal (List a)
take n input =
  let next inp prev = List.take n (inp :: prev)
  in foldp next [] input

map3 : (a -> b -> c -> result) -> Maybe a -> Maybe b -> Maybe c -> Maybe result
map3 f a b c = case a of
    Just a' -> case b of
        Just b' -> map (f a' b') c
        Nothing -> Nothing
    Nothing -> Nothing

transpose : List (Maybe a) -> Maybe (List a)
transpose ms = 
    let f m s = case s of
        Nothing -> Nothing
        Just xs -> map (flip (::) <| xs) m
    in List.foldr f (Just []) ms

truncateFloat : Int -> Float -> Float
truncateFloat digits num = 
    let num' = String.split "." (toString num)
    in case num' of
        [] -> num
        x :: [] -> withDefault num (toMaybe <| String.toFloat x)
        x :: xs :: _ -> withDefault num (toMaybe <| String.toFloat <| x ++ "." ++ String.left digits xs)
