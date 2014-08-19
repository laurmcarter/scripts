module Paths_HDef (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/kcarter/bin/HDef/.cabal-sandbox/bin"
libdir     = "/home/kcarter/bin/HDef/.cabal-sandbox/lib/x86_64-linux-ghc-7.6.3/HDef-0.1.0.0"
datadir    = "/home/kcarter/bin/HDef/.cabal-sandbox/share/x86_64-linux-ghc-7.6.3/HDef-0.1.0.0"
libexecdir = "/home/kcarter/bin/HDef/.cabal-sandbox/libexec"
sysconfdir = "/home/kcarter/bin/HDef/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "HDef_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "HDef_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "HDef_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "HDef_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "HDef_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
