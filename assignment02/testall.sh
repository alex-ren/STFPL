# Zhiqiang Ren 
# 03/22/2011

echo "testall =========================="

STFPL_LIB="lib/stfpl_header.c"
STFPL_INC=-I"lib"


# ./tester < TEST/queens.stfpl 1>TEST/queens.c
# gcc -o TEST/queens TEST/queens.cpp $STFPL_LIB
# ./TEST/queens

# 
# ./tester < TEST/simple.stfpl 1>TEST/simple.c
# echo gcc -o TEST/simple TEST/simple.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/simple TEST/simple.c $STFPL_LIB $STFPL_INC
# ./TEST/simple
# echo
# 
# 
# ./tester < TEST/ackermann.stfpl 1>TEST/ackermann.c
# echo gcc -o TEST/ackermann TEST/ackermann.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/ackermann TEST/ackermann.c $STFPL_LIB $STFPL_INC
# ./TEST/ackermann
# echo
# 
# ./tester < TEST/bsearch_fun.stfpl 1>TEST/bsearch_fun.c
# echo gcc -o TEST/bsearch_fun TEST/bsearch_fun.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/bsearch_fun TEST/bsearch_fun.c $STFPL_LIB $STFPL_INC
# ./TEST/bsearch_fun
# echo
# 
# ./tester < TEST/coin.stfpl 1>TEST/coin.c
# echo gcc -o TEST/coin TEST/coin.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/coin TEST/coin.c $STFPL_LIB $STFPL_INC
# ./TEST/coin
# echo
# 
# 
# ./tester < TEST/evenodd.stfpl 1>TEST/evenodd.c
# echo gcc -o TEST/evenodd TEST/evenodd.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/evenodd TEST/evenodd.c $STFPL_LIB $STFPL_INC
# ./TEST/evenodd
# echo
# 
# ./tester < TEST/fact_fix.stfpl 1>TEST/fact_fix.c
# echo gcc -o TEST/fact_fix TEST/fact_fix.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/fact_fix TEST/fact_fix.c $STFPL_LIB $STFPL_INC
# ./TEST/fact_fix
# echo
# 
# ./tester < TEST/fact.stfpl 1>TEST/fact.c
# echo gcc -o TEST/fact TEST/fact.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/fact TEST/fact.c $STFPL_LIB $STFPL_INC
# ./TEST/fact
# echo
# 
# ./tester < TEST/twice.stfpl 1>TEST/twice.c
# echo gcc -o TEST/twice TEST/twice.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/twice TEST/twice.c $STFPL_LIB $STFPL_INC
# ./TEST/twice
# echo
# 
# ./tester < TEST/f91.stfpl 1>TEST/f91.c
# echo gcc -o TEST/f91 TEST/f91.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/f91 TEST/f91.c $STFPL_LIB $STFPL_INC
# ./TEST/f91
# echo
# 
# ./tester < TEST/fib.stfpl 1>TEST/fib.c
# echo gcc -o TEST/fib TEST/fib.c $STFPL_LIB $STFPL_INC
# gcc -o TEST/fib TEST/fib.c $STFPL_LIB $STFPL_INC
# ./TEST/fib
# echo
# 
./tester < TEST/funargs.stfpl 1>TEST/funargs.c
echo should see type errors
echo

./tester < TEST/list_opr.stfpl 1>TEST/list_opr.c
echo gcc -o TEST/list_opr TEST/list_opr.c $STFPL_LIB $STFPL_INC
gcc -o TEST/list_opr TEST/list_opr.c $STFPL_LIB $STFPL_INC
./TEST/list_opr
echo

# # type inference cannot handle recursive data type
# # ./tester < TEST/mytuple.stfpl > TEST/mytuple.cpp
# # g++ -o TEST/mytuple TEST/mytuple.cpp
# # ./TEST/mytuple
# 

