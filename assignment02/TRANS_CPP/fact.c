#include "stfpl_header.h"

#include <stdio.h>


int f_fact_0(env v_env_0, int v_n_4);
int __main(env v_env_0);

int f_fact_0(env v_env_0, int v_n_4)
{
  closure v_f_fact_0_2 = closure_create();
  closure_put_fun(v_f_fact_0_2, (void*)f_fact_0);
  bool v_6 = v_n_4 >= 1;
  int v_5;
  if (v_6)
  {
    int v_9 = v_n_4 - 1;
    int v_8 = (*(int (*)(env, int))closure_get_fun(v_f_fact_0_2))(closure_get_env(v_f_fact_0_2), v_9);
    int v_7 = v_n_4 * v_8;
    v_5 = v_7;
  }
  else
  {
    v_5 = 1;
  }
  return v_5;
}

int __main(env v_env_0)
{
  closure v_f_fact_0_3 = closure_create();
  closure_put_fun(v_f_fact_0_3, (void*)f_fact_0);
  tuple v___10 = 0;printf("%s", "should see \nfact (10) = 3628800\n");
  tuple v___11 = 0;printf("%s", "fact (10) = ");
  int v_13 = (*(int (*)(env, int))closure_get_fun(v_f_fact_0_3))(closure_get_env(v_f_fact_0_3), 10);
  tuple v___12 = 0;printf("%d", v_13);
  tuple v___14 = 0;printf("%s", "\n");
  int v_1 = (*(int (*)(env, int))closure_get_fun(v_f_fact_0_3))(closure_get_env(v_f_fact_0_3), 10);
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
