# Zhiqiang Ren 
# 03/22/2011

./tester < TEST/queens.stfpl > TEST/queens.cpp
g++ -o TEST/queens TEST/queens.cpp
./TEST/queens


./tester < TEST/simple.stfpl > TEST/simple.cpp
g++ -o TEST/simple TEST/simple.cpp
./TEST/simple


./tester < TEST/ackermann.stfpl > TEST/ackermann.cpp
g++ -o TEST/ackermann TEST/ackermann.cpp
./TEST/ackermann


./tester < TEST/bsearch_fun.stfpl > TEST/bsearch_fun.cpp
g++ -o TEST/bsearch_fun TEST/bsearch_fun.cpp
./TEST/bsearch_fun


./tester < TEST/coin.stfpl > TEST/coin.cpp
g++ -o TEST/coin TEST/coin.cpp
./TEST/coin


./tester < TEST/evenodd.stfpl > TEST/evenodd.cpp
g++ -o TEST/evenodd TEST/evenodd.cpp
./TEST/evenodd


./tester < TEST/fact_fix.stfpl > TEST/fact_fix.cpp
g++ -o TEST/fact_fix TEST/fact_fix.cpp
./TEST/fact_fix


./tester < TEST/fact.stfpl > TEST/fact.cpp
g++ -o TEST/fact TEST/fact.cpp
./TEST/fact


# cannot handle closure now
# ./tester < TEST/twice.stfpl > TEST/twice.cpp
# g++ -o TEST/twice TEST/twice.cpp
# ./TEST/twice


./tester < TEST/f91.stfpl > TEST/f91.cpp
g++ -o TEST/f91 TEST/f91.cpp
./TEST/f91


./tester < TEST/fib.stfpl > TEST/fib.cpp
g++ -o TEST/fib TEST/fib.cpp
./TEST/fib


./tester < TEST/funargs.stfpl > TEST/funargs.cpp
g++ -o TEST/funargs TEST/funargs.cpp
./TEST/funargs


# type inference cannot handle recursive data type
# ./tester < TEST/mytuple.stfpl > TEST/mytuple.cpp
# g++ -o TEST/mytuple TEST/mytuple.cpp
# ./TEST/mytuple


# cannot handle closure now
# ./tester < TEST/list_opr.stfpl > TEST/list_opr.cpp
# g++ -o TEST/list_opr TEST/list_opr.cpp
# ./TEST/list_opr



