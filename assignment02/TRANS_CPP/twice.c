#include "stfpl_header.h"

#include <stdio.h>


int f_succ_0(env v_env_0, int v_x_3);
closure f_twice_1(env v_env_0, closure v_f_6);
int f_lam_2(env v_env_0, int v_x_8);
int __main(env v_env_0);

int f_succ_0(env v_env_0, int v_x_3)
{
  int v_4 = v_x_3 + 1;
  return v_4;
}

closure f_twice_1(env v_env_0, closure v_f_6)
{
  closure v_f_lam_2_7 = closure_create();
  closure_put_fun(v_f_lam_2_7, (void*)f_lam_2);
  closure_add_env(v_f_lam_2_7, (void*)v_f_6);
  return v_f_lam_2_7;
}

int f_lam_2(env v_env_0, int v_x_8)
{
  int v_10 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x_8);
  int v_9 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_10);
  return v_9;
}

int __main(env v_env_0)
{
  closure v_f_succ_0_2 = closure_create();
  closure_put_fun(v_f_succ_0_2, (void*)f_succ_0);
  closure v_f_twice_1_5 = closure_create();
  closure_put_fun(v_f_twice_1_5, (void*)f_twice_1);
  closure v_13 = (*(closure (*)(env, closure))closure_get_fun(v_f_twice_1_5))(closure_get_env(v_f_twice_1_5), v_f_succ_0_2);
  int v_ans_12 = (*(int (*)(env, int))closure_get_fun(v_13))(closure_get_env(v_13), 100);
  tuple v___14 = 0;printf("%s", "shuld see \nans = 102\n");
  tuple v___15 = 0;printf("%s", "ans = ");
  tuple v___16 = 0;printf("%d", v_ans_12);
  tuple v___17 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
