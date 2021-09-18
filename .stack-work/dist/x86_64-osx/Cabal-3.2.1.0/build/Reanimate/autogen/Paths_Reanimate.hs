{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_Reanimate (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
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
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/bin"
libdir     = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/lib/x86_64-osx-ghc-8.10.3/Reanimate-0.1.0.0-1ZRC4VU8SvRJyLpfqfLQKg-Reanimate"
dynlibdir  = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/lib/x86_64-osx-ghc-8.10.3"
datadir    = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/share/x86_64-osx-ghc-8.10.3/Reanimate-0.1.0.0"
libexecdir = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/libexec/x86_64-osx-ghc-8.10.3/Reanimate-0.1.0.0"
sysconfdir = "/Users/izuzu/Documents/Work/Haskell/Reanimate/.stack-work/install/x86_64-osx/24f6ed0c0c18a7c3955be4f87173c5cb59f07758015202064dce78ab5d43abb2/8.10.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Reanimate_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Reanimate_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Reanimate_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Reanimate_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Reanimate_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Reanimate_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
