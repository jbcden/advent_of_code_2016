{-# LANGUAGE OverloadedStrings #-}
module Main where
import qualified Data.Text as T

data Direction = North
               | East
               | South
               | West deriving (Show, Enum)
data Coordinate = Point Int Int deriving (Show)

determineDirection :: Direction -> String -> Direction
determineDirection North (p:_) =
  case p of
    'L' ->
      West
    'R' ->
      East

determineDirection South (p:_) =
  case p of
    'L' ->
      East
    'R' ->
      West

determineDirection East (p:_) =
  case p of
    'L' ->
      North
    'R' ->
      South

determineDirection West (p:_) =
  case p of
    'L' ->
      South
    'R' ->
      North

magnitude :: Direction -> Int
magnitude North =  1
magnitude South = -1
magnitude East  =  1
magnitude West  = -1

translate :: Coordinate -> Int -> Direction -> Coordinate
translate (Point x y) amount d =
  case d of
    North ->
      Point (x + total) y
    South ->
      Point (x + total) y
    East ->
      Point x (y + total)
    West ->
      Point x (y + total)
  where total = amount * magnitude d

move :: (Coordinate, Direction) -> String -> (Coordinate, Direction)
move (p, d) prompt@(_:a) = ((translate p (read a :: Int) direction), direction)
  where direction = determineDirection d prompt

directions = "L1, R3, R1, L5, L2, L5, R4, L2, R2, R2, L2, R1, L5, R3, L4, L1, L2, R3, R5, L2, R5, L1, R2, L5, R4, R2, R2, L1, L1, R1, L3, L1, R1, L3, R5, R3, R3, L4, R4, L2, L4, R1, R1, L193, R2, L1, R54, R1, L1, R71, L4, R3, R191, R3, R2, L4, R3, R2, L2, L4, L5, R4, R1, L2, L2, L3, L2, L1, R4, R1, R5, R3, L5, R3, R4, L2, R3, L1, L3, L3, L5, L1, L3, L3, L1, R3, L3, L2, R1, L3, L1, R5, R4, R3, R2, R3, L1, L2, R4, L3, R1, L1, L1, R5, R2, R4, R5, L1, L1, R1, L2, L4, R3, L1, L3, R5, R4, R3, R3, L2, R2, L1, R4, R2, L3, L4, L2, R2, R2, L4, R3, R5, L2, R2, R4, R5, L2, L3, L2, R5, L4, L2, R3, L5, R2, L1, R1, R3, R3, L5, L2, L2, R5"

calculateDistance :: Coordinate -> Int
calculateDistance (Point x y) = abs x + abs y

process :: T.Text -> IO ()
process d = do
  let ds = map T.unpack $ T.splitOn ", " d
  let (point, dir) = foldl move ((Point 0 0), North) ds

  putStrLn $ show point
  let distance = calculateDistance point
  putStrLn $ show distance

main :: IO ()
main = do
  process directions
  return ()
