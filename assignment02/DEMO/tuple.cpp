#include <cstdio>

typedef void * (*__ftype0)();
typedef void * (*__ftype1)(void *);

void * __f_sum_0(void *);

void * __main();

void * __f_sum_0(void * __args)
{
  void * __v_2 = ((void **)__args)[0];
  void * __v_3 = ((void **)__args)[1];
  void * __v_1 = (void *) ((long)__v_2 + (long)__v_3);
  return (void *)__v_1;
}

void * __main()
{
  void * __v_5 = (void *) (new void * [2] ());
  ((void **)__v_5)[0] = (void *)1;
  ((void **)__v_5)[1] = (void *)2;
  void * __v_ret14 = (void *) (new void * [2] ());
  ((void **)__v_ret14)[0] = (void *)1;
  ((void **)__v_ret14)[1] = (void *)2;
  __v_ret14 = ((__ftype1)__f_sum_0)((void *)__v_ret14);
  void * __v_7 = (void *) (new void * [3] ());
  ((void **)__v_7)[0] = (void *)2;
  ((void **)__v_7)[1] = (void *)3;
  ((void **)__v_7)[2] = (void *)4;
  void * __v_ret26 = (void *) (new void * [3] ());
  ((void **)__v_ret26)[0] = (void *)2;
  ((void **)__v_ret26)[1] = (void *)3;
  ((void **)__v_ret26)[2] = (void *)4;
  __v_ret26 = ((__ftype1)__f_sum_0)((void *)__v_ret26);
  void * __v__8 = NULL;printf("%d", __v_ret14);
  void * __v__9 = NULL;printf("%s", "\n");
  void * __v__10 = NULL;printf("%d", __v_ret26);
  void * __v__11 = NULL;printf("%s", "\n");
  void * __v_0 = NULL;
  return (void *)"NULL";
}

int main (int argc, char *argv)
{
  __main();
  return 0;
}

