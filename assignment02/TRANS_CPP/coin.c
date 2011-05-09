#include "stfpl_header.h"

#include <stdio.h>


int f_coin_get_0(env v_env_0, int v_n_4, tuple v_coin_5);
int f_coin_change_1(env v_env_0, int v_sum_19, tuple v_coin_20);
int f_aux_2(env v_env_0, int v_sum_23, int v_n_24, tuple v_coin_25);
int __main(env v_env_0);

int f_coin_get_0(env v_env_0, int v_n_4, tuple v_coin_5)
{
  bool v_7 = v_n_4 == 0;
  int v_6;
  if (v_7)
  {
    int v_8 = (int)tuple_get(v_coin_5, 0);
    v_6 = v_8;
  }
  else
  {
    bool v_10 = v_n_4 == 1;
    int v_9;
    if (v_10)
    {
      int v_11 = (int)tuple_get(v_coin_5, 1);
      v_9 = v_11;
    }
    else
    {
      bool v_13 = v_n_4 == 2;
      int v_12;
      if (v_13)
      {
        int v_14 = (int)tuple_get(v_coin_5, 2);
        v_12 = v_14;
      }
      else
      {
        bool v_16 = v_n_4 == 3;
        int v_15;
        if (v_16)
        {
          int v_17 = (int)tuple_get(v_coin_5, 3);
          v_15 = v_17;
        }
        else
        {
          v_15 = -1;
        }
        v_12 = v_15;
      }
      v_9 = v_12;
    }
    v_6 = v_9;
  }
  return v_6;
}

int f_coin_change_1(env v_env_0, int v_sum_19, tuple v_coin_20)
{
  closure v_f_aux_2_22 = closure_create();
  closure_put_fun(v_f_aux_2_22, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_22, (void*)(closure)env_get(v_env_0, 0));
  tuple v_42 = tuple_create();
  tuple_add(v_42, (void*)v_sum_19);
  tuple_add(v_42, (void*)3);
  tuple_add(v_42, (void*)v_coin_20);
  int v_21 = (*(int (*)(env, int, int, tuple))closure_get_fun(v_f_aux_2_22))(closure_get_env(v_f_aux_2_22), v_sum_19, 3, v_coin_20);
  return v_21;
}

int f_aux_2(env v_env_0, int v_sum_23, int v_n_24, tuple v_coin_25)
{
  closure v_f_aux_2_22 = closure_create();
  closure_put_fun(v_f_aux_2_22, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_22, (void*)(closure)env_get(v_env_0, 0));
  bool v_27 = v_sum_23 > 0;
  int v_26;
  if (v_27)
  {
    bool v_29 = v_n_24 >= 0;
    int v_28;
    if (v_29)
    {
      int v_33 = v_n_24 - 1;
      tuple v_32 = tuple_create();
      tuple_add(v_32, (void*)v_sum_23);
      tuple_add(v_32, (void*)v_33);
      tuple_add(v_32, (void*)v_coin_25);
      int v_31 = (*(int (*)(env, int, int, tuple))closure_get_fun(v_f_aux_2_22))(closure_get_env(v_f_aux_2_22), v_sum_23, v_33, v_coin_25);
      tuple v_38 = tuple_create();
      tuple_add(v_38, (void*)v_n_24);
      tuple_add(v_38, (void*)v_coin_25);
      int v_37 = (*(int (*)(env, int, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_n_24, v_coin_25);
      int v_36 = v_sum_23 - v_37;
      tuple v_35 = tuple_create();
      tuple_add(v_35, (void*)v_36);
      tuple_add(v_35, (void*)v_n_24);
      tuple_add(v_35, (void*)v_coin_25);
      int v_34 = (*(int (*)(env, int, int, tuple))closure_get_fun(v_f_aux_2_22))(closure_get_env(v_f_aux_2_22), v_36, v_n_24, v_coin_25);
      int v_30 = v_31 + v_34;
      v_28 = v_30;
    }
    else
    {
      v_28 = 0;
    }
    v_26 = v_28;
  }
  else
  {
    bool v_40 = v_sum_23 < 0;
    int v_39;
    if (v_40)
    {
      v_39 = 0;
    }
    else
    {
      v_39 = 1;
    }
    v_26 = v_39;
  }
  return v_26;
}

int __main(env v_env_0)
{
  tuple v_theCoins_2 = tuple_create();
  tuple_add(v_theCoins_2, (void*)1);
  tuple_add(v_theCoins_2, (void*)5);
  tuple_add(v_theCoins_2, (void*)10);
  tuple_add(v_theCoins_2, (void*)25);
  closure v_f_coin_get_0_3 = closure_create();
  closure_put_fun(v_f_coin_get_0_3, (void*)f_coin_get_0);
  closure v_f_coin_change_1_18 = closure_create();
  closure_put_fun(v_f_coin_change_1_18, (void*)f_coin_change_1);
  closure_add_env(v_f_coin_change_1_18, (void*)v_f_coin_get_0_3);
  tuple v___44 = 0;printf("%s", "should see \n10045\n");
  tuple v_47 = tuple_create();
  tuple_add(v_47, (void*)400);
  tuple_add(v_47, (void*)v_theCoins_2);
  int v_46 = (*(int (*)(env, int, tuple))closure_get_fun(v_f_coin_change_1_18))(closure_get_env(v_f_coin_change_1_18), 400, v_theCoins_2);
  tuple v___45 = 0;printf("%d", v_46);
  tuple v___48 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
