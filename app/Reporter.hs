module Reporter where

import Data.Monoid (getSum)
import Data.Foldable (fold)

import qualified Data as DB
import Models

data Report = Report
  { estimatedCost  :: Dollars
  , actualCost     :: Dollars
  , difference     :: Dollars
  } deriving (Show, Eq)

instance Semigroup Report where
  Report e1 a1 d1 <> Report e2 a2 d2 = Report (e1 + e2) (a1 + a2) (d1 + d2)

instance Monoid Report where
  mempty = Report 0 0 0
  mappend (Report e1 a1 d1) (Report e2 a2 d2) =
    Report (e1 + e2) (a1 + a2) (d1 + d2)

getReport :: Cost -> [WorkLog] -> Report
getReport cost worklogs =
  Report
  { estimatedCost = estimatedCost'
  , actualCost = actualCost'
  , difference = actualCost' - estimatedCost'
  }
  where
    estimatedCost' = Dollars (unDollars (rate cost) * unHours (time cost))
    actualCost' = Dollars (unHours (getSum (foldMap getWorkLogHours worklogs)) * unDollars (rate cost))
    getWorkLogHours (Task w) = pure w
    getWorkLogHours (Epic w) = pure w


getJobReport :: Job JobId -> IO (Job Report)
getJobReport =
  traverse (\j -> getReport <$> DB.getCost j <*> DB.getWorkLogs j)

foldJobReport :: Job Report -> Report
foldJobReport = fold