{-# LANGUAGE TypeFamilies, FlexibleInstances #-}
module QueryArrow.SQL.HDBC.Sqlite3 where

import QueryArrow.FO.Data
import QueryArrow.DB.GenericDatabase
import QueryArrow.DB.DB
import QueryArrow.Config
import QueryArrow.SQL.HDBC
import QueryArrow.SQL.SQL
import QueryArrow.SQL.ICAT

import Database.HDBC.Sqlite3

newtype SQLiteDB = SQLiteDB ICATDBConnInfo

instance IDatabase2 (GenericDatabase  SQLTrans SQLiteDB) where
    newtype ConnectionType (GenericDatabase  SQLTrans SQLiteDB) = SQLite HDBCDBConnection
    dbOpen (GenericDatabase  _ (SQLiteDB ps) _ _) = do
        conn <- connectSqlite3 (db_name ps)
        return (SQLite (HDBCDBConnection conn))

instance IDBConnection0 (ConnectionType (GenericDatabase  SQLTrans SQLiteDB)) where
    dbBegin (SQLite conn) = dbBegin conn
    dbPrepare (SQLite conn) = dbPrepare conn
    dbRollback (SQLite conn) = dbRollback conn
    dbCommit (SQLite conn) = dbCommit conn
    dbClose (SQLite conn) = dbClose conn

instance IDBConnection (ConnectionType (GenericDatabase  SQLTrans SQLiteDB)) where
    type QueryType (ConnectionType (GenericDatabase  SQLTrans SQLiteDB)) = QueryType HDBCDBConnection
    type StatementType (ConnectionType (GenericDatabase  SQLTrans SQLiteDB)) = StatementType HDBCDBConnection
    prepareQuery (SQLite conn) = prepareQuery conn

instance IDatabase (GenericDatabase  SQLTrans SQLiteDB)

getDB :: ICATDBConnInfo -> IO (AbstractDatabase MapResultRow Formula)
getDB ps =
    let db = makeICATSQLDBAdapter (db_namespace ps) (db_icat ps) Nothing (SQLiteDB ps) in
        AbstractDatabase <$> db