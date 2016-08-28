{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
module DB.NoConnection where

import DB.DB

-- interface

class INoConnectionDatabase2 db where
    type NoConnectionQueryType db
    type NoConnectionRowType db
    noConnectionDBStmtExec :: db -> NoConnectionQueryType db -> DBResultStream (NoConnectionRowType db) -> DBResultStream (NoConnectionRowType db)

-- instance for IDatabase

newtype NoConnectionDatabase db = NoConnectionDatabase db

instance (IDatabase0 db) => (IDatabase0 (NoConnectionDatabase db)) where
    getName (NoConnectionDatabase db) = getName db
    getPreds (NoConnectionDatabase db) = getPreds db
    determinateVars (NoConnectionDatabase db) = determinateVars db
    supported (NoConnectionDatabase db) = supported db

instance (IDatabase1 db) => (IDatabase1 (NoConnectionDatabase db)) where
    type DBQueryType (NoConnectionDatabase db) = DBQueryType db
    translateQuery (NoConnectionDatabase db) = translateQuery db

instance (INoConnectionDatabase2 db) => IDatabase2 (NoConnectionDatabase db) where
    type ConnectionType (NoConnectionDatabase db) = NoConnectionDBConnection db
    dbOpen (NoConnectionDatabase db) = return (NoConnectionDBConnection db)

instance (IDatabase0 db, IDatabase1 db, INoConnectionDatabase2 db, DBQueryType db ~ NoConnectionQueryType db) => IDatabase (NoConnectionDatabase db) where

-- instance for IDBConnection
newtype NoConnectionDBConnection db = NoConnectionDBConnection db

instance IDBConnection0 (NoConnectionDBConnection db) where
    dbClose _ = return ()
    dbBegin _ = return ()
    dbCommit _ = return True
    dbPrepare _ = return True
    dbRollback _ = return ()

instance (INoConnectionDatabase2 db) => IDBConnection (NoConnectionDBConnection db) where
    type QueryType (NoConnectionDBConnection db) = NoConnectionQueryType db
    type StatementType (NoConnectionDBConnection db) = NoConnectionDBStatement db
    prepareQuery (NoConnectionDBConnection db) qu = return (NoConnectionDBStatement db qu)

-- instance for IDBStatement

data NoConnectionDBStatement db = NoConnectionDBStatement db (NoConnectionQueryType db)

instance (INoConnectionDatabase2 db) => IDBStatement (NoConnectionDBStatement db) where
    type RowType (NoConnectionDBStatement db) = NoConnectionRowType db
    dbStmtClose _ = return ()
    dbStmtExec (NoConnectionDBStatement db  qu ) = noConnectionDBStmtExec db  qu
