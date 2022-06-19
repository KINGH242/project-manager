{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE DeriveTraversable          #-}

module Models where

import Data.Text (Text)

newtype Hours = Hours
  { unHours :: Double
  } deriving (Show, Eq, Num)

newtype Dollars = Dollars
  { unDollars :: Double
  } deriving (Show, Eq, Num)

newtype JobId = JobId
  { unJobId :: Int
  } deriving (Show, Eq, Num)

data Job a
  = Job Text a
  | Group Text [Job a]
  deriving (Show, Eq, Functor, Foldable, Traversable)

data Cost = Cost
  { rate :: Dollars
  , time :: Hours
  } deriving (Show, Eq)

data WorkLog
  = Task Hours
  | Epic Hours
  deriving (Eq, Show)