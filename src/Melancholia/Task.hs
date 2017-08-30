module Melancholia.Task where

import           Melancholia.Partition

-- TODO: GADT?
data Task = PartitionCount (Partition -> Integer)
