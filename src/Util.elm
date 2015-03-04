module Util where

import Signal (Signal, foldp)
import Maybe (Maybe(..), map, andThen)
import List

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

map2 : (a -> b -> result) -> Maybe a -> Maybe b -> Maybe result
map2 f a b = case a of
    Just a'  -> map (f a') b
    Nothing -> Nothing

transpose : List (Maybe a) -> Maybe (List a)
transpose ms = 
    let f m s = case s of
        Nothing -> Nothing
        Just xs -> map (flip (::) <| xs) m
    in List.foldr f (Just []) ms