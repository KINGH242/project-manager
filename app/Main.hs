{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Main where

import Control.Monad
import qualified Data.Text as T
import Models
import Printer
import Reporter

makeJobs :: T.Text -> Job JobId
makeJobs g = Group g [webapp, mobileapp, flutterapps]
  where
    webapp = Job "Web App" 1
    mobileapp = Job "Mobile App" 2
    fweb = Job "Flutter Web App" 3
    fmobile = Job "Flutter Mobile App" 4
    flutterapps = Group "Flutter Apps" [fweb, fmobile]

getMainProjects :: [Job JobId] -> IO [Job JobId]
getMainProjects jobs = do
  putStrLn "Press [G] to enter a new Group of Projects, or [P] to enter a new Project, or [Q] to Quit"
  line <- getLine
  if line == "g"
    then newGroup jobs
    else
      if line == "p"
        then newProject jobs
        else
          if line == "q"
            then return jobs
            else getMainProjects jobs

newProject :: [Job JobId] -> IO [Job JobId]
newProject jobs = do
  putStrLn "Please enter a name for new Project"
  line1 <- getLine
  putStrLn "Please enter an ID for new Project"
  line2 <- getLine
  let id = (read line2 :: Int)
  let j = Job (T.pack line1) (JobId id)
  let newJobs = jobs ++ [j]
  print j
  getMainProjects newJobs

newGroup :: [Job JobId] -> IO [Job JobId]
newGroup jobs = do
  putStrLn "Please enter a name for new Group"
  line1 <- getLine
  let g = Group (T.pack line1) []
  -- print g
  getProjectsForGroup line1 g jobs

newProjectForGroup :: [Char] -> p -> [Job JobId] -> IO [Job JobId]
newProjectForGroup name group jobs = do
  putStrLn $ "Please enter a name for new Project in Group: " ++ name
  line1 <- getLine
  putStrLn $ "Please enter an ID for new Project in Group: " ++ name
  line2 <- getLine
  let id = (read line2 :: Int)
  let j = Job (T.pack line1) (JobId id)
  print j
  let g = Group (T.pack name) [j]
  print g
  let newJobs = jobs ++ [g]
  getProjectsForGroup name g newJobs

getProjectsForGroup :: [Char] -> p -> [Job JobId] -> IO [Job JobId]
getProjectsForGroup name group jobs = do
  putStrLn "Press [G] to enter a new Group of Projects, or [P] to enter a new Project, or [E] to Exit this Group"
  line <- getLine
  if line == "g" || line == "G"
    then newGroup jobs
    else
      if line == "p" || line == "P"
        then newProjectForGroup name group jobs
        else getMainProjects jobs

main :: IO ()
main = do
  putStrLn "Please enter name of the Group of Projects"
  groupName <- getLine

  jobs <- getMainProjects []
  let g = Group (T.pack groupName) jobs

  print g

  r <- getJobReport g
  putStrLn (printJob printReport r)
  putStrLn "Done!!"