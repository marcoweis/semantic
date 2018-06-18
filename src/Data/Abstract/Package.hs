{-# LANGUAGE TupleSections #-}
module Data.Abstract.Package where

import Data.Abstract.Module
import Data.Abstract.ModuleTable as ModuleTable
import qualified Data.Map as Map
import Data.Abstract.Name
import Prologue

type PackageName = Name

-- | Metadata for a package (name and version).
data PackageInfo = PackageInfo
  { packageName        :: PackageName
  , packageVersion     :: Maybe Version
  , packageResolutions :: Map.Map FilePath FilePath
  }
  deriving (Eq, Ord, Show)

newtype Version = Version { versionString :: String }
  deriving (Eq, Ord, Show)

data PackageBody term = PackageBody
  { packageModules     :: ModuleTable (NonEmpty (Module term))
  , packageEntryPoints :: ModuleTable (Maybe Name)
  }
  deriving (Eq, Functor, Ord, Show)


-- | A package represents the unit of dependency, i.e. something which can depend upon, or be depended upon by, other packages. Packages have modules and may have entry points from which evaluation can proceed.
data Package term = Package
  { packageInfo :: PackageInfo
  , packageBody :: PackageBody term
  }
  deriving (Eq, Functor, Ord, Show)

fromModules :: PackageName -> Maybe Version -> Int -> [Module term] -> Map.Map FilePath FilePath -> Package term
fromModules name version entryPoints modules resolutions =
  Package (PackageInfo name version resolutions) (PackageBody (ModuleTable.fromModules modules) entryPoints')
  where
    entryPoints' = ModuleTable . Map.fromList $ (,Nothing) . modulePath . moduleInfo <$> if entryPoints == 0 then modules else take entryPoints modules
