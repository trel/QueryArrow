{-# LANGUAGE GADTs, StandaloneDeriving, MultiParamTypeClasses, DeriveGeneric, FlexibleInstances #-}
module QueryArrow.FileSystem.LocalCommands where

import QueryArrow.DB.DB
import Data.ByteString (ByteString)

import System.FilePath ((</>), equalFilePath, takeDirectory, takeFileName, pathSeparator)
import Data.Time.Clock
import Data.Convertible
import GHC.Generics

data Stats = Stats {isDir :: Bool} deriving Generic

data File = File {fHost :: String, fRoot :: String, fRelP :: String} deriving Generic

instance Eq File where
  File h1 r1 p1 == File h2 r2 p2 = h1 == h2 && r1 == r2 && equalFilePath p1 p2



fsreplaceFileName :: String -> File -> File
fsreplaceFileName n file = fsreplaceRelP (takeDirectory (fRelP file) </> n) file

fsRelP :: File -> String
fsRelP = fRelP

fsreplaceRelP :: String -> File -> File
fsreplaceRelP path2 (File host root _)  = File host root path2

fsDir :: File -> Maybe File
fsDir file = if equalFilePath [pathSeparator] (fRelP file)
  then Nothing
  else Just (fsreplaceRelP (takeDirectory (fRelP file)) file)

fsfileName :: File -> String
fsfileName file = takeFileName (fRelP file)
instance Convertible File ResultValue where
  safeConvert (File host root path) = Right (RefValue [host, root] path)

instance Convertible ResultValue File where
  safeConvert (RefValue [host, root] path) = Right (File host root path)
  safeConvert _ = Left (ConvertError "" "" "" "")

data LocalizedFSCommand2 where
   L2CopyFile :: String -> String -> LocalizedFSCommand2
   L2CopyDir :: String -> String -> LocalizedFSCommand2
   L2MoveFile :: String -> String -> LocalizedFSCommand2
   L2MoveDir :: String -> String -> LocalizedFSCommand2 deriving Generic

data LocalizedFSCommand x where
    LDirExists :: String -> LocalizedFSCommand Bool
    LFileExists :: String -> LocalizedFSCommand Bool
    LUnlinkFile :: String -> LocalizedFSCommand ()
    LRemoveDir :: String -> LocalizedFSCommand ()
    LMakeFile :: String -> LocalizedFSCommand ()
    LMakeDir :: String -> LocalizedFSCommand ()
    LWrite :: String -> Integer -> ByteString -> LocalizedFSCommand ()
    LRead :: String -> Integer -> Integer -> LocalizedFSCommand ByteString
    LListDirDir :: String -> LocalizedFSCommand [File]
    LListDirFile :: String -> LocalizedFSCommand [File]
    LAllFiles :: LocalizedFSCommand [File]
    LAllDirs :: LocalizedFSCommand [File]
    LAllNonRootFiles :: LocalizedFSCommand [File]
    LAllNonRootDirs :: LocalizedFSCommand [File]
    LFindFilesByName :: String -> LocalizedFSCommand [File]
    LFindDirsByName :: String -> LocalizedFSCommand [File]
    LFindFilesByPath :: String -> LocalizedFSCommand [File]
    LFindDirsByPath :: String -> LocalizedFSCommand [File]
    LFindFilesBySize :: Integer -> LocalizedFSCommand [File]
    LFindFilesByModificationTime :: Integer -> LocalizedFSCommand [File]
    LFindDirsByModficationTime :: Integer -> LocalizedFSCommand [File]
    LStat :: String -> LocalizedFSCommand (Maybe Stats)
    LTruncate :: String -> Integer -> LocalizedFSCommand ()
    LSize :: String -> LocalizedFSCommand Integer
    LModificationTime :: String -> LocalizedFSCommand UTCTime

deriving instance Show (LocalizedFSCommand a)

deriving instance Show LocalizedFSCommand2