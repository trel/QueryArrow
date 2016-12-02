
import Distribution.Simple
import Distribution.PackageDescription
import System.Directory
import System.Process
import System.IO

replace :: Eq a => [a] -> [a] -> [a] -> [a]
replace [] _ _ = []
replace s@(h : t) find repl =
    if take (length find) s == find
        then repl ++ replace (drop (length find) s) find repl
        else h : replace t find repl

main = defaultMainWithHooks simpleUserHooks {
            preConf = \_ _ -> do
                createDirectoryIfMissing True "gen"
                createDirectoryIfMissing True "gen/SQL"
                copyFile "schema.sql" "gen/schema.sql"
                add <- readFile "phatom.sql"
                withFile "gen/schema.sql" AppendMode $ \handle ->
                    hPutStrLn handle add
                return emptyHookedBuildInfo,
            postBuild = \_ _ _ _ -> do
                callCommand "stack exec schema_parser_main"
                createDirectoryIfMissing True "etc"
                createDirectoryIfMissing True "etc/QueryArrow"
                createDirectoryIfMissing True "etc/QueryArrow/gen"
                createDirectoryIfMissing True "etc/QueryArrow/gen/SQL"
                copyFile "gen/ICATGen" "etc/QueryArrow/gen/ICATGen"
                copyFile "gen/SQL/ICATGen" "etc/QueryArrow/gen/SQL/ICATGen"
                copyFile "rewriting-plugin-common.rules" "etc/QueryArrow/rewriting-plugin-common.rules"
                copyFile "rewriting-plugin.rules" "etc/QueryArrow/rewriting-plugin.rules"
                conf <- readFile "tdb-plugin-gen.json"
                writeFile "etc/QueryArrow/tdb-plugin-gen-abs.json" (replace conf "../QueryArrow-gen" "/etc/irods/QueryArrow")
                ,
            postClean = \_ _ _ _ -> do
                removeDirectoryRecursive "gen"
                removeDirectoryRecursive "etc"
      }