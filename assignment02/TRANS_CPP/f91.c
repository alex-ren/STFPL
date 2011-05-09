#include "stfpl_header.h"

#include <stdio.h>


int f_f91_0(env v_env_0, int v_n_4);
int __main(env v_env_0);

int f_f91_0(env v_env_0, int v_n_4)
{
  closure v_f_f91_0_2 = closure_create();
  closure_put_fun(v_f_f91_0_2, (void*)f_f91_0);
  bool v_6 = v_n_4 >= 101;
  int v_5;
  if (v_6)
  {
    int v_7 = v_n_4 - 10;
    v_5 = v_7;
  }
  else
  {
    int v_10 = v_n_4 + 11;
    int v_9 = (*(int (*)(env, int))closure_get_fun(v_f_f91_0_2))(closure_get_env(v_f_f91_0_2), v_10);
    int v_8 = (*(int (*)(env, int))closure_get_fun(v_f_f91_0_2))(closure_get_env(v_f_f91_0_2), v_9);
    v_5 = v_8;
  }
  return v_5;
}

int __main(env v_env_0)
{
  closure v_f_f91_0_3 = closure_create();
  closure_put_fun(v_f_f91_0_3, (void*)f_f91_0);
  tuple v___11 = 0;printf("%s", "should see \nf91 (57) = 91\n");
  tuple v___12 = 0;printf("%s", "f91 (57) = ");
  int v_14 = (*(int (*)(env, int))closure_get_fun(v_f_f91_0_3))(closure_get_env(v_f_f91_0_3), 57);
  tuple v___13 = 0;printf("%d", v_14);
  tuple v___15 = 0;printf("%s", "\n");
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
