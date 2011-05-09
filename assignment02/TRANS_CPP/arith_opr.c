#include "stfpl_header.h"

#include <stdio.h>


int f_id_0(env v_env_0, int v_x_3);
tuple f_print_intln_1(env v_env_0, int v_x_5);
tuple f_print_bool_2(env v_env_0, bool v_x_10);
tuple f_print_boolln_3(env v_env_0, bool v_x_15);
int __main(env v_env_0);

int f_id_0(env v_env_0, int v_x_3)
{
  return v_x_3;
}

tuple f_print_intln_1(env v_env_0, int v_x_5)
{
  tuple v___7 = 0;printf("%d", v_x_5);
  tuple v___8 = 0;printf("%s", "\n");
  tuple v_6 = 0;
  return 0;
}

tuple f_print_bool_2(env v_env_0, bool v_x_10)
{
  tuple v_11;
  if (v_x_10)
  {
    tuple v_12 = 0;printf("%s", "true");
    v_11 = v_12;
  }
  else
  {
    tuple v_13 = 0;printf("%s", "false");
    v_11 = v_13;
  }
  return v_11;
}

tuple f_print_boolln_3(env v_env_0, bool v_x_15)
{
  tuple v___17 = (*(tuple (*)(env, bool))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x_15);
  tuple v___18 = 0;printf("%s", "\n");
  tuple v_16 = 0;
  return 0;
}

int __main(env v_env_0)
{
  closure v_f_id_0_2 = closure_create();
  closure_put_fun(v_f_id_0_2, (void*)f_id_0);
  closure v_f_print_intln_1_4 = closure_create();
  closure_put_fun(v_f_print_intln_1_4, (void*)f_print_intln_1);
  closure v_f_print_bool_2_9 = closure_create();
  closure_put_fun(v_f_print_bool_2_9, (void*)f_print_bool_2);
  closure v_f_print_boolln_3_14 = closure_create();
  closure_put_fun(v_f_print_boolln_3_14, (void*)f_print_boolln_3);
  closure_add_env(v_f_print_boolln_3_14, (void*)v_f_print_bool_2_9);
  int v_x_20 = (*(int (*)(env, int))closure_get_fun(v_f_id_0_2))(closure_get_env(v_f_id_0_2), 1);
  int v_y_21 = (*(int (*)(env, int))closure_get_fun(v_f_id_0_2))(closure_get_env(v_f_id_0_2), 2);
  int v_add_22 = v_x_20 + v_y_21;
  int v_sub_23 = v_x_20 - v_y_21;
  int v_mul_24 = v_x_20 * v_y_21;
  int v_div_25 = v_x_20 / v_y_21;
  bool v_gt_26 = v_x_20 > v_y_21;
  bool v_gte_27 = v_x_20 >= v_y_21;
  bool v_lt_28 = v_x_20 < v_y_21;
  bool v_lte_29 = v_x_20 <= v_y_21;
  bool v_eq_30 = v_x_20 == v_y_21;
  bool v_neq_31 = v_x_20 != v_y_21;
  tuple v___34 = 0;printf("%s", "1 + 2 = ");
  tuple v___35 = (*(tuple (*)(env, int))closure_get_fun(v_f_print_intln_1_4))(closure_get_env(v_f_print_intln_1_4), v_add_22);
  tuple v___36 = 0;printf("%s", "1 - 2 = ");
  tuple v___37 = (*(tuple (*)(env, int))closure_get_fun(v_f_print_intln_1_4))(closure_get_env(v_f_print_intln_1_4), v_sub_23);
  tuple v___38 = 0;printf("%s", "1 * 2 = ");
  tuple v___39 = (*(tuple (*)(env, int))closure_get_fun(v_f_print_intln_1_4))(closure_get_env(v_f_print_intln_1_4), v_mul_24);
  tuple v___40 = 0;printf("%s", "1 / 2 = ");
  tuple v___41 = (*(tuple (*)(env, int))closure_get_fun(v_f_print_intln_1_4))(closure_get_env(v_f_print_intln_1_4), v_div_25);
  tuple v___42 = 0;printf("%s", "1 > 2 = ");
  tuple v___43 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_gt_26);
  tuple v___44 = 0;printf("%s", "1 >= 2 = ");
  tuple v___45 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_gte_27);
  tuple v___46 = 0;printf("%s", "1 < 2 = ");
  tuple v___47 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_lt_28);
  tuple v___48 = 0;printf("%s", "1 <= 2 = ");
  tuple v___49 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_lte_29);
  tuple v___50 = 0;printf("%s", "(1 = 2) = ");
  tuple v___51 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_eq_30);
  tuple v___52 = 0;printf("%s", "1 <> 2 = ");
  tuple v___53 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), v_neq_31);
  tuple v___54 = 0;printf("%s", "true = ");
  tuple v___55 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), true);
  tuple v___56 = 0;printf("%s", "false = ");
  tuple v___57 = (*(tuple (*)(env, bool))closure_get_fun(v_f_print_boolln_3_14))(closure_get_env(v_f_print_boolln_3_14), false);
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
