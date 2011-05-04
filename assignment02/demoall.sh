# Zhiqiang Ren 
# 05/02/2011

echo "testall =========================="

STFPL_LIB="lib/stfpl_header.c"
STFPL_INC=-I"lib"

./tester < DEMO/tuple.stfpl 1>DEMO/tuple.c
echo gcc -o DEMO/tuple DEMO/tuple.c $STFPL_LIB $STFPL_INC
gcc -o DEMO/tuple DEMO/tuple.c $STFPL_LIB $STFPL_INC
./DEMO/tuple
echo


./tester < DEMO/helloworld.stfpl 1>DEMO/helloworld.c
echo gcc -o DEMO/helloworld DEMO/helloworld.c $STFPL_LIB $STFPL_INC
gcc -o DEMO/helloworld DEMO/helloworld.c $STFPL_LIB $STFPL_INC
./DEMO/helloworld
echo

# ./tester < DEMO/helloworld.stfpl > DEMO/helloworld.cpp
# g++ -o DEMO/helloworld DEMO/helloworld.cpp
# ./DEMO/helloworld
# 
# 
# ./tester < DEMO/tuple.stfpl > DEMO/tuple.cpp
# g++ -o DEMO/tuple DEMO/tuple.cpp
# ./DEMO/tuple
# 
# ./tester < DEMO/if.stfpl > DEMO/if.cpp
# g++ -o DEMO/if DEMO/if.cpp
# ./DEMO/if
# 
# ./tester < DEMO/funvargs.stfpl > DEMO/funvargs.cpp
# g++ -o DEMO/funvargs DEMO/funvargs.cpp
# ./DEMO/funvargs
# 
# 
