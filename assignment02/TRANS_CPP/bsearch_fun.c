#include "stfpl_header.h"

#include <stdio.h>


int f_bsearch_fun_0(env v_env_0, closure v_f_4, int v_x0_5, int v_lb_6, int v_ub_7);
int f_isqrt_1(env v_env_0, int v_x_24);
int f_lam_2(env v_env_0, int v_i_28);
int __main(env v_env_0);

int f_bsearch_fun_0(env v_env_0, closure v_f_4, int v_x0_5, int v_lb_6, int v_ub_7)
{
  closure v_f_bsearch_fun_0_2 = closure_create();
  closure_put_fun(v_f_bsearch_fun_0_2, (void*)f_bsearch_fun_0);
  bool v_9 = v_lb_6 <= v_ub_7;
  int v_8;
  if (v_9)
  {
    int v_13 = v_ub_7 - v_lb_6;
    int v_12 = v_13 / 2;
    int v_mid_11 = v_lb_6 + v_12;
    int v_15 = (*(int (*)(env, int))closure_get_fun(v_f_4))(closure_get_env(v_f_4), v_mid_11);
    bool v_14 = v_x0_5 < v_15;
    int v_10;
    if (v_14)
    {
      int v_18 = v_mid_11 - 1;
      tuple v_17 = tuple_create();
      tuple_add(v_17, (void*)v_f_4);
      tuple_add(v_17, (void*)v_x0_5);
      tuple_add(v_17, (void*)v_lb_6);
      tuple_add(v_17, (void*)v_18);
      int v_16 = (*(int (*)(env, closure, int, int, int))closure_get_fun(v_f_bsearch_fun_0_2))(closure_get_env(v_f_bsearch_fun_0_2), v_f_4, v_x0_5, v_lb_6, v_18);
      v_10 = v_16;
    }
    else
    {
      int v_21 = v_mid_11 + 1;
      tuple v_20 = tuple_create();
      tuple_add(v_20, (void*)v_f_4);
      tuple_add(v_20, (void*)v_x0_5);
      tuple_add(v_20, (void*)v_21);
      tuple_add(v_20, (void*)v_ub_7);
      int v_19 = (*(int (*)(env, closure, int, int, int))closure_get_fun(v_f_bsearch_fun_0_2))(closure_get_env(v_f_bsearch_fun_0_2), v_f_4, v_x0_5, v_21, v_ub_7);
      v_10 = v_19;
    }
    v_8 = v_10;
  }
  else
  {
    v_8 = v_ub_7;
  }
  return v_8;
}

int f_isqrt_1(env v_env_0, int v_x_24)
{
  closure v_f_lam_2_27 = closure_create();
  closure_put_fun(v_f_lam_2_27, (void*)f_lam_2);
  tuple v_26 = tuple_create();
  tuple_add(v_26, (void*)v_f_lam_2_27);
  tuple_add(v_26, (void*)v_x_24);
  tuple_add(v_26, (void*)0);
  tuple_add(v_26, (void*)(int)env_get(v_env_0, 1));
  int v_25 = (*(int (*)(env, closure, int, int, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_f_lam_2_27, v_x_24, 0, (int)env_get(v_env_0, 1));
  return v_25;
}

int f_lam_2(env v_env_0, int v_i_28)
{
  int v_29 = v_i_28 * v_i_28;
  return v_29;
}

int __main(env v_env_0)
{
  closure v_f_bsearch_fun_0_3 = closure_create();
  closure_put_fun(v_f_bsearch_fun_0_3, (void*)f_bsearch_fun_0);
  closure v_f_isqrt_1_23 = closure_create();
  closure_put_fun(v_f_isqrt_1_23, (void*)f_isqrt_1);
  closure_add_env(v_f_isqrt_1_23, (void*)v_f_bsearch_fun_0_3);
  closure_add_env(v_f_isqrt_1_23, (void*)65535);
  tuple v___32 = 0;printf("%s", "should see 0 1 1 2 4 5 in multiple line\n");
  int v_34 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 0);
  tuple v___33 = 0;printf("%d", v_34);
  tuple v___35 = 0;printf("%s", "\n");
  int v_37 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 1);
  tuple v___36 = 0;printf("%d", v_37);
  tuple v___38 = 0;printf("%s", "\n");
  int v_40 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 2);
  tuple v___39 = 0;printf("%d", v_40);
  tuple v___41 = 0;printf("%s", "\n");
  int v_43 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 8);
  tuple v___42 = 0;printf("%d", v_43);
  tuple v___44 = 0;printf("%s", "\n");
  int v_46 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 17);
  tuple v___45 = 0;printf("%d", v_46);
  tuple v___47 = 0;printf("%s", "\n");
  int v_49 = (*(int (*)(env, int))closure_get_fun(v_f_isqrt_1_23))(closure_get_env(v_f_isqrt_1_23), 25);
  tuple v___48 = 0;printf("%d", v_49);
  tuple v___50 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
