CC=/opt/irods-externals/clang3.8-0/bin/clang
OUT=a.out
STACK_DIR=/home/xuh/.stack
PROJECT_STACK_WORK_DIR=/home/xuh/git/QueryArrow/.stack-work
SUBPROJECT_STACK_WORK_DIR=/home/xuh/git/QueryArrow/QueryArrow-c/.stack-work
TMP_DIR=/tmp/ghc28714_0

LIB=$PROJECT_STACK_WORK_DIR/install/x86_64-linux/nightly-2016-08-27/8.0.1/lib
INCLUDE=$SUBPROJECT_STACK_WORK_DIR/dist/x86_64-linux/Cabal-1.24.0.0/build/Client/
STACK_LIB=$STACK_DIR/snapshots/x86_64-linux/nightly-2016-08-27/8.0.1/lib
GHC_LIB=$STACK_DIR/programs/x86_64-linux/ghc-8.0.1/lib

mkdir $TMP_DIR
$CC -fno-stack-protector -DTABLES_NEXT_TO_CODE test/test.cpp -o test/test.o -c "-D__GLASGOW_HASKELL__=800" -include $GHC_LIB/ghc-8.0.1/include/ghcversion.h -I$INCLUDE/ -I$STACK_LIB/x86_64-linux-ghc-8.0.1/unix-compat-0.4.2.0-GNHotEMWE5dJ4oYFhgibIV/include -I$STACK_LIB/x86_64-linux-ghc-8.0.1/vector-algorithms-0.7.0.1-8R8UpWgvBC926XMxBjYPpx/include -I$GHC_LIB/ghc-8.0.1/process-1.4.2.0/include -I$STACK_LIB/x86_64-linux-ghc-8.0.1/network-2.6.3.1-G4Up1CPKbp7DeFsnywOnGG/include -I$GHC_LIB/ghc-8.0.1/directory-1.2.6.2/include -I$GHC_LIB/ghc-8.0.1/unix-2.7.2.0/include -I$STACK_LIB/x86_64-linux-ghc-8.0.1/vector-0.11.0.0-BEDZb5o2QOhGbIm6ky7rl6/include -I$STACK_LIB/x86_64-linux-ghc-8.0.1/primitive-0.6.1.0-Ip44DqhfCp21tTUYbecwa/include -I/usr/include/postgresql -I$GHC_LIB/ghc-8.0.1/time-1.6.0.1/include -I$STACK_LIB/x86_64-linux-ghc-8.0.1/old-time-1.1.0.3-IcvdkJUsE9M8t3io8peAEp/include -I$GHC_LIB/ghc-8.0.1/bytestring-0.10.8.1/include -I$GHC_LIB/ghc-8.0.1/base-4.9.0.0/include -I$GHC_LIB/ghc-8.0.1/integer-gmp-1.0.0.1/include -I$GHC_LIB/ghc-8.0.1/include
$CC -fno-stack-protector -DTABLES_NEXT_TO_CODE "-Wl,--hash-size=31" -Wl,--reduce-memory-overheads -Wl,--no-as-needed -o $OUT -Wl,--gc-sections test/test.o -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-c-0.2-KfZxv3eqKiM4J3p8senT8P -L$LIB/x86_64-linux-ghc-8.0.1/json-rpc-0.7.1.1-DALEdSwpIhA2EDvYKkr6sD -L$STACK_LIB/x86_64-linux-ghc-8.0.1/stm-conduit-3.0.0-FmihuUu6yqALkTUNKGp7MH -L$STACK_LIB/x86_64-linux-ghc-8.0.1/cereal-conduit-0.7.3-7nNHDm7Cass33i2pssH4zD -L$STACK_LIB/x86_64-linux-ghc-8.0.1/QuickCheck-2.8.2-B7cXgOk7OAiKrNRsk2SfuA -L$STACK_LIB/x86_64-linux-ghc-8.0.1/tf-random-0.5-4z8OJUaXC1FRNfrLPFWAD -L$STACK_LIB/x86_64-linux-ghc-8.0.1/either-4.4.1.1-1JTyD8xndhVAzIXQKhnRWZ -L$STACK_LIB/x86_64-linux-ghc-8.0.1/free-4.12.4-Etm59Dm8iExFxAy1L49Ovd -L$STACK_LIB/x86_64-linux-ghc-8.0.1/profunctors-5.2-2ZZOz6u59T2H8y7z3NgZkY -L$STACK_LIB/x86_64-linux-ghc-8.0.1/prelude-extras-0.4.0.3-FAyB4iuuM7cHXdrLMZtdXq -L$STACK_LIB/x86_64-linux-ghc-8.0.1/MonadRandom-0.4.2.3-8TfCm6PGvGYB7omozORhov -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-0.2-AwWfhTa7rzy5yPZqo27bJk -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-elastic-0.2-B33HXxqvD2TFeA0kE1LEKE -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-cypher-0.2-9hAWJLC9PUK7JlWBbUdaOe -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-sql-0.2-F1LAEJpCt4G7fZKbwbV8fw -L$LIB/x86_64-linux-ghc-8.0.1/QueryArrow-common-0.2-GEXHPDEpizOH1QjiPBFOFM -L$STACK_LIB/x86_64-linux-ghc-8.0.1/temporary-1.2.0.4-HrDpr7Xe8eIBlscuzEzXU8 -L$LIB/x86_64-linux-ghc-8.0.1/semibounded-lattices-0.1.0.0-3dwNufoaJP39FcqlZZU2kg -L$STACK_LIB/x86_64-linux-ghc-8.0.1/regex-tdfa-1.2.2-CO0fXSt7Xnx5AlZ7P2gfGO -L$STACK_LIB/x86_64-linux-ghc-8.0.1/regex-base-0.93.2-4lnOy3Rb1yfISFVEXVfJuH -L$LIB/x86_64-linux-ghc-8.0.1/pretty-tree-0.1.0.0-6LADUhScs5A6wG5szLpj3U -L$STACK_LIB/x86_64-linux-ghc-8.0.1/boxes-0.1.4-ydFzVDNbCb4CfN035tEOs -L$LIB/x86_64-linux-ghc-8.0.1/namespace-0.1.2.2-5KOCFhpRwdlLp96736NXGe -L$STACK_LIB/x86_64-linux-ghc-8.0.1/monoid-extras-0.4.2-LjGObJRfuUu4gkxpds80ad -L$STACK_LIB/x86_64-linux-ghc-8.0.1/semigroupoids-5.1-1Gay4xNO77GHd4DGCzVuax -L$STACK_LIB/x86_64-linux-ghc-8.0.1/bifunctors-5.4.1-8Xk5Wsnk1fr6rBLkW9MO8p -L$STACK_LIB/x86_64-linux-ghc-8.0.1/comonad-5-2RMxpSOQ5MCHLHIelJrHD4 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/groups-0.4.0.0-53wMJ09LBR64aEJqWveBMG -L$STACK_LIB/x86_64-linux-ghc-8.0.1/monad-logger-0.3.19-A8qqNnymrtH4Tf9zSEO1J7 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/stm-chans-3.0.0.4-4lLWE8CZnvmDZJW5bKkus1 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/monad-loops-0.4.3-1xZFtRVMQPC4X8bjTBWqNi -L$STACK_LIB/x86_64-linux-ghc-8.0.1/lrucache-1.2.0.0-LDgHNBqTbkhHTMOg9pBnzo -L$STACK_LIB/x86_64-linux-ghc-8.0.1/contravariant-1.4-KSQE31a7FruKHDlp90hIUT -L$STACK_LIB/x86_64-linux-ghc-8.0.1/StateVar-1.1.0.4-CJpWsiXJdd89SnV9dZtTwc -L$STACK_LIB/x86_64-linux-ghc-8.0.1/lifted-async-0.9.0-A2kAwJyRgo5AbnQklsdBhW -L$STACK_LIB/x86_64-linux-ghc-8.0.1/lattices-1.5.0-KUsDbNZZp6hI5uXqZjKc0L -L$STACK_LIB/x86_64-linux-ghc-8.0.1/universe-reverse-instances-1.0-6rRjknOcBXkF2xShQQsEFN -L$STACK_LIB/x86_64-linux-ghc-8.0.1/universe-instances-base-1.0-E49NVHLQYsIE6WsKRGVEV7 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/universe-base-1.0.2.1-CNlPIeO8jYu5rCkfXmhZeC -L$STACK_LIB/x86_64-linux-ghc-8.0.1/hslogger-1.2.10-6Ih3VN3QBbAJ6pLH6h3KNu -L$STACK_LIB/x86_64-linux-ghc-8.0.1/haskell-neo4j-client-0.3.2.2-1MQc8yEq4vXHC8Fz7aZSAX -L$STACK_LIB/x86_64-linux-ghc-8.0.1/http-conduit-2.1.11-GcpHzUxymmsGLKkwvcrZDD -L$STACK_LIB/x86_64-linux-ghc-8.0.1/http-client-tls-0.2.4.1-8SZAtUpixIa64KC2Y1BaqY -L$STACK_LIB/x86_64-linux-ghc-8.0.1/connection-0.2.6-DzS0J3ixtHt1f6ZukV0ybq -L$STACK_LIB/x86_64-linux-ghc-8.0.1/x509-system-1.6.3-AWECJzZrFCw48p10OA247W -L$STACK_LIB/x86_64-linux-ghc-8.0.1/tls-1.3.8-EyYecWXCCcwFFlZGLcsDnd -L$STACK_LIB/x86_64-linux-ghc-8.0.1/x509-validation-1.6.3-VH6CFDdrNg5jurwWdibQA -L$STACK_LIB/x86_64-linux-ghc-8.0.1/x509-store-1.6.1-9f2ixDQ5BjLAk5DAvT0mZF -L$STACK_LIB/x86_64-linux-ghc-8.0.1/x509-1.6.3-GCZSm8eIEnoA0DKyX1w2Ng -L$STACK_LIB/x86_64-linux-ghc-8.0.1/pem-0.2.2-qPMQP6sZm3HgQEmiBojNt -L$STACK_LIB/x86_64-linux-ghc-8.0.1/asn1-parse-0.9.4-Ai83ACtrOir9VlSOQtWm2F -L$STACK_LIB/x86_64-linux-ghc-8.0.1/cryptonite-0.19-G9PYO4oOEqhDTta2u9rAaU -L$STACK_LIB/x86_64-linux-ghc-8.0.1/asn1-encoding-0.9.4-2Zu5ldLYD571Aw26w0CWF6 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/asn1-types-0.3.2-4Rz223aP8OG6vnHYiLX5Ab -L$STACK_LIB/x86_64-linux-ghc-8.0.1/memory-0.13-ABHR5331zHK9scHPRr7afU -L$STACK_LIB/x86_64-linux-ghc-8.0.1/hourglass-0.2.10-I8h0J4RSF89FN6CuD9x2Xx -L$STACK_LIB/x86_64-linux-ghc-8.0.1/socks-0.5.5-7NKerosohUG4pHD8gUq0E5 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/cereal-0.5.3.0-90KodwwwQanJlL7equBhpB -L$STACK_LIB/x86_64-linux-ghc-8.0.1/byteable-0.1.1-15aIBCArSOBEnGxArzrDTM -L$STACK_LIB/x86_64-linux-ghc-8.0.1/http-client-0.4.31-EtMkQGbmVDqHa3C57PSazL -L$STACK_LIB/x86_64-linux-ghc-8.0.1/mime-types-0.1.0.7-AxQ64wFjikqCSdK5pSeZvh -L$STACK_LIB/x86_64-linux-ghc-8.0.1/http-types-0.9.1-8WdUZL4twHzANJbxvb1Aoj -L$STACK_LIB/x86_64-linux-ghc-8.0.1/cookie-0.4.2.1-2a2c54yIyBn79Ul3iLWclJ -L$STACK_LIB/x86_64-linux-ghc-8.0.1/case-insensitive-1.2.0.7-FlqweN7AuKj9EdU2arVEt4 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/data-default-0.7.1.1-99zaIaOz4j8LUpg62Od57E -L$STACK_LIB/x86_64-linux-ghc-8.0.1/data-default-instances-old-locale-0.0.1-LPOHPEJCJUa53W1ZYaHB84 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/data-default-instances-dlist-0.0.1-7k37ZjwAez2H7U006Q5IwN -L$STACK_LIB/x86_64-linux-ghc-8.0.1/data-default-instances-containers-0.0.1-B3LqdWnlDzL8N7WtQnkQ3T -L$STACK_LIB/x86_64-linux-ghc-8.0.1/data-default-class-0.1.2.0-FYQpjIylblBDctdkHAFeXA -L$STACK_LIB/x86_64-linux-ghc-8.0.1/HTTP-4000.3.3-JMFhmeoXqbBIjfEWxmijf9 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/network-uri-2.6.1.0-DDHh2FNiPirBRgkuU9DEt2 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/fast-logger-2.4.6-9mTBkHskOtX7fGXEBoWp8d -L$STACK_LIB/x86_64-linux-ghc-8.0.1/unix-time-0.3.6-6bZ4vlHgZbL8E5DKeI2fRH -L$STACK_LIB/x86_64-linux-ghc-8.0.1/easy-file-0.2.1-bAUkz2rC2kFhBbPjw2Of5 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/auto-update-0.1.4-GAesfFmqoZzBz6e09kRyzb -L$STACK_LIB/x86_64-linux-ghc-8.0.1/distributive-0.5.0.2-Cdz2vLOk85j1doGXLcictT -L$STACK_LIB/x86_64-linux-ghc-8.0.1/base-orphans-0.5.4-5IQvrjd7gNP548VkOOyIq6 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/constraints-0.8-TnnsQszZRE8WMQ5EHvEJ -L$STACK_LIB/x86_64-linux-ghc-8.0.1/conduit-combinators-1.0.4-HUAfG80tT0lDAZgSVnjvAB -L$STACK_LIB/x86_64-linux-ghc-8.0.1/void-0.7.1-DMDx4oiJSktE01vWZZ8Wjg -L$STACK_LIB/x86_64-linux-ghc-8.0.1/unix-compat-0.4.2.0-GNHotEMWE5dJ4oYFhgibIV -L$STACK_LIB/x86_64-linux-ghc-8.0.1/mwc-random-0.13.4.0-CH6ozsPFZjwVSNwmEz44J -L$STACK_LIB/x86_64-linux-ghc-8.0.1/mono-traversable-1.0.0.1-AstmkKq4X4MO5rWRXQplz -L$STACK_LIB/x86_64-linux-ghc-8.0.1/vector-algorithms-0.7.0.1-8R8UpWgvBC926XMxBjYPpx -L$STACK_LIB/x86_64-linux-ghc-8.0.1/split-0.2.3.1-IJKK4pOCYGKud0jZImZke -L$STACK_LIB/x86_64-linux-ghc-8.0.1/conduit-extra-1.1.13.2-HFYphC0EojhHqAnIEx6Pp5 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/streaming-commons-0.1.15.5-JQkoaJB2sOVLY7vO4kOB5z -L$STACK_LIB/x86_64-linux-ghc-8.0.1/zlib-0.6.1.1-4cYT5jyS3jw6zZyCUZMz3T -L$STACK_LIB/x86_64-linux-ghc-8.0.1/random-1.1-54KmMHXjttlERYcr1mvsAe -L$GHC_LIB/ghc-8.0.1/process-1.4.2.0 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/network-2.6.3.1-G4Up1CPKbp7DeFsnywOnGG -L$GHC_LIB/ghc-8.0.1/directory-1.2.6.2 -L$GHC_LIB/ghc-8.0.1/unix-2.7.2.0 -L$GHC_LIB/ghc-8.0.1/filepath-1.4.1.0 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/blaze-builder-0.4.0.2-KWDLbdBYSBoALiMW0LHIz1 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/chunked-data-0.3.0-F6p3z5B8kkI7AcvABkOpCw -L$STACK_LIB/x86_64-linux-ghc-8.0.1/semigroups-0.18.2-2lmUSJvrDkM6JBURGRclWz -L$STACK_LIB/x86_64-linux-ghc-8.0.1/base64-bytestring-1.0.0.1-In9M41tLtcS9QYt3QpGpNY -L$STACK_LIB/x86_64-linux-ghc-8.0.1/base16-bytestring-0.1.1.6-5dPoF8dzhwzBaEB2MvnmIS -L$STACK_LIB/x86_64-linux-ghc-8.0.1/conduit-1.2.7-AT81Epeipx6C4wqHn3FXor -L$STACK_LIB/x86_64-linux-ghc-8.0.1/resourcet-1.1.7.5-Gsc14LtMBpp2sQtbjwGHLc -L$STACK_LIB/x86_64-linux-ghc-8.0.1/mmorph-1.0.6-3xsw6wg6Vs2JmwrJVsaYA0 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/lifted-base-0.2.3.8-KLkd0w1UJqu6nE8oVTTEBy -L$STACK_LIB/x86_64-linux-ghc-8.0.1/monad-control-1.0.1.0-HoNEBoNfniX3vjSfkI7WTT -L$STACK_LIB/x86_64-linux-ghc-8.0.1/transformers-base-0.4.4-25SoAegOdaF8rLEnnb5jPI -L$STACK_LIB/x86_64-linux-ghc-8.0.1/exceptions-0.8.3-7py7fmRxowDFpHmiHGKrTb -L$STACK_LIB/x86_64-linux-ghc-8.0.1/async-2.1.0-J6Pl8k3L4PKGEpjYdgwiIf -L$STACK_LIB/x86_64-linux-ghc-8.0.1/stm-2.4.4.1-4z2NRWnB0NIIUvSJsHW0kF -L$STACK_LIB/x86_64-linux-ghc-8.0.1/aeson-0.11.2.1-38JNNmpSV1dJgfHtWC9nlh -L$STACK_LIB/x86_64-linux-ghc-8.0.1/unordered-containers-0.2.7.1-Eo9jd5DMz45DhBLCG8skzW -L$STACK_LIB/x86_64-linux-ghc-8.0.1/tagged-0.8.5-CtgV6EcN0do8F92i1S6iYx -L$STACK_LIB/x86_64-linux-ghc-8.0.1/transformers-compat-0.5.1.4-81lZyuOJOvsD0zyCv2TKld -L$GHC_LIB/ghc-8.0.1/template-haskell-2.11.0.0 -L$GHC_LIB/ghc-8.0.1/pretty-1.1.3.3 -L$GHC_LIB/ghc-8.0.1/ghc-boot-th-8.0.1 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/syb-0.6-C65vWCsht6A8uLstpQIXyj -L$STACK_LIB/x86_64-linux-ghc-8.0.1/dlist-0.8.0.1-8vOZASaQM8T5SLbodsdvHz -L$STACK_LIB/x86_64-linux-ghc-8.0.1/attoparsec-0.13.0.2-GLM6q4XQBSiI4fJOXoBxlu -L$STACK_LIB/x86_64-linux-ghc-8.0.1/scientific-0.3.4.9-6oTYuCcx6H5BsTGU7D2Gk3 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/vector-0.11.0.0-BEDZb5o2QOhGbIm6ky7rl6 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/primitive-0.6.1.0-Ip44DqhfCp21tTUYbecwa -L$STACK_LIB/x86_64-linux-ghc-8.0.1/hashable-1.2.4.0-EMu4H7FB10MAl6hwKw992G -L$LIB/x86_64-linux-ghc-8.0.1/HDBC-sqlite3-2.3.3.1-wMqMSnNcWm14lydzBEmTX -L$LIB/x86_64-linux-ghc-8.0.1/HDBC-postgresql-2.3.2.3-HaNwbkTFH0cIme8ibesQy9 -L/usr/lib/x86_64-linux-gnu -L$STACK_LIB/x86_64-linux-ghc-8.0.1/parsec-3.1.11-BCos4GEVCuDB8dnOCBHO6X -L$STACK_LIB/x86_64-linux-ghc-8.0.1/HDBC-2.4.0.1-4RVX8kLUuxOI95AL10vhvV -L$STACK_LIB/x86_64-linux-ghc-8.0.1/utf8-string-1.0.1.1-2T8mBCuEDlXDo8zed8Onw4 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/convertible-1.1.1.0-LKSEHOqRPBWL4CrSDoQYvh -L$GHC_LIB/ghc-8.0.1/time-1.6.0.1 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/text-1.2.2.1-5QpmrLQApEZ4Ly9nMHWY0s -L$GHC_LIB/ghc-8.0.1/binary-0.8.3.0 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/old-time-1.1.0.3-IcvdkJUsE9M8t3io8peAEp -L$STACK_LIB/x86_64-linux-ghc-8.0.1/old-locale-1.0.0.7-6glXNhHF891B41ZfuI8hU8 -L$STACK_LIB/x86_64-linux-ghc-8.0.1/mtl-2.2.1-6qsR1PHUy5lL47Hpoa4jCM -L$GHC_LIB/ghc-8.0.1/transformers-0.5.2.0 -L$GHC_LIB/ghc-8.0.1/containers-0.5.7.1 -L$GHC_LIB/ghc-8.0.1/bytestring-0.10.8.1 -L$GHC_LIB/ghc-8.0.1/deepseq-1.4.2.0 -L$GHC_LIB/ghc-8.0.1/array-0.5.1.1 -L$GHC_LIB/ghc-8.0.1/base-4.9.0.0 -L$GHC_LIB/ghc-8.0.1/integer-gmp-1.0.0.1 -L$GHC_LIB/ghc-8.0.1/ghc-prim-0.5.0.0 -L$GHC_LIB/ghc-8.0.1/rts -Wl,-u,ghczmprim_GHCziTypes_Izh_static_info -Wl,-u,ghczmprim_GHCziTypes_Czh_static_info -Wl,-u,ghczmprim_GHCziTypes_Fzh_static_info -Wl,-u,ghczmprim_GHCziTypes_Dzh_static_info -Wl,-u,base_GHCziPtr_Ptr_static_info -Wl,-u,ghczmprim_GHCziTypes_Wzh_static_info -Wl,-u,base_GHCziInt_I8zh_static_info -Wl,-u,base_GHCziInt_I16zh_static_info -Wl,-u,base_GHCziInt_I32zh_static_info -Wl,-u,base_GHCziInt_I64zh_static_info -Wl,-u,base_GHCziWord_W8zh_static_info -Wl,-u,base_GHCziWord_W16zh_static_info -Wl,-u,base_GHCziWord_W32zh_static_info -Wl,-u,base_GHCziWord_W64zh_static_info -Wl,-u,base_GHCziStable_StablePtr_static_info -Wl,-u,ghczmprim_GHCziTypes_Izh_con_info -Wl,-u,ghczmprim_GHCziTypes_Czh_con_info -Wl,-u,ghczmprim_GHCziTypes_Fzh_con_info -Wl,-u,ghczmprim_GHCziTypes_Dzh_con_info -Wl,-u,base_GHCziPtr_Ptr_con_info -Wl,-u,base_GHCziPtr_FunPtr_con_info -Wl,-u,base_GHCziStable_StablePtr_con_info -Wl,-u,ghczmprim_GHCziTypes_False_closure -Wl,-u,ghczmprim_GHCziTypes_True_closure -Wl,-u,base_GHCziPack_unpackCString_closure -Wl,-u,base_GHCziIOziException_stackOverflow_closure -Wl,-u,base_GHCziIOziException_heapOverflow_closure -Wl,-u,base_ControlziExceptionziBase_nonTermination_closure -Wl,-u,base_GHCziIOziException_blockedIndefinitelyOnMVar_closure -Wl,-u,base_GHCziIOziException_blockedIndefinitelyOnSTM_closure -Wl,-u,base_GHCziIOziException_allocationLimitExceeded_closure -Wl,-u,base_ControlziExceptionziBase_nestedAtomically_closure -Wl,-u,base_GHCziEventziThread_blockedOnBadFD_closure -Wl,-u,base_GHCziWeak_runFinalizzerBatch_closure -Wl,-u,base_GHCziTopHandler_flushStdHandles_closure -Wl,-u,base_GHCziTopHandler_runIO_closure -Wl,-u,base_GHCziTopHandler_runNonIO_closure -Wl,-u,base_GHCziConcziIO_ensureIOManagerIsRunning_closure -Wl,-u,base_GHCziConcziIO_ioManagerCapabilitiesChanged_closure -Wl,-u,base_GHCziConcziSync_runSparks_closure -Wl,-u,base_GHCziConcziSignal_runHandlersPtr_closure -lHSQueryArrow-c-0.2-KfZxv3eqKiM4J3p8senT8P -lHSjson-rpc-0.7.1.1-DALEdSwpIhA2EDvYKkr6sD -lHSstm-conduit-3.0.0-FmihuUu6yqALkTUNKGp7MH -lHScereal-conduit-0.7.3-7nNHDm7Cass33i2pssH4zD -lHSQuickCheck-2.8.2-B7cXgOk7OAiKrNRsk2SfuA -lHStf-random-0.5-4z8OJUaXC1FRNfrLPFWAD -lHSeither-4.4.1.1-1JTyD8xndhVAzIXQKhnRWZ -lHSfree-4.12.4-Etm59Dm8iExFxAy1L49Ovd -lHSprofunctors-5.2-2ZZOz6u59T2H8y7z3NgZkY -lHSprelude-extras-0.4.0.3-FAyB4iuuM7cHXdrLMZtdXq -lHSMonadRandom-0.4.2.3-8TfCm6PGvGYB7omozORhov -lHSQueryArrow-0.2-AwWfhTa7rzy5yPZqo27bJk -lHSQueryArrow-elastic-0.2-B33HXxqvD2TFeA0kE1LEKE -lHSQueryArrow-cypher-0.2-9hAWJLC9PUK7JlWBbUdaOe -lHSQueryArrow-sql-0.2-F1LAEJpCt4G7fZKbwbV8fw -lHSQueryArrow-common-0.2-GEXHPDEpizOH1QjiPBFOFM -lHStemporary-1.2.0.4-HrDpr7Xe8eIBlscuzEzXU8 -lHSsemibounded-lattices-0.1.0.0-3dwNufoaJP39FcqlZZU2kg -lHSregex-tdfa-1.2.2-CO0fXSt7Xnx5AlZ7P2gfGO -lHSregex-base-0.93.2-4lnOy3Rb1yfISFVEXVfJuH -lHSpretty-tree-0.1.0.0-6LADUhScs5A6wG5szLpj3U -lHSboxes-0.1.4-ydFzVDNbCb4CfN035tEOs -lHSnamespace-0.1.2.2-5KOCFhpRwdlLp96736NXGe -lHSmonoid-extras-0.4.2-LjGObJRfuUu4gkxpds80ad -lHSsemigroupoids-5.1-1Gay4xNO77GHd4DGCzVuax -lHSbifunctors-5.4.1-8Xk5Wsnk1fr6rBLkW9MO8p -lHScomonad-5-2RMxpSOQ5MCHLHIelJrHD4 -lHSgroups-0.4.0.0-53wMJ09LBR64aEJqWveBMG -lHSmonad-logger-0.3.19-A8qqNnymrtH4Tf9zSEO1J7 -lHSstm-chans-3.0.0.4-4lLWE8CZnvmDZJW5bKkus1 -lHSmonad-loops-0.4.3-1xZFtRVMQPC4X8bjTBWqNi -lHSlrucache-1.2.0.0-LDgHNBqTbkhHTMOg9pBnzo -lHScontravariant-1.4-KSQE31a7FruKHDlp90hIUT -lHSStateVar-1.1.0.4-CJpWsiXJdd89SnV9dZtTwc -lHSlifted-async-0.9.0-A2kAwJyRgo5AbnQklsdBhW -lHSlattices-1.5.0-KUsDbNZZp6hI5uXqZjKc0L -lHSuniverse-reverse-instances-1.0-6rRjknOcBXkF2xShQQsEFN -lHSuniverse-instances-base-1.0-E49NVHLQYsIE6WsKRGVEV7 -lHSuniverse-base-1.0.2.1-CNlPIeO8jYu5rCkfXmhZeC -lHShslogger-1.2.10-6Ih3VN3QBbAJ6pLH6h3KNu -lHShaskell-neo4j-client-0.3.2.2-1MQc8yEq4vXHC8Fz7aZSAX -lHShttp-conduit-2.1.11-GcpHzUxymmsGLKkwvcrZDD -lHShttp-client-tls-0.2.4.1-8SZAtUpixIa64KC2Y1BaqY -lHSconnection-0.2.6-DzS0J3ixtHt1f6ZukV0ybq -lHSx509-system-1.6.3-AWECJzZrFCw48p10OA247W -lHStls-1.3.8-EyYecWXCCcwFFlZGLcsDnd -lHSx509-validation-1.6.3-VH6CFDdrNg5jurwWdibQA -lHSx509-store-1.6.1-9f2ixDQ5BjLAk5DAvT0mZF -lHSx509-1.6.3-GCZSm8eIEnoA0DKyX1w2Ng -lHSpem-0.2.2-qPMQP6sZm3HgQEmiBojNt -lHSasn1-parse-0.9.4-Ai83ACtrOir9VlSOQtWm2F -lHScryptonite-0.19-G9PYO4oOEqhDTta2u9rAaU -lHSasn1-encoding-0.9.4-2Zu5ldLYD571Aw26w0CWF6 -lHSasn1-types-0.3.2-4Rz223aP8OG6vnHYiLX5Ab -lHSmemory-0.13-ABHR5331zHK9scHPRr7afU -lHShourglass-0.2.10-I8h0J4RSF89FN6CuD9x2Xx -lHSsocks-0.5.5-7NKerosohUG4pHD8gUq0E5 -lHScereal-0.5.3.0-90KodwwwQanJlL7equBhpB -lHSbyteable-0.1.1-15aIBCArSOBEnGxArzrDTM -lHShttp-client-0.4.31-EtMkQGbmVDqHa3C57PSazL -lHSmime-types-0.1.0.7-AxQ64wFjikqCSdK5pSeZvh -lHShttp-types-0.9.1-8WdUZL4twHzANJbxvb1Aoj -lHScookie-0.4.2.1-2a2c54yIyBn79Ul3iLWclJ -lHScase-insensitive-1.2.0.7-FlqweN7AuKj9EdU2arVEt4 -lHSdata-default-0.7.1.1-99zaIaOz4j8LUpg62Od57E -lHSdata-default-instances-old-locale-0.0.1-LPOHPEJCJUa53W1ZYaHB84 -lHSdata-default-instances-dlist-0.0.1-7k37ZjwAez2H7U006Q5IwN -lHSdata-default-instances-containers-0.0.1-B3LqdWnlDzL8N7WtQnkQ3T -lHSdata-default-class-0.1.2.0-FYQpjIylblBDctdkHAFeXA -lHSHTTP-4000.3.3-JMFhmeoXqbBIjfEWxmijf9 -lHSnetwork-uri-2.6.1.0-DDHh2FNiPirBRgkuU9DEt2 -lHSfast-logger-2.4.6-9mTBkHskOtX7fGXEBoWp8d -lHSunix-time-0.3.6-6bZ4vlHgZbL8E5DKeI2fRH -lHSeasy-file-0.2.1-bAUkz2rC2kFhBbPjw2Of5 -lHSauto-update-0.1.4-GAesfFmqoZzBz6e09kRyzb -lHSdistributive-0.5.0.2-Cdz2vLOk85j1doGXLcictT -lHSbase-orphans-0.5.4-5IQvrjd7gNP548VkOOyIq6 -lHSconstraints-0.8-TnnsQszZRE8WMQ5EHvEJ -lHSconduit-combinators-1.0.4-HUAfG80tT0lDAZgSVnjvAB -lHSvoid-0.7.1-DMDx4oiJSktE01vWZZ8Wjg -lHSunix-compat-0.4.2.0-GNHotEMWE5dJ4oYFhgibIV -lHSmwc-random-0.13.4.0-CH6ozsPFZjwVSNwmEz44J -lHSmono-traversable-1.0.0.1-AstmkKq4X4MO5rWRXQplz -lHSvector-algorithms-0.7.0.1-8R8UpWgvBC926XMxBjYPpx -lHSsplit-0.2.3.1-IJKK4pOCYGKud0jZImZke -lHSconduit-extra-1.1.13.2-HFYphC0EojhHqAnIEx6Pp5 -lHSstreaming-commons-0.1.15.5-JQkoaJB2sOVLY7vO4kOB5z -lHSzlib-0.6.1.1-4cYT5jyS3jw6zZyCUZMz3T -lHSrandom-1.1-54KmMHXjttlERYcr1mvsAe -lHSprocess-1.4.2.0 -lHSnetwork-2.6.3.1-G4Up1CPKbp7DeFsnywOnGG -lHSdirectory-1.2.6.2 -lHSunix-2.7.2.0 -lHSfilepath-1.4.1.0 -lHSblaze-builder-0.4.0.2-KWDLbdBYSBoALiMW0LHIz1 -lHSchunked-data-0.3.0-F6p3z5B8kkI7AcvABkOpCw -lHSsemigroups-0.18.2-2lmUSJvrDkM6JBURGRclWz -lHSbase64-bytestring-1.0.0.1-In9M41tLtcS9QYt3QpGpNY -lHSbase16-bytestring-0.1.1.6-5dPoF8dzhwzBaEB2MvnmIS -lHSconduit-1.2.7-AT81Epeipx6C4wqHn3FXor -lHSresourcet-1.1.7.5-Gsc14LtMBpp2sQtbjwGHLc -lHSmmorph-1.0.6-3xsw6wg6Vs2JmwrJVsaYA0 -lHSlifted-base-0.2.3.8-KLkd0w1UJqu6nE8oVTTEBy -lHSmonad-control-1.0.1.0-HoNEBoNfniX3vjSfkI7WTT -lHStransformers-base-0.4.4-25SoAegOdaF8rLEnnb5jPI -lHSexceptions-0.8.3-7py7fmRxowDFpHmiHGKrTb -lHSasync-2.1.0-J6Pl8k3L4PKGEpjYdgwiIf -lHSstm-2.4.4.1-4z2NRWnB0NIIUvSJsHW0kF -lHSaeson-0.11.2.1-38JNNmpSV1dJgfHtWC9nlh -lHSunordered-containers-0.2.7.1-Eo9jd5DMz45DhBLCG8skzW -lHStagged-0.8.5-CtgV6EcN0do8F92i1S6iYx -lHStransformers-compat-0.5.1.4-81lZyuOJOvsD0zyCv2TKld -lHStemplate-haskell-2.11.0.0 -lHSpretty-1.1.3.3 -lHSghc-boot-th-8.0.1 -lHSsyb-0.6-C65vWCsht6A8uLstpQIXyj -lHSdlist-0.8.0.1-8vOZASaQM8T5SLbodsdvHz -lHSattoparsec-0.13.0.2-GLM6q4XQBSiI4fJOXoBxlu -lHSscientific-0.3.4.9-6oTYuCcx6H5BsTGU7D2Gk3 -lHSvector-0.11.0.0-BEDZb5o2QOhGbIm6ky7rl6 -lHSprimitive-0.6.1.0-Ip44DqhfCp21tTUYbecwa -lHShashable-1.2.4.0-EMu4H7FB10MAl6hwKw992G -lHSHDBC-sqlite3-2.3.3.1-wMqMSnNcWm14lydzBEmTX -lHSHDBC-postgresql-2.3.2.3-HaNwbkTFH0cIme8ibesQy9 -lHSparsec-3.1.11-BCos4GEVCuDB8dnOCBHO6X -lHSHDBC-2.4.0.1-4RVX8kLUuxOI95AL10vhvV -lHSutf8-string-1.0.1.1-2T8mBCuEDlXDo8zed8Onw4 -lHSconvertible-1.1.1.0-LKSEHOqRPBWL4CrSDoQYvh -lHStime-1.6.0.1 -lHStext-1.2.2.1-5QpmrLQApEZ4Ly9nMHWY0s -lHSbinary-0.8.3.0 -lHSold-time-1.1.0.3-IcvdkJUsE9M8t3io8peAEp -lHSold-locale-1.0.0.7-6glXNhHF891B41ZfuI8hU8 -lHSmtl-2.2.1-6qsR1PHUy5lL47Hpoa4jCM -lHStransformers-0.5.2.0 -lHScontainers-0.5.7.1 -lHSbytestring-0.10.8.1 -lHSdeepseq-1.4.2.0 -lHSarray-0.5.1.1 -lHSbase-4.9.0.0 -lHSinteger-gmp-1.0.0.1 -lHSghc-prim-0.5.0.0 -lHSrts -lCffi -lz -lrt -lutil -ldl -lsqlite3 -lpq -lgmp -lm -lrt -ldl
rm -rf $TMP_DIR
