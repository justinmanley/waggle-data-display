module QueueBuffer where

import Queue
import Queue (Queue)

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
