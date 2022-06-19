{-# LANGUAGE OverloadedStrings #-}

module Printer where

import qualified Data.Text   as Text
import           Data.Tree
import           Text.Printf

import           Models
import           Reporter


asTree :: (a -> String) -> Job a -> Tree String
asTree printValue job =
  case job of
    Job name x -> Node (printf "%s: %s" name (printValue x)) []
    Group name jobs ->
      Node (Text.unpack name) (map (asTree printValue) jobs)


printJob :: (a -> String) -> Job a -> String
printJob printValue = drawTree . asTree printValue

printReport :: Report -> String
printReport r =
  printf
    "Estimated Cost: $ %.2f, Actual Cost: $ %.2f, Difference: $ %+.2f"
    (unDollars (estimatedCost r))
    (unDollars (actualCost r))
    (unDollars (difference r))