{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Models
import Reporter
import Printer

makeJobs :: Job JobId
makeJobs = Group "Apps" [webapp, mobileapp, flutterapps]
  where
    webapp = Job "Web App" 1
    mobileapp = Job "Mobile App" 2
    fweb = Job "Flutter Web App" 3
    fmobile = Job "Flutter Mobile App" 4
    flutterapps = Group "Flutter Apps" [fweb, fmobile]


main :: IO ()
main = do
    r <- getJobReport makeJobs
    putStrLn (printJob printReport r)
    putStrLn "Done!!"