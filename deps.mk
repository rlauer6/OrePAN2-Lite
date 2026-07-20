# ./lib/OrePAN2/CLI/Indexer.pm.in
./lib/OrePAN2/CLI/Indexer.pm: \
    ./lib/OrePAN2.pm \
    ./lib/OrePAN2/Indexer.pm

# ./lib/OrePAN2/CLI/Inject.pm.in
./lib/OrePAN2/CLI/Inject.pm: \
    ./lib/OrePAN2.pm \
    ./lib/OrePAN2/Repository.pm

# ./lib/OrePAN2/Index.pm.in
./lib/OrePAN2/Index.pm: \
    ./lib/OrePAN2.pm \
    ./lib/OrePAN2/Logger.pm \
    ./lib/OrePAN2/Role/HasLogger.pm

# ./lib/OrePAN2/Indexer.pm.in
./lib/OrePAN2/Indexer.pm: \
    ./lib/OrePAN2/Index.pm \
    ./lib/OrePAN2/Role/HasLogger.pm

# ./lib/OrePAN2/Lite.pm.in
./lib/OrePAN2/Lite.pm: \
    ./lib/OrePAN2.pm

# ./lib/OrePAN2/Repository.pm.in
./lib/OrePAN2/Repository.pm: \
    ./lib/OrePAN2/Indexer.pm \
    ./lib/OrePAN2/Injector.pm \
    ./lib/OrePAN2/Repository/Cache.pm

# ./lib/OrePAN2/Role/HasLogger.pm.in
./lib/OrePAN2/Role/HasLogger.pm: \
    ./lib/OrePAN2/Logger.pm

