#include "stfpl_header.h"

#include <stdio.h>


int f_fib_0(env v_env_0, int v_n_4);
int __main(env v_env_0);

int f_fib_0(env v_env_0, int v_n_4)
{
  closure v_f_fib_0_2 = closure_create();
  closure_put_fun(v_f_fib_0_2, (void*)f_fib_0);
  bool v_6 = v_n_4 >= 2;
  int v_5;
  if (v_6)
  {
    int v_9 = v_n_4 - 1;
    int v_8 = (*(int (*)(env, int))closure_get_fun(v_f_fib_0_2))(closure_get_env(v_f_fib_0_2), v_9);
    int v_11 = v_n_4 - 2;
    int v_10 = (*(int (*)(env, int))closure_get_fun(v_f_fib_0_2))(closure_get_env(v_f_fib_0_2), v_11);
    int v_7 = v_8 + v_10;
    v_5 = v_7;
  }
  else
  {
    v_5 = v_n_4;
  }
  return v_5;
}

int __main(env v_env_0)
{
  closure v_f_fib_0_3 = closure_create();
  closure_put_fun(v_f_fib_0_3, (void*)f_fib_0);
  int v_fib20_12 = (*(int (*)(env, int))closure_get_fun(v_f_fib_0_3))(closure_get_env(v_f_fib_0_3), 20);
  tuple v___13 = 0;printf("%s", "should see \nfib (20) = 6765\n");
  tuple v___14 = 0;printf("%s", "fib (20) = ");
  tuple v___15 = 0;printf("%d", v_fib20_12);
  tuple v___16 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
