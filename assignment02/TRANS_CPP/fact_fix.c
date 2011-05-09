#include "stfpl_header.h"

#include <stdio.h>


int f_fact_0(env v_env_0, int v_n_3);
int __main(env v_env_0);

int f_fact_0(env v_env_0, int v_n_3)
{
  closure v_f_fact_0_2 = closure_create();
  closure_put_fun(v_f_fact_0_2, (void*)f_fact_0);
  bool v_5 = v_n_3 >= 1;
  int v_4;
  if (v_5)
  {
    int v_8 = v_n_3 - 1;
    int v_7 = (*(int (*)(env, int))closure_get_fun(v_f_fact_0_2))(closure_get_env(v_f_fact_0_2), v_8);
    int v_6 = v_n_3 * v_7;
    v_4 = v_6;
  }
  else
  {
    v_4 = 1;
  }
  return v_4;
}

int __main(env v_env_0)
{
  closure v_f_fact_0_2 = closure_create();
  closure_put_fun(v_f_fact_0_2, (void*)f_fact_0);
  tuple v___9 = 0;printf("%s", "should see \nfact (10) = 3628800\n");
  int v_fact10_10 = (*(int (*)(env, int))closure_get_fun(v_f_fact_0_2))(closure_get_env(v_f_fact_0_2), 10);
  tuple v___11 = 0;printf("%s", "fact (10) = ");
  tuple v___12 = 0;printf("%d", v_fact10_10);
  tuple v___13 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
