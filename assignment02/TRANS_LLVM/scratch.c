#include "stfpl_header.h"

#include <stdio.h>


long f_fn_0(env v_env_0, long v_x_3);
long __main(env v_env_0);

long f_fn_0(env v_env_0, long v_x_3)
{
  return v_x_3;
}

long __main(env v_env_0)
{
  closure v_f_fn_0_2 = closure_create();
  closure_put_fun(v_f_fn_0_2, (void*)f_fn_0);
  long v_5 = (*(long (*)(env, long))closure_get_fun(v_f_fn_0_2))(closure_get_env(v_f_fn_0_2), 3);
  long v_k_4 = v_5 + 4;
  tuple v___6 = 0;printf("%d", v_k_4);
  tuple v___7 = 0;printf("%s", "=\n");
  string v_kk_8 = (*(string (*)(env, long))closure_get_fun(tostring_int))(closure_get_env(tostring_int), 3);
  bool v_10 = 1 > v_k_4;
  long v_kk_9;
  if (v_10)
  {
    v_kk_9 = 3;
  }
  else
  {
    v_kk_9 = 4;
  }
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
