#include <cstdio>

typedef void * (*__ftype0)();
typedef void * (*__ftype1)(void *);

void * __main();

void * __main()
{
  void * __v_2 = (void *) ((long)1 > (long)2);
  void * __v_ifval1 = NULL;
  if (__v_2)
  {
    __v_ifval1 = (void *)"then branch";
  }
  else
  {
    __v_ifval1 = (void *)"else branch";
  }
  void * __v__3 = NULL;printf("%s", __v_ifval1);
  void * __v_0 = NULL;printf("%s", "\n");
  return (void *)"NULL";
}

int main (int argc, char *argv)
{
  __main();
  return 0;
}

