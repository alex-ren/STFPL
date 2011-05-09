#include "stfpl_header.h"

#include <stdio.h>


int f_ack_0(env v_env_0, int v_m_4, int v_n_5);
int __main(env v_env_0);

int f_ack_0(env v_env_0, int v_m_4, int v_n_5)
{
  closure v_f_ack_0_2 = closure_create();
  closure_put_fun(v_f_ack_0_2, (void*)f_ack_0);
  bool v_7 = v_m_4 == 0;
  int v_6;
  if (v_7)
  {
    int v_8 = v_n_5 + 1;
    v_6 = v_8;
  }
  else
  {
    bool v_10 = v_n_5 == 0;
    int v_9;
    if (v_10)
    {
      int v_13 = v_m_4 - 1;
      tuple v_12 = tuple_create();
      tuple_add(v_12, (void*)v_13);
      tuple_add(v_12, (void*)1);
      int v_11 = (*(int (*)(env, int, int))closure_get_fun(v_f_ack_0_2))(closure_get_env(v_f_ack_0_2), v_13, 1);
      v_9 = v_11;
    }
    else
    {
      int v_16 = v_m_4 - 1;
      int v_19 = v_n_5 - 1;
      tuple v_18 = tuple_create();
      tuple_add(v_18, (void*)v_m_4);
      tuple_add(v_18, (void*)v_19);
      int v_17 = (*(int (*)(env, int, int))closure_get_fun(v_f_ack_0_2))(closure_get_env(v_f_ack_0_2), v_m_4, v_19);
      tuple v_15 = tuple_create();
      tuple_add(v_15, (void*)v_16);
      tuple_add(v_15, (void*)v_17);
      int v_14 = (*(int (*)(env, int, int))closure_get_fun(v_f_ack_0_2))(closure_get_env(v_f_ack_0_2), v_16, v_17);
      v_9 = v_14;
    }
    v_6 = v_9;
  }
  return v_6;
}

int __main(env v_env_0)
{
  closure v_f_ack_0_3 = closure_create();
  closure_put_fun(v_f_ack_0_3, (void*)f_ack_0);
  tuple v___20 = 0;printf("%s", "should see \nack (3, 3) = 61\n");
  tuple v___21 = 0;printf("%s", "ack (3, 3) = ");
  tuple v_24 = tuple_create();
  tuple_add(v_24, (void*)3);
  tuple_add(v_24, (void*)3);
  int v_23 = (*(int (*)(env, int, int))closure_get_fun(v_f_ack_0_3))(closure_get_env(v_f_ack_0_3), 3, 3);
  tuple v___22 = 0;printf("%d", v_23);
  tuple v___25 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
