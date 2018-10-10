{-# LANGUAGE NoImplicitPrelude #-}

module Line where

import Prelude hiding (length, (++))
import Data.Vector

newtype Line a = Line (Vector a) deriving (Show, Eq)

lineFromList :: [a] -> Line a
lineFromList as = Line $ fromListN 16 as

spin :: Int -> Line a -> Line a
spin 0 line = line
spin n line = spin (n - 1) (spinOnce line)
    where
        spinOnce :: Line a -> Line a
        spinOnce (Line as) = let
            ixs = cons (length as - 1) $ enumFromN 0 (length as - 1)
            in Line $ backpermute as ixs

swapIx :: Int -> Int -> Line a -> Line a
swapIx i j (Line as)
    | i == j = Line as
    | i > j = swapIx j i (Line as)
    | i < j = let
        ixs = enumFromN 0 i ++ (singleton j) ++ enumFromN (i + 1) (j - i - 1) ++ singleton i ++ enumFromN (j + 1) (length as - j - 1)
        in Line $ backpermute as ixs
swapIx _ _ _ = error "Should never happen"

swap :: (Eq a) => a -> a -> Line a -> Maybe (Line a)
swap a b (Line as) = do
    i <- findIndex (==a) as
    j <- findIndex (==b) as
    pure $ swapIx i j (Line as)