{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_project_manager (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/hareemadderley/.cabal/bin"
libdir     = "/Users/hareemadderley/.cabal/lib/aarch64-osx-ghc-8.10.7/project-manager-0.1.0.0-inplace-project-manager"
dynlibdir  = "/Users/hareemadderley/.cabal/lib/aarch64-osx-ghc-8.10.7"
datadir    = "/Users/hareemadderley/.cabal/share/aarch64-osx-ghc-8.10.7/project-manager-0.1.0.0"
libexecdir = "/Users/hareemadderley/.cabal/libexec/aarch64-osx-ghc-8.10.7/project-manager-0.1.0.0"
sysconfdir = "/Users/hareemadderley/.cabal/etc"

getBinDir     = catchIO (getEnv "project_manager_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "project_manager_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "project_manager_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "project_manager_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "project_manager_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "project_manager_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
