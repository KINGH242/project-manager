{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# LANGUAGE OverloadedStrings #-}

module Jobs where

import Models

makeGroup :: Job
makeGroup = Group "Apps" [webapp, mobileapp, flutterapps]
  where
    webapp = Job 1 "Web App"
    mobileapp = Job 2 "Mobile App"
    fweb = Job 3 "Flutter Web App"
    fmobile = Job 4 "Flutter Mobile App"
    flutterapps = Group "Flutter Apps" [fweb, fmobile]