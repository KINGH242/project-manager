module Data where

import System.Random (getStdRandom, randomR)

import Models

getCost :: JobId -> IO Cost
getCost _ = do
  r <- Dollars <$> getStdRandom (randomR (50, 120))
  t <- Hours <$> getStdRandom (randomR (1, 100))
  pure Cost {rate = r, time = t}

getWorkLogs :: JobId -> IO [WorkLog]
getWorkLogs _ = do
  t <- Task . Hours <$> getStdRandom (randomR (1, 10))
  e <- Epic . Hours <$> getStdRandom (randomR (10, 100))
  pure [t, e]