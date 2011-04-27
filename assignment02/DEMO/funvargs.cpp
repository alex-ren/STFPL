#include <cstdio>

typedef void * (*__ftype0)();
typedef void * (*__ftype1)(void *);

void * __f_plus_0(void *);

void * __f_sum_1(void *);

void * __main();

void * __f_plus_0(void * __args)
{
  void * __v_1 = (void *) ((long)__args + (long)1);
  return (void *)__v_1;
}

void * __f_sum_1(void * __args)
{
  void * __v_2 = (void *) ((long)((void **)__args)[0] + (long)((void **)__args)[1]);
  return (void *)__v_2;
}

void * __main()
{
  void * __v_4 = ((__ftype1)__f_plus_0)((void *)1);
  void * __v__3 = NULL;printf("%d", __v_4);
  void * __v__5 = NULL;printf("%s", "\n");
  void * __v_8 = (void *) (new void * [2] ());
  ((void **)__v_8)[0] = (void *)2;
  ((void **)__v_8)[1] = (void *)3;
  void * __v_7 = (void *) (new void * [2] ());
  ((void **)__v_7)[0] = (void *)2;
  ((void **)__v_7)[1] = (void *)3;
  __v_7 = ((__ftype1)__f_sum_1)((void *)__v_7);
  void * __v__6 = NULL;printf("%d", __v_7);
  void * __v__9 = NULL;printf("%s", "\n");
  void * __v_0 = NULL;
  return (void *)"NULL";
}

int main (int argc, char *argv)
{
  __main();
  return 0;
}

