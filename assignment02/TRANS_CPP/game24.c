#include "stfpl_header.h"

#include <stdio.h>


tuple f_list_remove_0(env v_env_0, int v_pos_33, list v_xs_34);
tuple f_list_print_1(env v_env_0, list v_xs_49, int v_len_50);
tuple f_aux_2(env v_env_0, list v_xs_53, int v_n_54);
tuple f_game24_3(env v_env_0, list v_xs_78, int v_len_79, int v_x_80, int v_y_81);
tuple f_adjust_4(env v_env_0, int v_x_185, int v_y_186);
int __main(env v_env_0);

tuple f_list_remove_0(env v_env_0, int v_pos_33, list v_xs_34)
{
  closure v_f_list_remove_0_32 = closure_create();
  closure_put_fun(v_f_list_remove_0_32, (void*)f_list_remove_0);
  tuple v_x_36 = (tuple)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_34);
  list v_tail_37 = (*(list (*)(env, list))closure_get_fun(list_tail))(closure_get_env(list_tail), v_xs_34);
  bool v_38 = v_pos_33 == 0;
  tuple v_35;
  if (v_38)
  {
    tuple v_39 = tuple_create();
    tuple_add(v_39, (void*)v_x_36);
    tuple_add(v_39, (void*)v_tail_37);
    v_35 = v_39;
  }
  else
  {
    int v_43 = v_pos_33 - 1;
    tuple v_42 = tuple_create();
    tuple_add(v_42, (void*)v_43);
    tuple_add(v_42, (void*)v_tail_37);
    tuple v_x_xs_41 = (*(tuple (*)(env, int, list))closure_get_fun(v_f_list_remove_0_32))(closure_get_env(v_f_list_remove_0_32), v_43, v_tail_37);
    tuple v_44 = (tuple)tuple_get(v_x_xs_41, 0);
    list v_47 = (list)tuple_get(v_x_xs_41, 1);
    tuple v_46 = tuple_create();
    tuple_add(v_46, (void*)v_x_36);
    tuple_add(v_46, (void*)v_47);
    list v_45 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_x_36, v_47);
    tuple v_40 = tuple_create();
    tuple_add(v_40, (void*)v_44);
    tuple_add(v_40, (void*)v_45);
    v_35 = v_40;
  }
  return v_35;
}

tuple f_list_print_1(env v_env_0, list v_xs_49, int v_len_50)
{
  closure v_f_aux_2_52 = closure_create();
  closure_put_fun(v_f_aux_2_52, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_52, (void*)v_len_50);
  tuple v_72 = tuple_create();
  tuple_add(v_72, (void*)v_xs_49);
  tuple_add(v_72, (void*)0);
  tuple v_51 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_aux_2_52))(closure_get_env(v_f_aux_2_52), v_xs_49, 0);
  return v_51;
}

tuple f_aux_2(env v_env_0, list v_xs_53, int v_n_54)
{
  closure v_f_aux_2_52 = closure_create();
  closure_put_fun(v_f_aux_2_52, (void*)f_aux_2);
  closure_add_env(v_f_aux_2_52, (void*)(int)env_get(v_env_0, 0));
  bool v_56 = v_n_54 < (int)env_get(v_env_0, 0);
  tuple v_55;
  if (v_56)
  {
    bool v_58 = (*(bool (*)(env, list))closure_get_fun(list_is_empty))(closure_get_env(list_is_empty), v_xs_53);
    tuple v_57;
    if (v_58)
    {
      tuple v_59 = 0;
      v_57 = 0;
    }
    else
    {
      tuple v_x_61 = (tuple)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_53);
      list v_tail_62 = (*(list (*)(env, list))closure_get_fun(list_tail))(closure_get_env(list_tail), v_xs_53);
      bool v_64 = v_n_54 > 0;
      tuple v___63;
      if (v_64)
      {
        tuple v_65 = 0;printf("%s", ", ");
        v___63 = v_65;
      }
      else
      {
        v___63 = 0;
      }
      int v_67 = (int)tuple_get(v_x_61, 0);
      tuple v___66 = 0;printf("%d", v_67);
      int v_69 = v_n_54 + 1;
      tuple v_68 = tuple_create();
      tuple_add(v_68, (void*)v_tail_62);
      tuple_add(v_68, (void*)v_69);
      tuple v_60 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_aux_2_52))(closure_get_env(v_f_aux_2_52), v_tail_62, v_69);
      v_57 = v_60;
    }
    v_55 = v_57;
  }
  else
  {
    tuple v_70 = 0;
    v_55 = 0;
  }
  return v_55;
}

tuple f_game24_3(env v_env_0, list v_xs_78, int v_len_79, int v_x_80, int v_y_81)
{
  closure v_f_game24_3_76 = closure_create();
  closure_put_fun(v_f_game24_3_76, (void*)f_game24_3);
  closure_add_env(v_f_game24_3_76, (void*)(closure)env_get(v_env_0, 0));
  bool v_83 = v_len_79 == 1;
  tuple v_82;
  if (v_83)
  {
    tuple v_item_85 = (tuple)(*(any (*)(env, list))closure_get_fun(list_head))(closure_get_env(list_head), v_xs_78);
    int v_87 = (int)tuple_get(v_item_85, 0);
    bool v_86 = v_87 == 24;
    tuple v_84;
    if (v_86)
    {
      string v_90 = (string)tuple_get(v_item_85, 1);
      tuple v___89 = 0;printf("%s", v_90);
      tuple v___91 = 0;printf("%s", "\n");
      tuple v_88 = 0;
      v_84 = 0;
    }
    else
    {
      v_84 = 0;
    }
    v_82 = v_84;
  }
  else
  {
    tuple v_94 = tuple_create();
    tuple_add(v_94, (void*)v_x_80);
    tuple_add(v_94, (void*)v_xs_78);
    tuple v_vx_xs1_93 = (*(tuple (*)(env, int, list))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x_80, v_xs_78);
    tuple v_vx_95 = (tuple)tuple_get(v_vx_xs1_93, 0);
    list v_xs1_96 = (list)tuple_get(v_vx_xs1_93, 1);
    bool v_98 = v_x_80 < v_y_81;
    tuple v_vy_xs1_97;
    if (v_98)
    {
      int v_101 = v_y_81 - 1;
      tuple v_100 = tuple_create();
      tuple_add(v_100, (void*)v_101);
      tuple_add(v_100, (void*)v_xs1_96);
      tuple v_99 = (*(tuple (*)(env, int, list))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_101, v_xs1_96);
      v_vy_xs1_97 = v_99;
    }
    else
    {
      tuple v_103 = tuple_create();
      tuple_add(v_103, (void*)v_y_81);
      tuple_add(v_103, (void*)v_xs1_96);
      tuple v_102 = (*(tuple (*)(env, int, list))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_y_81, v_xs1_96);
      v_vy_xs1_97 = v_102;
    }
    tuple v_vy_104 = (tuple)tuple_get(v_vy_xs1_97, 0);
    list v_xs1_105 = (list)tuple_get(v_vy_xs1_97, 1);
    int v_108 = (int)tuple_get(v_vx_95, 0);
    int v_109 = (int)tuple_get(v_vy_104, 0);
    int v_107 = v_108 + v_109;
    string v_118 = (string)tuple_get(v_vx_95, 1);
    tuple v_117 = tuple_create();
    tuple_add(v_117, (void*)"(");
    tuple_add(v_117, (void*)v_118);
    string v_116 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), "(", v_118);
    tuple v_115 = tuple_create();
    tuple_add(v_115, (void*)v_116);
    tuple_add(v_115, (void*)" + ");
    string v_114 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_116, " + ");
    string v_119 = (string)tuple_get(v_vy_104, 1);
    tuple v_113 = tuple_create();
    tuple_add(v_113, (void*)v_114);
    tuple_add(v_113, (void*)v_119);
    string v_112 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_114, v_119);
    tuple v_111 = tuple_create();
    tuple_add(v_111, (void*)v_112);
    tuple_add(v_111, (void*)")");
    string v_110 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_112, ")");
    tuple v_vxy_plus_106 = tuple_create();
    tuple_add(v_vxy_plus_106, (void*)v_107);
    tuple_add(v_vxy_plus_106, (void*)v_110);
    int v_122 = (int)tuple_get(v_vx_95, 0);
    int v_123 = (int)tuple_get(v_vy_104, 0);
    int v_121 = v_122 - v_123;
    string v_132 = (string)tuple_get(v_vx_95, 1);
    tuple v_131 = tuple_create();
    tuple_add(v_131, (void*)"(");
    tuple_add(v_131, (void*)v_132);
    string v_130 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), "(", v_132);
    tuple v_129 = tuple_create();
    tuple_add(v_129, (void*)v_130);
    tuple_add(v_129, (void*)" - ");
    string v_128 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_130, " - ");
    string v_133 = (string)tuple_get(v_vy_104, 1);
    tuple v_127 = tuple_create();
    tuple_add(v_127, (void*)v_128);
    tuple_add(v_127, (void*)v_133);
    string v_126 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_128, v_133);
    tuple v_125 = tuple_create();
    tuple_add(v_125, (void*)v_126);
    tuple_add(v_125, (void*)")");
    string v_124 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_126, ")");
    tuple v_vxy_minus_120 = tuple_create();
    tuple_add(v_vxy_minus_120, (void*)v_121);
    tuple_add(v_vxy_minus_120, (void*)v_124);
    int v_136 = (int)tuple_get(v_vx_95, 0);
    int v_137 = (int)tuple_get(v_vy_104, 0);
    int v_135 = v_136 * v_137;
    string v_142 = (string)tuple_get(v_vx_95, 1);
    tuple v_141 = tuple_create();
    tuple_add(v_141, (void*)v_142);
    tuple_add(v_141, (void*)" * ");
    string v_140 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_142, " * ");
    string v_143 = (string)tuple_get(v_vy_104, 1);
    tuple v_139 = tuple_create();
    tuple_add(v_139, (void*)v_140);
    tuple_add(v_139, (void*)v_143);
    string v_138 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_140, v_143);
    tuple v_vxy_mul_134 = tuple_create();
    tuple_add(v_vxy_mul_134, (void*)v_135);
    tuple_add(v_vxy_mul_134, (void*)v_138);
    tuple v_145 = tuple_create();
    tuple_add(v_145, (void*)v_vxy_plus_106);
    tuple_add(v_145, (void*)v_xs1_105);
    list v_xs1_plus_144 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_vxy_plus_106, v_xs1_105);
    tuple v_147 = tuple_create();
    tuple_add(v_147, (void*)v_vxy_minus_120);
    tuple_add(v_147, (void*)v_xs1_105);
    list v_xs1_minus_146 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_vxy_minus_120, v_xs1_105);
    tuple v_149 = tuple_create();
    tuple_add(v_149, (void*)v_vxy_mul_134);
    tuple_add(v_149, (void*)v_xs1_105);
    list v_xs1_mul_148 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_vxy_mul_134, v_xs1_105);
    int v_152 = v_len_79 - 1;
    tuple v_151 = tuple_create();
    tuple_add(v_151, (void*)v_xs1_plus_144);
    tuple_add(v_151, (void*)v_152);
    tuple_add(v_151, (void*)0);
    tuple_add(v_151, (void*)1);
    tuple v___150 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_76))(closure_get_env(v_f_game24_3_76), v_xs1_plus_144, v_152, 0, 1);
    int v_155 = v_len_79 - 1;
    tuple v_154 = tuple_create();
    tuple_add(v_154, (void*)v_xs1_minus_146);
    tuple_add(v_154, (void*)v_155);
    tuple_add(v_154, (void*)0);
    tuple_add(v_154, (void*)1);
    tuple v___153 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_76))(closure_get_env(v_f_game24_3_76), v_xs1_minus_146, v_155, 0, 1);
    int v_158 = v_len_79 - 1;
    tuple v_157 = tuple_create();
    tuple_add(v_157, (void*)v_xs1_mul_148);
    tuple_add(v_157, (void*)v_158);
    tuple_add(v_157, (void*)0);
    tuple_add(v_157, (void*)1);
    tuple v___156 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_76))(closure_get_env(v_f_game24_3_76), v_xs1_mul_148, v_158, 0, 1);
    int v_161 = (int)tuple_get(v_vy_104, 0);
    bool v_160 = v_161 == 0;
    tuple v___159;
    if (v_160)
    {
      tuple v_162 = 0;
      v___159 = 0;
    }
    else
    {
      int v_166 = (int)tuple_get(v_vx_95, 0);
      int v_167 = (int)tuple_get(v_vy_104, 0);
      int v_165 = v_166 / v_167;
      string v_176 = (string)tuple_get(v_vx_95, 1);
      tuple v_175 = tuple_create();
      tuple_add(v_175, (void*)"(");
      tuple_add(v_175, (void*)v_176);
      string v_174 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), "(", v_176);
      tuple v_173 = tuple_create();
      tuple_add(v_173, (void*)v_174);
      tuple_add(v_173, (void*)" / ");
      string v_172 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_174, " / ");
      string v_177 = (string)tuple_get(v_vy_104, 1);
      tuple v_171 = tuple_create();
      tuple_add(v_171, (void*)v_172);
      tuple_add(v_171, (void*)v_177);
      string v_170 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_172, v_177);
      tuple v_169 = tuple_create();
      tuple_add(v_169, (void*)v_170);
      tuple_add(v_169, (void*)")");
      string v_168 = (*(string (*)(env, string, string))closure_get_fun(string_add))(closure_get_env(string_add), v_170, ")");
      tuple v_vxy_div_164 = tuple_create();
      tuple_add(v_vxy_div_164, (void*)v_165);
      tuple_add(v_vxy_div_164, (void*)v_168);
      tuple v_179 = tuple_create();
      tuple_add(v_179, (void*)v_vxy_div_164);
      tuple_add(v_179, (void*)v_xs1_105);
      list v_xs1_div_178 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_vxy_div_164, v_xs1_105);
      int v_182 = v_len_79 - 1;
      tuple v_181 = tuple_create();
      tuple_add(v_181, (void*)v_xs1_div_178);
      tuple_add(v_181, (void*)v_182);
      tuple_add(v_181, (void*)0);
      tuple_add(v_181, (void*)1);
      tuple v___180 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_76))(closure_get_env(v_f_game24_3_76), v_xs1_div_178, v_182, 0, 1);
      tuple v_163 = 0;
      v___159 = 0;
    }
    closure v_f_adjust_4_184 = closure_create();
    closure_put_fun(v_f_adjust_4_184, (void*)f_adjust_4);
    closure_add_env(v_f_adjust_4_184, (void*)v_len_79);
    tuple v_201 = tuple_create();
    tuple_add(v_201, (void*)v_x_80);
    tuple_add(v_201, (void*)v_y_81);
    tuple v_xy_200 = (*(tuple (*)(env, int, int))closure_get_fun(v_f_adjust_4_184))(closure_get_env(v_f_adjust_4_184), v_x_80, v_y_81);
    int v_203 = (int)tuple_get(v_xy_200, 1);
    bool v_202 = v_203 == v_len_79;
    tuple v_92;
    if (v_202)
    {
      tuple v_204 = 0;
      v_92 = 0;
    }
    else
    {
      int v_207 = (int)tuple_get(v_xy_200, 0);
      int v_208 = (int)tuple_get(v_xy_200, 1);
      tuple v_206 = tuple_create();
      tuple_add(v_206, (void*)v_xs_78);
      tuple_add(v_206, (void*)v_len_79);
      tuple_add(v_206, (void*)v_207);
      tuple_add(v_206, (void*)v_208);
      tuple v_205 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_76))(closure_get_env(v_f_game24_3_76), v_xs_78, v_len_79, v_207, v_208);
      v_92 = v_205;
    }
    v_82 = v_92;
  }
  return v_82;
}

tuple f_adjust_4(env v_env_0, int v_x_185, int v_y_186)
{
  closure v_f_adjust_4_183 = closure_create();
  closure_put_fun(v_f_adjust_4_183, (void*)f_adjust_4);
  closure_add_env(v_f_adjust_4_183, (void*)(int)env_get(v_env_0, 0));
  int v_190 = (int)env_get(v_env_0, 0) - 1;
  bool v_189 = v_y_186 == v_190;
  int v_y1_188;
  if (v_189)
  {
    v_y1_188 = 0;
  }
  else
  {
    int v_191 = v_y_186 + 1;
    v_y1_188 = v_191;
  }
  int v_194 = (int)env_get(v_env_0, 0) - 1;
  bool v_193 = v_y_186 == v_194;
  int v_x1_192;
  if (v_193)
  {
    int v_195 = v_x_185 + 1;
    v_x1_192 = v_195;
  }
  else
  {
    v_x1_192 = v_x_185;
  }
  bool v_197 = v_y1_188 == v_x1_192;
  int v_y2_196;
  if (v_197)
  {
    int v_198 = v_y1_188 + 1;
    v_y2_196 = v_198;
  }
  else
  {
    v_y2_196 = v_y1_188;
  }
  tuple v_187 = tuple_create();
  tuple_add(v_187, (void*)v_x1_192);
  tuple_add(v_187, (void*)v_y2_196);
  return v_187;
}

int __main(env v_env_0)
{
  tuple v_3 = 0;
  list v_numlst_2 = (*(list (*)(env))closure_get_fun(list_nil))(closure_get_env(list_nil));
  tuple v___4 = 0;printf("%s", "x1 = ");
  tuple v_6 = 0;
  int v_x1_5 = (*(int (*)(env))closure_get_fun(input_int))(closure_get_env(input_int));
  tuple v___7 = 0;printf("%s", "x2 = ");
  tuple v_9 = 0;
  int v_x2_8 = (*(int (*)(env))closure_get_fun(input_int))(closure_get_env(input_int));
  tuple v___10 = 0;printf("%s", "x3 = ");
  tuple v_12 = 0;
  int v_x3_11 = (*(int (*)(env))closure_get_fun(input_int))(closure_get_env(input_int));
  tuple v___13 = 0;printf("%s", "x4 = ");
  tuple v_15 = 0;
  int v_x4_14 = (*(int (*)(env))closure_get_fun(input_int))(closure_get_env(input_int));
  string v_19 = (*(string (*)(env, int))closure_get_fun(tostring_int))(closure_get_env(tostring_int), v_x1_5);
  tuple v_18 = tuple_create();
  tuple_add(v_18, (void*)v_x1_5);
  tuple_add(v_18, (void*)v_19);
  tuple v_17 = tuple_create();
  tuple_add(v_17, (void*)v_18);
  tuple_add(v_17, (void*)v_numlst_2);
  list v_numlst_16 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_18, v_numlst_2);
  string v_23 = (*(string (*)(env, int))closure_get_fun(tostring_int))(closure_get_env(tostring_int), v_x2_8);
  tuple v_22 = tuple_create();
  tuple_add(v_22, (void*)v_x2_8);
  tuple_add(v_22, (void*)v_23);
  tuple v_21 = tuple_create();
  tuple_add(v_21, (void*)v_22);
  tuple_add(v_21, (void*)v_numlst_16);
  list v_numlst_20 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_22, v_numlst_16);
  string v_27 = (*(string (*)(env, int))closure_get_fun(tostring_int))(closure_get_env(tostring_int), v_x3_11);
  tuple v_26 = tuple_create();
  tuple_add(v_26, (void*)v_x3_11);
  tuple_add(v_26, (void*)v_27);
  tuple v_25 = tuple_create();
  tuple_add(v_25, (void*)v_26);
  tuple_add(v_25, (void*)v_numlst_20);
  list v_numlst_24 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_26, v_numlst_20);
  string v_31 = (*(string (*)(env, int))closure_get_fun(tostring_int))(closure_get_env(tostring_int), v_x4_14);
  tuple v_30 = tuple_create();
  tuple_add(v_30, (void*)v_x4_14);
  tuple_add(v_30, (void*)v_31);
  tuple v_29 = tuple_create();
  tuple_add(v_29, (void*)v_30);
  tuple_add(v_29, (void*)v_numlst_24);
  list v_numlst_28 = (*(list (*)(env, tuple, list))closure_get_fun(list_cons))(closure_get_env(list_cons), v_30, v_numlst_24);
  closure v_f_list_remove_0_32 = closure_create();
  closure_put_fun(v_f_list_remove_0_32, (void*)f_list_remove_0);
  closure v_f_list_print_1_48 = closure_create();
  closure_put_fun(v_f_list_print_1_48, (void*)f_list_print_1);
  tuple v_74 = tuple_create();
  tuple_add(v_74, (void*)v_numlst_28);
  tuple_add(v_74, (void*)4);
  tuple v___73 = (*(tuple (*)(env, list, int))closure_get_fun(v_f_list_print_1_48))(closure_get_env(v_f_list_print_1_48), v_numlst_28, 4);
  tuple v___75 = 0;printf("%s", "\n");
  closure v_f_game24_3_77 = closure_create();
  closure_put_fun(v_f_game24_3_77, (void*)f_game24_3);
  closure_add_env(v_f_game24_3_77, (void*)v_f_list_remove_0_32);
  tuple v_211 = tuple_create();
  tuple_add(v_211, (void*)v_numlst_28);
  tuple_add(v_211, (void*)4);
  tuple_add(v_211, (void*)0);
  tuple_add(v_211, (void*)1);
  tuple v___210 = (*(tuple (*)(env, list, int, int, int))closure_get_fun(v_f_game24_3_77))(closure_get_env(v_f_game24_3_77), v_numlst_28, 4, 0, 1);
  tuple v_1 = 0;
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
