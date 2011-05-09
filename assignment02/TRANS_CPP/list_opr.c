#include "stfpl_header.h"

#include <stdio.h>


list f_list_insert_0(env v_env_0, int v_pos_3, int v_n_4, list v_xs_5);
tuple f_list_print_1(env v_env_0, list v_xs_18, int v_len_19);
tuple f_aux_2(env v_env_0, list v_xs_22, int v_n_23);
tuple f_list_remove_3(env v_env_0, int v_pos_57, list v_xs_58);
int __main(env v_env_0);

list f_list_insert_0(env v_env_0, int v_pos_3, int v_n_4, list v_xs_5)
{
  closure v_f_list_insert_0_2 = closure_create();
  closure_put_fun(v_f_list_insert_0_2, (void*)f_list_insert_0);
  bool v_7 = v_pos_3 == 0;
  list v_6;
  if (v_7)
  {
    tuple v_9 = tuple_create();
    tuple_add(v_9, (void*)v_n_4);
    tuple_add(v_9, (void*)v_xs_5);
    list v_8 = (*(list (*)(env, int, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_n_4, v_xs_5);
    v_6 = v_8;
  }
  else
  {
    int v_x_11 = (int)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_5);
    list v_tail_12 = (*(list (*)(env, list))closure_get_fun(list_tail))(closure_get_env(list_tail), v_xs_5);
    int v_15 = v_pos_3 - 1;
    tuple v_14 = tuple_create();
    tuple_add(v_14, (void*)v_15);
    tuple_add(v_14, (void*)v_n_4);
    tuple_add(v_14, (void*)v_tail_12);
    list v_xs1_13 = (*(list (*)(env, int, int, list))closure_get_fun(v_f_list_insert_0_2))(closure_get_env(v_f_list_insert_0_2), v_15, v_n_4, v_tail_12);
    tuple v_16 = tuple_create();
    tuple_add(v_16, (void*)v_x_11);
    tuple_add(v_16, (void*)v_xs1_13);
    list v_10 = (*(list (*)(env, int, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_x_11, v_xs1_13);
    v_6 = v_10;
  }
  return v_6;
}

tuple f_list_print_1(env v_env_0, list v_xs_18, int v_len_19)
{
  closure v_f_aux_2_21 = closure_create();
  closure_put_fun(v_f_aux_2_21, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_21, (void*)v_len_19);
  tuple v_40 = tuple_create();
  tuple_add(v_40, (void*)v_xs_18);
  tuple_add(v_40, (void*)0);
  tuple v_20 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_aux_2_21))(closure_get_env(v_f_aux_2_21), v_xs_18, 0);
  return v_20;
}

tuple f_aux_2(env v_env_0, list v_xs_22, int v_n_23)
{
  closure v_f_aux_2_21 = closure_create();
  closure_put_fun(v_f_aux_2_21, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_21, (void*)(int)env_get(v_env_0, 0));
  bool v_25 = v_n_23 < (int)env_get(v_env_0, 0);
  tuple v_24;
  if (v_25)
  {
    bool v_27 = (*(bool (*)(env, list))closure_get_fun(list_is_empty))(closure_get_env(list_is_empty), v_xs_22);
    tuple v_26;
    if (v_27)
    {
      tuple v_28 = 0;
      v_26 = 0;
    }
    else
    {
      int v_x_30 = (int)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_22);
      list v_tail_31 = (*(list (*)(env, list))closure_get_fun(list_tail))(closure_get_env(list_tail), v_xs_22);
      bool v_33 = v_n_23 > 0;
      tuple v___32;
      if (v_33)
      {
        tuple v_34 = 0;printf("%s", ", ");
        v___32 = v_34;
      }
      else
      {
        v___32 = 0;
      }
      tuple v___35 = 0;printf("%d", v_x_30);
      int v_37 = v_n_23 + 1;
      tuple v_36 = tuple_create();
      tuple_add(v_36, (void*)v_tail_31);
      tuple_add(v_36, (void*)v_37);
      tuple v_29 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_aux_2_21))(closure_get_env(v_f_aux_2_21), v_tail_31, v_37);
      v_26 = v_29;
    }
    v_24 = v_26;
  }
  else
  {
    tuple v_38 = 0;
    v_24 = 0;
  }
  return v_24;
}

tuple f_list_remove_3(env v_env_0, int v_pos_57, list v_xs_58)
{
  closure v_f_list_remove_3_56 = closure_create();
  closure_put_fun(v_f_list_remove_3_56, (void*)f_list_remove_3);
  closure_add_env(v_f_list_remove_3_56, (void*)(closure)env_get(v_env_0, 0));
  int v_x_60 = (int)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_58);
  list v_tail_61 = (*(list (*)(env, list))closure_get_fun(list_tail))(closure_get_env(list_tail), v_xs_58);
  bool v_62 = v_pos_57 == 0;
  tuple v_59;
  if (v_62)
  {
    tuple v_63 = tuple_create();
    tuple_add(v_63, (void*)v_x_60);
    tuple_add(v_63, (void*)v_tail_61);
    v_59 = v_63;
  }
  else
  {
    int v_67 = v_pos_57 - 1;
    tuple v_66 = tuple_create();
    tuple_add(v_66, (void*)v_67);
    tuple_add(v_66, (void*)v_tail_61);
    tuple v_x_xs_65 = (*(tuple (*)(env, int, list))closure_get_fun(v_f_list_remove_3_56))(closure_get_env(v_f_list_remove_3_56), v_67, v_tail_61);
    int v_68 = (int)tuple_get(v_x_xs_65, 0);
    list v_71 = (list)tuple_get(v_x_xs_65, 1);
    tuple v_70 = tuple_create();
    tuple_add(v_70, (void*)0);
    tuple_add(v_70, (void*)v_x_60);
    tuple_add(v_70, (void*)v_71);
    list v_69 = (*(list (*)(env, int, int, list))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), 0, v_x_60, v_71);
    tuple v_64 = tuple_create();
    tuple_add(v_64, (void*)v_68);
    tuple_add(v_64, (void*)v_69);
    v_59 = v_64;
  }
  return v_59;
}

int __main(env v_env_0)
{
  closure v_f_list_insert_0_2 = closure_create();
  closure_put_fun(v_f_list_insert_0_2, (void*)f_list_insert_0);
  closure v_f_list_print_1_17 = closure_create();
  closure_put_fun(v_f_list_print_1_17, (void*)f_list_print_1);
  tuple v_42 = 0;
  list v_xs_41 = (*(list (*)(env))closure_get_fun(list_nil))(closure_get_env(list_nil));
  tuple v_44 = tuple_create();
  tuple_add(v_44, (void*)0);
  tuple_add(v_44, (void*)1);
  tuple_add(v_44, (void*)v_xs_41);
  list v_xs_43 = (*(list (*)(env, int, int, list))closure_get_fun(v_f_list_insert_0_2))(closure_get_env(v_f_list_insert_0_2), 0, 1, v_xs_41);
  tuple v_46 = tuple_create();
  tuple_add(v_46, (void*)1);
  tuple_add(v_46, (void*)2);
  tuple_add(v_46, (void*)v_xs_43);
  list v_xs_45 = (*(list (*)(env, int, int, list))closure_get_fun(v_f_list_insert_0_2))(closure_get_env(v_f_list_insert_0_2), 1, 2, v_xs_43);
  tuple v_48 = tuple_create();
  tuple_add(v_48, (void*)2);
  tuple_add(v_48, (void*)3);
  tuple_add(v_48, (void*)v_xs_45);
  list v_xs_47 = (*(list (*)(env, int, int, list))closure_get_fun(v_f_list_insert_0_2))(closure_get_env(v_f_list_insert_0_2), 2, 3, v_xs_45);
  tuple v_50 = tuple_create();
  tuple_add(v_50, (void*)3);
  tuple_add(v_50, (void*)4);
  tuple_add(v_50, (void*)v_xs_47);
  list v_xs_49 = (*(list (*)(env, int, int, list))closure_get_fun(v_f_list_insert_0_2))(closure_get_env(v_f_list_insert_0_2), 3, 4, v_xs_47);
  tuple v___51 = 0;printf("%s", "should see\n");
  tuple v___52 = 0;printf("%s", "1, 2, 3, 4\n");
  tuple v_54 = tuple_create();
  tuple_add(v_54, (void*)v_xs_49);
  tuple_add(v_54, (void*)4);
  tuple v___53 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_list_print_1_17))(closure_get_env(v_f_list_print_1_17), v_xs_49, 4);
  tuple v___55 = 0;printf("%s", "\n");
  closure v_f_list_remove_3_56 = closure_create();
  closure_put_fun(v_f_list_remove_3_56, (void*)f_list_remove_3);
  closure_add_env(v_f_list_remove_3_56, (void*)v_f_list_insert_0_2);
  tuple v_74 = tuple_create();
  tuple_add(v_74, (void*)2);
  tuple_add(v_74, (void*)v_xs_49);
  tuple v_x_xs_73 = (*(tuple (*)(env, int, list))closure_get_fun(v_f_list_remove_3_56))(closure_get_env(v_f_list_remove_3_56), 2, v_xs_49);
  tuple v___75 = 0;printf("%s", "should see\n");
  tuple v___76 = 0;printf("%s", "3 | 1, 2, 4\n");
  int v_78 = (int)tuple_get(v_x_xs_73, 0);
  tuple v___77 = 0;printf("%d", v_78);
  tuple v___79 = 0;printf("%s", " | ");
  list v_82 = (list)tuple_get(v_x_xs_73, 1);
  tuple v_81 = tuple_create();
  tuple_add(v_81, (void*)v_82);
  tuple_add(v_81, (void*)3);
  tuple v___80 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_list_print_1_17))(closure_get_env(v_f_list_print_1_17), v_82, 3);
  tuple v___83 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
