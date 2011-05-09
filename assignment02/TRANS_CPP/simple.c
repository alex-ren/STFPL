#include "stfpl_header.h"

#include <stdio.h>


int f_foo_0(env v_env_0, tuple v_x_3);
int f_foo2_1(env v_env_0, int v_x_7, int v_y_8);
int f_foo3_2(env v_env_0, int v_x_11);
int __main(env v_env_0);

int f_foo_0(env v_env_0, tuple v_x_3)
{
  int v_5 = (int)tuple_get(v_x_3, 1);
  int v_4 = v_5 + 1;
  return v_4;
}

int f_foo2_1(env v_env_0, int v_x_7, int v_y_8)
{
  int v_9 = v_x_7 + 1;
  return v_9;
}

int f_foo3_2(env v_env_0, int v_x_11)
{
  int v_12 = v_x_11 + 1;
  return v_12;
}

int __main(env v_env_0)
{
  closure v_f_foo_0_2 = closure_create();
  closure_put_fun(v_f_foo_0_2, (void*)f_foo_0);
  closure v_f_foo2_1_6 = closure_create();
  closure_put_fun(v_f_foo2_1_6, (void*)f_foo2_1);
  closure v_f_foo3_2_10 = closure_create();
  closure_put_fun(v_f_foo3_2_10, (void*)f_foo3_2);
  tuple v_t_13;
  if (false)
  {
    tuple v_14 = tuple_create();
    tuple_add(v_14, (void*)100);
    tuple_add(v_14, (void*)200);
    v_t_13 = v_14;
  }
  else
  {
    tuple v_15 = tuple_create();
    tuple_add(v_15, (void*)33);
    tuple_add(v_15, (void*)44);
    v_t_13 = v_15;
  }
  int v_18 = (int)tuple_get(v_t_13, 0);
  int v_19 = (int)tuple_get(v_t_13, 1);
  tuple v_17 = tuple_create();
  tuple_add(v_17, (void*)v_18);
  tuple_add(v_17, (void*)v_19);
  int v_y_16 = (*(int (*)(env, int, int))closure_get_fun(v_f_foo2_1_6))(closure_get_env(v_f_foo2_1_6), v_18, v_19);
  tuple v___20 = 0;printf("%s", "should see \n45\n");
  int v_22 = (*(int (*)(env, tuple))closure_get_fun(v_f_foo_0_2))(closure_get_env(v_f_foo_0_2), v_t_13);
  tuple v___21 = 0;printf("%d", v_22);
  tuple v___23 = 0;printf("%s", "\n");
  tuple v___24 = 0;printf("%s", "should see \n34\n");
  tuple v___25 = 0;printf("%d", v_y_16);
  tuple v___26 = 0;printf("%s", "\n");
  tuple v___27 = 0;printf("%s", "should see \n100\n");
  int v_29 = (*(int (*)(env, int))closure_get_fun(v_f_foo3_2_10))(closure_get_env(v_f_foo3_2_10), 99);
  tuple v___28 = 0;printf("%d", v_29);
  tuple v___30 = 0;printf("%s", "\n");
  tuple v_1 = tuple_create();
  tuple_add(v_1, (void*)3);
  tuple_add(v_1, (void*)4);
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
