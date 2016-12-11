{-# LANGUAGE OverloadedStrings #-}

module QueryArrow.FFI.Service.UnixDomainSocket where

import QueryArrow.FO.Data
import QueryArrow.DB.DB
import QueryArrow.DBMap
import QueryArrow.Serialization
import QueryArrow.Config
import QueryArrow.FFI.Service
import QueryArrow.RPC.Message

import Data.Set (fromList)
import Data.Text (pack)
import Control.Exception (SomeException, try)
import Control.Monad.Error.Class (throwError)
import Control.Monad.IO.Class (liftIO)
import System.Log.Logger (infoM, errorM)
import System.IO (Handle, IOMode(..))
import Network.Socket

data UnixDomainSocketServiceSession = UnixDomainSocketServiceSession Handle

unixDomainSocketService :: QueryArrowService UnixDomainSocketServiceSession
unixDomainSocketService  =
  let   getAllResult0 = \(UnixDomainSocketServiceSession  handle) vars form params -> do
            let name = QuerySet {
                          qsquery = Static [Execute form],
                          qsheaders = fromList vars,
                          qsparams = params
                          }
            liftIO $ sendMsg handle name
            rep <- liftIO $ receiveMsg handle
            case rep of
                Just (ResultSet err results) ->
                    if null err
                      then
                          return results
                      else
                          throwError (-1, pack err)
                Nothing ->
                    throwError (-1, "cannot parse response")
  in
          QueryArrowService {
            execQuery =  \(UnixDomainSocketServiceSession  handle ) form params -> do
              let name = QuerySet {
                            qsquery = Static [Execute (form )],
                            qsheaders = mempty,
                            qsparams = params
                            }
              liftIO $ sendMsg handle name
              rep <- liftIO $ receiveMsg handle
              case rep of
                  Just (ResultSet err results) ->
                      if null err
                        then
                            return ()
                        else
                            throwError (-1, pack err)
                  Nothing ->
                      throwError (-1, "cannot parse response"),
            getAllResult = getAllResult0,
            qasConnect = \ path -> do
              handle <- liftIO $ try (do
                  sock <- socket AF_UNIX Stream defaultProtocol
                  connect sock (SockAddrUnix path)
                  socketToHandle sock ReadWriteMode)
              case handle of
                Left e -> throwError (-1, pack (show (e :: SomeException)))
                Right handle ->
                      return (UnixDomainSocketServiceSession  handle  ),
            qasDisconnect = \ (UnixDomainSocketServiceSession handle ) -> do
              let name2 = QuerySet {
                            qsquery = Quit,
                            qsheaders = mempty,
                            qsparams = mempty
                            }
              liftIO $ sendMsg handle name2,
            qasCommit = \ (UnixDomainSocketServiceSession handle ) -> do
              let name2 = QuerySet {
                            qsquery = Static [Commit],
                            qsheaders = mempty,
                            qsparams = mempty
                            }
              liftIO $ sendMsg handle name2
              rep <- liftIO $ receiveMsg handle
              case rep of
                  Just (ResultSet err results) ->
                      if null err
                        then
                            return ()
                        else
                            throwError (-1, pack err)
                  Nothing ->
                      throwError (-1, "cannot parse response"),

            qasRollback = \ (UnixDomainSocketServiceSession handle ) -> do
              let name2 = QuerySet {
                            qsquery = Static [Rollback],
                            qsheaders = mempty,
                            qsparams = mempty
                            }
              liftIO $ sendMsg handle name2
              rep <- liftIO $ receiveMsg handle
              case rep of
                  Just (ResultSet err results) ->
                      if null err
                        then
                            return ()
                        else
                            throwError (-1, pack err)
                  Nothing ->
                      throwError (-1, "cannot parse response")
          }
