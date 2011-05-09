#include "stfpl_header.h"

#include <stdio.h>


int f_f_0(env v_env_0, tuple v_x_4);
int __main(env v_env_0);

int f_f_0(env v_env_0, tuple v_x_4)
{
  int v_6 = (int)tuple_get(v_x_4, 0);
  int v_7 = (int)tuple_get(v_x_4, 1);
  int v_5 = v_6 + v_7;
  return v_5;
}

int __main(env v_env_0)
{
  tuple v_a_2 = tuple_create();
  tuple_add(v_a_2, (void*)1);
  tuple_add(v_a_2, (void*)2);
  closure v_f_f_0_3 = closure_create();
  closure_put_fun(v_f_f_0_3, (void*)f_f_0);
  int v_d_8 = (*(int (*)(env, tuple))closure_get_fun(v_f_f_0_3))(closure_get_env(v_f_f_0_3), v_a_2);
  tuple v___9 = 0;printf("%s", "1 + 2 = ");
  tuple v___10 = 0;printf("%d", v_d_8);
  tuple v___11 = 0;printf("%s", "\n");
  tuple v_b_12 = tuple_create();
  tuple_add(v_b_12, (void*)2);
  tuple_add(v_b_12, (void*)3);
  tuple_add(v_b_12, (void*)4);
  int v___13 = (*(int (*)(env, tuple))closure_get_fun(v_f_f_0_3))(closure_get_env(v_f_f_0_3), v_a_2);
  int v_1 = (*(int (*)(env, tuple))closure_get_fun(v_f_f_0_3))(closure_get_env(v_f_f_0_3), v_b_12);
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
