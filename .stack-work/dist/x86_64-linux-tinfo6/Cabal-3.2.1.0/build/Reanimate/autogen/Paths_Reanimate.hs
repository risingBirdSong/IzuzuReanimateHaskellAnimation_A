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

bindir     = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/bin"
libdir     = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/lib/x86_64-linux-ghc-8.10.3/Reanimate-0.1.0.0-JqEySYtacPbIkXsVLzirmW-Reanimate"
dynlibdir  = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/lib/x86_64-linux-ghc-8.10.3"
datadir    = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/share/x86_64-linux-ghc-8.10.3/Reanimate-0.1.0.0"
libexecdir = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/libexec/x86_64-linux-ghc-8.10.3/Reanimate-0.1.0.0"
sysconfdir = "/home/peterm/Downloads/Reanimate_20210918/.stack-work/install/x86_64-linux-tinfo6/a5c5cc09af3495917fa530a283abed6675acc9d9e41f473d0ae00dfcb165eb85/8.10.3/etc"

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
