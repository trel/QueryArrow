{-# LANGUAGE GADTs, RankNTypes, MultiParamTypeClasses, FlexibleInstances #-}
module QueryArrow.FileSystem.Interpreter where

import QueryArrow.FileSystem.Utils
import Control.Monad.IO.Class (MonadIO, liftIO)
import System.Directory
import Control.Exception (throw, bracket)
import System.IO
import Data.ByteString (hGet, hPut)
import qualified Data.ByteString as BS

import Control.Monad
import Control.Monad.Trans.Reader (ReaderT, ask, runReaderT)
import System.FilePath ((</>), takeFileName, splitDirectories, joinPath)
import System.PosixCompat.Files (setFileSize)
import System.FilePath.Find
import Data.Maybe
import Network
import QueryArrow.FileSystem.LocalCommands
import QueryArrow.FileSystem.Serialization
import QueryArrow.RPC.Message
import Data.Aeson


data Interpreter = Interpreter {
  interpreter :: forall a m. (MonadIO m, ToJSON a, FromJSON a) => LocalizedFSCommand a ->  m a
}

data Interpreter2 = Interpreter2 {
  interpreter2 :: forall m. (MonadIO m) => LocalizedFSCommand2 ->  m ()
}

toAP :: String -> String -> String
toAP root p =
    let ps = splitDirectories p in
        case ps of
            ["/"] -> root
            "/" : p2 | not (("." `elem` p2) || (".." `elem` p2)) -> root </> joinPath p2
            _ -> error ("fsTranslateQuery: malformatted path " ++ p)

toRelP :: String -> String -> String
toRelP root absp =
  let roots = splitDirectories root
      absps = splitDirectories absp
  in
      if take (length roots) absps /= roots
        then error "fsTranslateQuery: path error"
        else joinPath ("/" : drop (length roots) absps)

localInterpreter :: MonadIO m => LocalizedFSCommand a ->  ReaderT (String, String) m a
localInterpreter (LDirExists a ) = do
  (_, root) <- ask
  liftIO $ doesDirectoryExist (toAP root a)


localInterpreter (LFileExists a) = do
  (_, root) <- ask
  liftIO $ doesFileExist (toAP root a)


localInterpreter (LUnlinkFile a) = do
  (_, root) <- ask
  liftIO $ removeFile (toAP root a)

localInterpreter (LRemoveDir a) = do
  (_, root) <- ask
  liftIO $ removeDirectoryRecursive (toAP root a)

localInterpreter (LMakeFile a) = do
  (_, root) <- ask
  let absp = toAP root a
  liftIO $ do
    b <- doesPathExist absp
    if b
      then
        throw (userError "file already exists")
      else
        appendFile absp ""

localInterpreter (LMakeDir a) = do
  (_, root) <- ask
  liftIO $ createDirectory (toAP root a)

localInterpreter (LWrite a b c) = do
  (_, root) <- ask
  liftIO $ withFile (toAP root a) WriteMode $ \h -> do
      hSeek h AbsoluteSeek b
      hPut h c

localInterpreter (LRead a b d) = do
  (_, root) <- ask
  liftIO $ withFile (toAP root a) ReadMode $ \h -> do
      hSeek h AbsoluteSeek b
      hGet h (fromInteger (d - b))

localInterpreter LAllFiles = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? RegularFile) root
  return (map (File host root . toRelP root) ps)

localInterpreter LAllDirs = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? Directory) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LAllNonRootFiles) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? RegularFile &&? fileName /=? root) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LAllNonRootDirs) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? Directory &&? fileName /=? root) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LFindFilesByPath p) = do
  (host, root) <- ask
  let files0 = [File host root p]
  liftIO $ filterM (\(File _ root p) -> doesFileExist (toAP root p)) files0

localInterpreter (LFindDirsByPath p) = do
  (host, root) <- ask
  let files0 = [File host root p]
  liftIO $ filterM (\(File _ root p) -> doesDirectoryExist (toAP root p)) files0

localInterpreter (LFindFilesByName n ) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? RegularFile &&? fileName ==? n) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LFindDirsByName n ) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? Directory &&? fileName ==? n) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LFindFilesBySize n ) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? RegularFile &&? fileSize ==? fromInteger n) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LFindFilesByModificationTime n ) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? RegularFile &&? modificationTime ==? fromInteger n) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LFindDirsByModficationTime n ) = do
  (host, root) <- ask
  ps <- liftIO $ find (return True) ((statusType <$> fileStatus) ==? Directory &&? modificationTime ==? fromInteger n) root
  return (map (File host root . toRelP root) ps)

localInterpreter (LListDirDir a ) = do
  (host, root) <- ask
  let absp = toAP root a
  ps <- liftIO $ listDirectory absp
  let ps5 = map (absp </>) ps
  ps2 <- liftIO $ filterM doesDirectoryExist ps5
  return (map (File host root) ps2)

localInterpreter (LListDirFile a ) = do
  (host, root) <- ask
  let absp = toAP root a
  ps <- liftIO $ listDirectory absp
  let ps5 = map (absp </>) ps
  ps2 <- liftIO $ filterM doesFileExist ps5
  return (map (File host root) ps2)

localInterpreter (LStat (a) ) = do
  (host, root) <- ask
  let absp = toAP root a
  b <- liftIO $ doesFileExist absp
  if b
    then return (Just (Stats False))
    else do
      b2 <- liftIO $ doesDirectoryExist absp
      if b2
        then return (Just (Stats True))
        else return Nothing

localInterpreter (LSize fn ) = do
  (host, root) <- ask
  let absp = toAP root fn
  liftIO $ getFileSize absp

localInterpreter (LTruncate fn i ) = do
  (host, root) <- ask
  let absp = toAP root fn
  liftIO $ setFileSize absp (fromInteger i)

localInterpreter (LModificationTime fn ) = do
  (host, root) <- ask
  let absp = toAP root fn
  liftIO $ getModificationTime absp

localInterpreter2 :: MonadIO m => LocalizedFSCommand2  -> ReaderT (String, String) m ()

localInterpreter2 (L2CopyFile (a) (b) ) = do
  (host, root) <- ask
  let absp = toAP root a
  let abspb = toAP root b
  liftIO $ copyFile absp abspb

localInterpreter2 (L2CopyDir (a) (b) ) = do
  (host, root) <- ask
  let absp = toAP root a
  let abspb = toAP root b
  liftIO $ copyDirectory absp abspb

localInterpreter2 (L2MoveFile (a) (b)) = do
  (host, root) <- ask
  let absp = toAP root a
  let abspb = toAP root b
  liftIO $ renameFile absp abspb

localInterpreter2 (L2MoveDir (a) (b)) = do
  (host, root) <- ask
  let absp = toAP root a
  let abspb = toAP root b
  liftIO $ renameDirectory absp abspb

bufferSize :: Int
bufferSize = 4096

sendFile0 :: Handle -> Handle -> String -> Integer -> Integer -> IO ()
sendFile0 h0 h p s off = do
  unless (s == off) $ do
      buf <- hGet h0 bufferSize
      sendMsg h (LocalizedCommandWrapper (LWrite p off buf))
      Just () <- receiveMsg h
      sendFile0 h0 h p s (off + fromIntegral (BS.length buf))

sendFile :: String -> Handle -> String -> IO ()
sendFile a h b = do
  liftIO $ sendMsg h (LocalizedCommandWrapper (LMakeFile b))
  Just () <- liftIO $ receiveMsg h
  s <- getFileSize a
  withFile a ReadMode (\h0 ->
      sendFile0 h0 h b s 0)

receiveFile0 :: Handle -> Handle -> String -> Integer -> Integer -> IO ()
receiveFile0 h0 h p s off =
  unless (s == off) $ do
      let n = min (fromIntegral bufferSize) (s - off)
      sendMsg h (LocalizedCommandWrapper (LRead p off (off + n)))
      Just buf <- receiveMsg h
      hPut h0 buf
      receiveFile0 h0 h p s (off + fromIntegral (BS.length buf))

receiveFile :: String -> Handle -> String -> IO ()
receiveFile a h b = do
  liftIO $ sendMsg h (LocalizedCommandWrapper (LSize b))
  Just s <- liftIO $ receiveMsg h
  withFile a ReadMode (\h0 ->
      receiveFile0 h0 h b s 0)

remoteSendFile0 :: Handle -> String -> Handle -> String -> Integer -> Integer -> IO ()
remoteSendFile0 ha a hb b s off =
  unless (s == off) $ do
      let n = min (fromIntegral bufferSize) (s - off)
      sendMsg ha (LocalizedCommandWrapper (LRead a off (off + n)))
      Just buf <- receiveMsg ha
      sendMsg hb (LocalizedCommandWrapper (LWrite b off buf))
      Just () <- receiveMsg hb
      remoteSendFile0 ha a hb b s (off + fromIntegral (BS.length buf))

remoteSendFile :: Handle -> String -> Handle -> String -> IO ()
remoteSendFile ha a hb b = do
  liftIO $ sendMsg ha (LocalizedCommandWrapper (LSize a))
  Just s <- liftIO $ receiveMsg ha
  liftIO $ sendMsg hb (LocalizedCommandWrapper (LMakeFile b))
  Just () <- liftIO $ receiveMsg hb
  remoteSendFile0 ha a hb b s 0

sendDir :: String -> Handle -> String -> IO ()
sendDir a h b = do
  sendMsg h (LocalizedCommandWrapper (LMakeDir b))
  Just () <- receiveMsg h
  files <- listDirectory a
  mapM_ (\n -> do
    bool <- doesFileExist (a </> n)
    if bool
      then sendFile (a</>n) h (b </>  n)
      else sendDir (a</>n) h (b </>  n)
    ) files

receiveDir :: String -> Handle -> String -> IO ()
receiveDir a h b = do
  createDirectory a
  sendMsg h (LocalizedCommandWrapper (LListDirDir b))
  Just dirs <- receiveMsg h
  mapM_ (\(File _ _ dir) ->
    receiveDir (a </> takeFileName dir) h dir) (dirs :: [File])
  sendMsg h (LocalizedCommandWrapper (LListDirFile b))
  Just files <- receiveMsg h
  mapM_ (\(File _ _ file) ->
    receiveFile (a </> takeFileName file) h file) (files :: [File])

remoteSendDir :: Handle -> String -> Handle -> String -> IO ()
remoteSendDir ha a hb b = do
  sendMsg hb (LocalizedCommandWrapper (LMakeDir b))
  Just () <- receiveMsg hb
  sendMsg ha (LocalizedCommandWrapper (LListDirDir a))
  Just dirs <- receiveMsg ha
  mapM_ (\(File _ _ dir) ->
    remoteSendDir ha dir hb (b </> takeFileName dir)) (dirs :: [File])
  Just files <- receiveMsg ha
  mapM_ (\(File _ _ file) ->
    remoteSendFile ha file hb (b </> takeFileName file)) (files :: [File])

localToRemoteInterpreter2 :: MonadIO m => LocalizedFSCommand2  -> ReaderT (String, Int, String, String, Int, String) m ()
localToRemoteInterpreter2 (L2CopyFile (a) (b) ) = do
  (_, _, roota, host, port, _) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    sendFile (toAP roota a) h b
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
localToRemoteInterpreter2 (L2CopyDir (a) (b) ) = do
  (_, _, roota, host, port, root) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    sendDir (toAP roota a) h b
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
localToRemoteInterpreter2 (L2MoveFile (a) (b)) = do
  (_, _, roota, host, port, _) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    sendFile (toAP roota a) h b
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
  liftIO $ removeFile a
localToRemoteInterpreter2 (L2MoveDir (a) (b)) = do
  (_, _, roota, host, port, root) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    sendDir (toAP roota a) h b
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
  liftIO $ removeDirectoryRecursive a

remoteToLocalInterpreter2 :: MonadIO m => LocalizedFSCommand2  -> ReaderT (String, Int, String, String, Int, String) m ()
remoteToLocalInterpreter2 (L2CopyFile (a) (b) ) = do
  (host, port, _, _, _, rootb) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    receiveFile a h (toAP rootb b)
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
remoteToLocalInterpreter2 (L2CopyDir (a) (b) ) = do
  (host, port, _, _, _, rootb) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    receiveDir a h (toAP rootb b)
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
remoteToLocalInterpreter2 (L2MoveFile (a) (b)) = do
  (host, port, _, _, _, rootb) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    receiveFile a h (toAP rootb b)
    sendMsg h (LocalizedCommandWrapper (LUnlinkFile a))
    Just () <- liftIO $ receiveMsg h
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))
remoteToLocalInterpreter2 (L2MoveDir (a) (b)) = do
  (host, port, _, _, _, rootb) <- ask
  liftIO $ bracket (connectTo host (PortNumber (fromIntegral port))) hClose (\h -> do
    receiveDir a h (toAP rootb b)
    sendMsg h (LocalizedCommandWrapper (LRemoveDir a))
    Just () <- receiveMsg h
    sendMsg h (Exit :: LocalizedCommandWrapper LocalizedFSCommand))

remoteToRemoteInterpreter2 :: MonadIO m => LocalizedFSCommand2  -> ReaderT (String, Int, String, String, Int, String) m ()
remoteToRemoteInterpreter2 (L2CopyFile (a) (b) ) = do
  (hosta, porta, _, hostb, portb, _) <- ask
  liftIO $ bracket (connectTo hosta (PortNumber (fromIntegral porta))) hClose (\ha -> do
    liftIO $ bracket (connectTo hostb (PortNumber (fromIntegral portb))) hClose (\hb -> do
      remoteSendFile ha a hb b
      sendMsg ha (Exit :: LocalizedCommandWrapper LocalizedFSCommand)
      sendMsg hb (Exit :: LocalizedCommandWrapper LocalizedFSCommand)))
remoteToRemoteInterpreter2 (L2CopyDir (a) (b) ) = do
  (hosta, porta, _, hostb, portb, _) <- ask
  liftIO $ bracket (connectTo hosta (PortNumber (fromIntegral porta))) hClose (\ha -> do
    liftIO $ bracket (connectTo hostb (PortNumber (fromIntegral portb))) hClose (\hb -> do
      remoteSendDir ha a hb b
      sendMsg ha (Exit :: LocalizedCommandWrapper LocalizedFSCommand)
      sendMsg hb (Exit :: LocalizedCommandWrapper LocalizedFSCommand)))
remoteToRemoteInterpreter2 (L2MoveFile (a) (b)) = do
  (hosta, porta, _, hostb, portb, _) <- ask
  liftIO $ bracket (connectTo hosta (PortNumber (fromIntegral porta))) hClose (\ha -> do
    liftIO $ bracket (connectTo hostb (PortNumber (fromIntegral portb))) hClose (\hb -> do
      remoteSendFile ha a hb b
      sendMsg ha (LocalizedCommandWrapper (LUnlinkFile a))
      Just () <- receiveMsg ha
      sendMsg ha (Exit :: LocalizedCommandWrapper LocalizedFSCommand)
      sendMsg hb (Exit :: LocalizedCommandWrapper LocalizedFSCommand)))
remoteToRemoteInterpreter2 (L2MoveDir (a) (b)) = do
  (hosta, porta, _, hostb, portb, _) <- ask
  liftIO $ bracket (connectTo hosta (PortNumber (fromIntegral porta))) hClose (\ha -> do
    liftIO $ bracket (connectTo hostb (PortNumber (fromIntegral portb))) hClose (\hb -> do
      remoteSendDir ha a hb b
      sendMsg ha (LocalizedCommandWrapper (LRemoveDir a))
      Just () <- receiveMsg ha
      sendMsg ha (Exit :: LocalizedCommandWrapper LocalizedFSCommand)
      sendMsg hb (Exit :: LocalizedCommandWrapper LocalizedFSCommand)))

remoteInterpreter :: (MonadIO m, ToJSON a, FromJSON a) => String -> Int -> LocalizedFSCommand a -> m a
remoteInterpreter addr port cmd =
  liftIO $ bracket (connectTo addr (PortNumber (fromIntegral port))) hClose (\h -> do
    sendMsg h (LocalizedCommandWrapper cmd)
    fromMaybe (error "remoteInterpreter: receive message error") <$> receiveMsg h)

makeLocalInterpreter :: String -> Int -> String -> Interpreter
makeLocalInterpreter host port root = Interpreter (\cmd -> runReaderT (localInterpreter cmd) (host, root))

makeRemoteInterpreter :: String -> Int -> String -> Interpreter
makeRemoteInterpreter host port root = Interpreter (remoteInterpreter host port)

makeLocalInterpreter2 :: String -> Int -> String -> String -> Int -> String -> Interpreter2
makeLocalInterpreter2 hosta porta roota hostb portb rootb = Interpreter2 (\cmd -> runReaderT (localInterpreter2 cmd) (hosta, roota))

makeLocalToRemoteInterpreter2 :: String -> Int -> String -> String -> Int -> String -> Interpreter2
makeLocalToRemoteInterpreter2 hosta porta roota hostb portb rootb = Interpreter2 (\cmd -> runReaderT (localToRemoteInterpreter2 cmd) (hosta, porta, roota, hostb, portb, rootb))

makeRemoteToLocalInterpreter2 :: String -> Int -> String -> String -> Int -> String -> Interpreter2
makeRemoteToLocalInterpreter2 hosta porta roota hostb portb rootb = Interpreter2 (\cmd -> runReaderT (remoteToLocalInterpreter2 cmd) (hosta, porta, roota, hostb, portb, rootb))

makeRemoteToRemoteInterpreter2 :: String -> Int -> String -> String -> Int -> String -> Interpreter2
makeRemoteToRemoteInterpreter2 hosta porta roota hostb portb rootb = Interpreter2 (\cmd -> runReaderT (remoteToRemoteInterpreter2 cmd) (hosta, porta, roota, hostb, portb, rootb))
