module QueueBuffer where

import Queue
import Queue.Internal (Queue(Queue))
import List

type alias QueueBuffer a = {
    queue : Queue a,
    available : Int
}

push : a -> QueueBuffer a -> QueueBuffer a
push x buf = 
    if | buf.available == 0 ->
        case Queue.pop buf.queue of
            Just (_, queue) -> { buf | queue <- Queue.push x queue }
            Nothing -> { buf | queue <- Queue.push x Queue.empty }
       | otherwise -> { buf | queue <- Queue.push x buf.queue, available <- buf.available - 1 }

empty : Int -> QueueBuffer a
empty n = { queue = Queue.empty, available = n }

unzip : QueueBuffer (a, b) -> (QueueBuffer a, QueueBuffer b)
unzip buf =
    let (Queue h t) = buf.queue
        (bs, cs) = List.unzip h
        (xs, ys) = List.unzip t
    in ({ buf | queue <- Queue bs xs }, { buf | queue <- Queue cs ys })


foldr : (a -> b -> b) -> b -> QueueBuffer a -> b
foldr f start buf =
    let (Queue h t) = buf.queue
        result = List.foldr f start h
    in List.foldl f result t

map : (a -> b) -> QueueBuffer a -> QueueBuffer b
map f buf = { buf | queue <- Queue.map f buf.queue }

toList : QueueBuffer a -> List a
toList buf = Queue.toList buf.queue