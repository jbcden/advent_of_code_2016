module Main where

import Data.List.Split
import Prelude hiding (Left, Right)

-- | Start with collecting all the state you are going to 
-- need to walk the path into a data type, this is a 
-- functional pattern. All application state gets rolled 
-- into a data type and each iteration through the app
-- returns a new instance of this data type slightly
-- modified. This is how functional apps replicate state
--
-- -- I could potentially clean up my implementation more by
-- making this a record, but I didn't. 
data Model = Model Direction (Int, Int) deriving (Show)
data Direction = North
               | East
               | South
               | West
                deriving (Show, Enum) -- Note this `Enum` typeclass, it lets you get the next and previous item in a ADT
data Command = Command LeftRight Int deriving (Show)
data LeftRight = Left
               | Right
               deriving (Show)

directions = "L1, R3, R1, L5, L2, L5, R4, L2, R2, R2, L2, R1, L5, R3, L4, L1, L2, R3, R5, L2, R5, L1, R2, L5, R4, R2, R2, L1, L1, R1, L3, L1, R1, L3, R5, R3, R3, L4, R4, L2, L4, R1, R1, L193, R2, L1, R54, R1, L1, R71, L4, R3, R191, R3, R2, L4, R3, R2, L2, L4, L5, R4, R1, L2, L2, L3, L2, L1, R4, R1, R5, R3, L5, R3, R4, L2, R3, L1, L3, L3, L5, L1, L3, L3, L1, R3, L3, L2, R1, L3, L1, R5, R4, R3, R2, R3, L1, L2, R4, L3, R1, L1, L1, R5, R2, R4, R5, L1, L1, R1, L2, L4, R3, L1, L3, R5, R4, R3, R3, L2, R2, L1, R4, R2, L3, L4, L2, R2, R2, L4, R3, R5, L2, R2, R4, R5, L2, L3, L2, R5, L4, L2, R3, L5, R2, L1, R1, R3, R3, L5, L2, L2, R5"

-- | The key thing to internalize about a functional app 
-- is to look at the app as a pipeline of data transformations.
-- In this case we will have many iterations taking us from:
--
--    Model -> Model
--
-- These repeated iterations are captured in the foldl
-- The flow of this app is: 
-- 1. Parse the path
-- 2. Iterate the path applying the `move` function each iteration
-- 3. Take our final state and print our result
main = do
   let startState = (Model North (0,0)) 
   let endState@(Model direction pos) = foldl (flip move) startState --Notice the flip which adapts the args that come into the fold to the order I need to keep my pipeline clean in `move`
                                      $ parseCommands directions
   print $ distance pos
   print endState

distance (x, y) = abs x + abs y

-- | This move function is the core of this app. Remember that `.` 
-- composes functions that are stil looking for args. This function
-- is a nice clean pipeline where a `Model` comes in on the right
-- goes through a series of transformations, then the resulting 
-- `Model` comes out the left
move (Command direction distance) = walk distance . turn direction 

parseCommands = map (parseCommand) . splitOn ", "

parseCommand ('L':num) = Command Left (read num)
parseCommand ('R':num) = Command Right (read num)

walk amount (Model North (x, y)) = Model North (x, y + amount)
walk amount (Model East (x, y)) = Model East (x + amount, y)
walk amount (Model South (x, y)) = Model South (x, y - amount)
walk amount (Model West (x, y)) = Model West (x - amount, y)

turn Right (Model West pos) = Model North pos
turn Right (Model direction pos) = Model (succ direction) pos
turn Left (Model North pos) = Model West pos
turn Left (Model direction pos) = Model (pred direction) pos
