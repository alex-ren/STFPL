#include "stfpl_header.h"

#include <stdio.h>


bool f_isevn_0(env v_env_0, int v_n_5);
bool f_isodd_1(env v_env_0, int v_n_11);
int __main(env v_env_0);

bool f_isevn_0(env v_env_0, int v_n_5)
{
  closure v_f_isevn_0_2 = closure_create();
  closure_put_fun(v_f_isevn_0_2, (void*)f_isevn_0);
  closure v_f_isodd_1_3 = closure_create();
  closure_put_fun(v_f_isodd_1_3, (void*)f_isodd_1);
  bool v_7 = v_n_5 >= 1;
  bool v_6;
  if (v_7)
  {
    int v_9 = v_n_5 - 1;
    bool v_8 = (*(bool (*)(env, int))closure_get_fun(v_f_isodd_1_3))(closure_get_env(v_f_isodd_1_3), v_9);
    v_6 = v_8;
  }
  else
  {
    v_6 = true;
  }
  return v_6;
}

bool f_isodd_1(env v_env_0, int v_n_11)
{
  closure v_f_isevn_0_2 = closure_create();
  closure_put_fun(v_f_isevn_0_2, (void*)f_isevn_0);
  closure v_f_isodd_1_3 = closure_create();
  closure_put_fun(v_f_isodd_1_3, (void*)f_isodd_1);
  bool v_13 = v_n_11 >= 1;
  bool v_12;
  if (v_13)
  {
    int v_15 = v_n_11 - 1;
    bool v_14 = (*(bool (*)(env, int))closure_get_fun(v_f_isevn_0_2))(closure_get_env(v_f_isevn_0_2), v_15);
    v_12 = v_14;
  }
  else
  {
    v_12 = false;
  }
  return v_12;
}

int __main(env v_env_0)
{
  closure v_f_isevn_0_4 = closure_create();
  closure_put_fun(v_f_isevn_0_4, (void*)f_isevn_0);
  closure v_f_isodd_1_10 = closure_create();
  closure_put_fun(v_f_isodd_1_10, (void*)f_isodd_1);
  bool v_17 = (*(bool (*)(env, int))closure_get_fun(v_f_isevn_0_4))(closure_get_env(v_f_isevn_0_4), 10);
  tuple v___16;
  if (v_17)
  {
    tuple v_18 = 0;printf("%s", "10 is even\n");
    v___16 = v_18;
  }
  else
  {
    tuple v_19 = 0;printf("%s", "10 is odd\n");
    v___16 = v_19;
  }
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
