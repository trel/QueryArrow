# QueryArrow

QueryArrow is motivated by the following applications: bidirectional metadata integration from different metadata sources, metadata policies, metadata migration from different databases, metadata indexing.

QueryArrow provides a systematic solution to shared namespace and unshared namespace federation of metadata. In particular, QueryArrow allows querying multiple zones and multiple data sources including NoSQL databases, and updating data sources. For data sources that support two-phase commit, QueryArrow also supports distributed transactions. QueryArrow also enables poly-fill for features that the underlying database does not support.

A QueryArrow instance includes a QueryArrow Service and QueryArrow plugins. Each plugin provides interface with one database. Currently, the implemented databases include PostgreSQL, SQLite, Neo4j, ElasticSearch, and various in-memory data structures. The message protocol is defined in JSONRPC. The queries are issued from the client in the QueryArrow Language. QAL is a unified querying language for SQL and noSQL databases.

Slides: https://irods.org/uploads/2016/06/queryarrow2_Hao-Xu_DICE_iRODS-UGM-2016.pdf

Technical Report: https://irods.org/uploads/2015/01/xu-queryarrow-2016.pdf

For the latest version please see the development branch.
