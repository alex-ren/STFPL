# Zhiqiang Ren 
# 03/22/2011


./tester < DEMO/helloworld.stfpl > DEMO/helloworld.cpp
g++ -o DEMO/helloworld DEMO/helloworld.cpp
./DEMO/helloworld


./tester < DEMO/tuple.stfpl > DEMO/tuple.cpp
g++ -o DEMO/tuple DEMO/tuple.cpp
./DEMO/tuple

./tester < DEMO/if.stfpl > DEMO/if.cpp
g++ -o DEMO/if DEMO/if.cpp
./DEMO/if

./tester < DEMO/funvargs.stfpl > DEMO/funvargs.cpp
g++ -o DEMO/funvargs DEMO/funvargs.cpp
./DEMO/funvargs


