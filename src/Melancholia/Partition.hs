module Melancholia.Partition where

data Partition = Partition

fromList :: [Int] -> Partition
fromList = const Partition
