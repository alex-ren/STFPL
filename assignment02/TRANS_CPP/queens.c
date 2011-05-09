#include "stfpl_header.h"

#include <stdio.h>


int f_abs_0(env v_env_0, int v_x_3);
tuple f_dots_pr_1(env v_env_0, int v_n_8);
tuple f_row_pr_2(env v_env_0, int v_n_15);
tuple f_board_pr_3(env v_env_0, tuple v_bd_24);
bool f_test2_4(env v_env_0, tuple v_x_71);
bool f_test_2_5(env v_env_0, tuple v_xyn_81);
bool f_test3_6(env v_env_0, tuple v_x_103);
bool f_test_3_7(env v_env_0, tuple v_xyn_114);
bool f_test4_8(env v_env_0, tuple v_x_135);
bool f_test_4_9(env v_env_0, tuple v_xyn_146);
bool f_test5_10(env v_env_0, tuple v_x_167);
bool f_test_5_11(env v_env_0, tuple v_xyn_178);
bool f_test6_12(env v_env_0, tuple v_x_199);
bool f_test_6_13(env v_env_0, tuple v_xyn_210);
bool f_test7_14(env v_env_0, tuple v_x_231);
bool f_test_7_15(env v_env_0, tuple v_xyn_242);
bool f_test8_16(env v_env_0, tuple v_x_263);
tuple f_inc1_17(env v_env_0, int v_x_282);
tuple f_inc2_18(env v_env_0, tuple v_xy_298);
tuple f_inc3_19(env v_env_0, tuple v_xy_324);
tuple f_inc4_20(env v_env_0, tuple v_xy_350);
tuple f_inc5_21(env v_env_0, tuple v_xy_376);
tuple f_inc6_22(env v_env_0, tuple v_xy_402);
tuple f_inc7_23(env v_env_0, tuple v_xy_428);
tuple f_inc8_24(env v_env_0, tuple v_xy_454);
int __main(env v_env_0);

int f_abs_0(env v_env_0, int v_x_3)
{
  bool v_5 = v_x_3 >= 0;
  int v_4;
  if (v_5)
  {
    v_4 = v_x_3;
  }
  else
  {
    int v_6 = -1 * v_x_3;
    v_4 = v_6;
  }
  return v_4;
}

tuple f_dots_pr_1(env v_env_0, int v_n_8)
{
  closure v_f_dots_pr_1_7 = closure_create();
  closure_put_fun(v_f_dots_pr_1_7, (void*)f_dots_pr_1);
  bool v_10 = v_n_8 > 0;
  tuple v_9;
  if (v_10)
  {
    tuple v___12 = 0;printf("%s", ". ");
    int v_13 = v_n_8 - 1;
    tuple v_11 = (*(tuple (*)(env, int))closure_get_fun(v_f_dots_pr_1_7))(closure_get_env(v_f_dots_pr_1_7), v_13);
    v_9 = v_11;
  }
  else
  {
    v_9 = 0;
  }
  return v_9;
}

tuple f_row_pr_2(env v_env_0, int v_n_15)
{
  int v_18 = v_n_15 - 1;
  tuple v___17 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_18);
  tuple v___19 = 0;printf("%s", "Q ");
  int v_21 = 8 - v_n_15;
  tuple v___20 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_21);
  tuple v_16 = 0;printf("%s", "\n");
  return v_16;
}

tuple f_board_pr_3(env v_env_0, tuple v_bd_24)
{
  tuple v_33 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_32 = (tuple)tuple_get(v_33, 1);
  tuple v_31 = (tuple)tuple_get(v_32, 1);
  tuple v_30 = (tuple)tuple_get(v_31, 1);
  tuple v_29 = (tuple)tuple_get(v_30, 1);
  tuple v_28 = (tuple)tuple_get(v_29, 1);
  int v_27 = (int)tuple_get(v_28, 1);
  tuple v___26 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_27);
  tuple v_41 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_40 = (tuple)tuple_get(v_41, 1);
  tuple v_39 = (tuple)tuple_get(v_40, 1);
  tuple v_38 = (tuple)tuple_get(v_39, 1);
  tuple v_37 = (tuple)tuple_get(v_38, 1);
  tuple v_36 = (tuple)tuple_get(v_37, 1);
  int v_35 = (int)tuple_get(v_36, 0);
  tuple v___34 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_35);
  tuple v_48 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_47 = (tuple)tuple_get(v_48, 1);
  tuple v_46 = (tuple)tuple_get(v_47, 1);
  tuple v_45 = (tuple)tuple_get(v_46, 1);
  tuple v_44 = (tuple)tuple_get(v_45, 1);
  int v_43 = (int)tuple_get(v_44, 0);
  tuple v___42 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_43);
  tuple v_54 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_53 = (tuple)tuple_get(v_54, 1);
  tuple v_52 = (tuple)tuple_get(v_53, 1);
  tuple v_51 = (tuple)tuple_get(v_52, 1);
  int v_50 = (int)tuple_get(v_51, 0);
  tuple v___49 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_50);
  tuple v_59 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_58 = (tuple)tuple_get(v_59, 1);
  tuple v_57 = (tuple)tuple_get(v_58, 1);
  int v_56 = (int)tuple_get(v_57, 0);
  tuple v___55 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_56);
  tuple v_63 = (tuple)tuple_get(v_bd_24, 1);
  tuple v_62 = (tuple)tuple_get(v_63, 1);
  int v_61 = (int)tuple_get(v_62, 0);
  tuple v___60 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_61);
  tuple v_66 = (tuple)tuple_get(v_bd_24, 1);
  int v_65 = (int)tuple_get(v_66, 0);
  tuple v___64 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_65);
  int v_68 = (int)tuple_get(v_bd_24, 0);
  tuple v___67 = (*(tuple (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_68);
  tuple v_25 = 0;
  return 0;
}

bool f_test2_4(env v_env_0, tuple v_x_71)
{
  int v_x1_73 = (int)tuple_get(v_x_71, 0);
  int v_x2_74 = (int)tuple_get(v_x_71, 1);
  bool v_75 = v_x1_73 == v_x2_74;
  bool v_72;
  if (v_75)
  {
    v_72 = false;
  }
  else
  {
    int v_78 = v_x1_73 - v_x2_74;
    int v_77 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_78);
    bool v_76 = v_77 != 1;
    v_72 = v_76;
  }
  return v_72;
}

bool f_test_2_5(env v_env_0, tuple v_xyn_81)
{
  int v_x_83 = (int)tuple_get(v_xyn_81, 0);
  tuple v_yn_84 = (tuple)tuple_get(v_xyn_81, 1);
  tuple v_y_85 = (tuple)tuple_get(v_yn_84, 0);
  int v_n_86 = (int)tuple_get(v_yn_84, 1);
  int v_y1_87 = (int)tuple_get(v_y_85, 0);
  int v_y2_88 = (int)tuple_get(v_y_85, 1);
  bool v_89 = v_x_83 == v_y1_87;
  bool v_82;
  if (v_89)
  {
    v_82 = false;
  }
  else
  {
    int v_93 = v_x_83 - v_y1_87;
    int v_92 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_93);
    int v_94 = v_n_86 + 1;
    bool v_91 = v_92 == v_94;
    bool v_90;
    if (v_91)
    {
      v_90 = false;
    }
    else
    {
      bool v_96 = v_x_83 == v_y2_88;
      bool v_95;
      if (v_96)
      {
        v_95 = false;
      }
      else
      {
        int v_99 = v_x_83 - v_y2_88;
        int v_98 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_99);
        int v_100 = v_n_86 + 2;
        bool v_97 = v_98 != v_100;
        v_95 = v_97;
      }
      v_90 = v_95;
    }
    v_82 = v_90;
  }
  return v_82;
}

bool f_test3_6(env v_env_0, tuple v_x_103)
{
  int v_x1_105 = (int)tuple_get(v_x_103, 0);
  tuple v_x2_106 = (tuple)tuple_get(v_x_103, 1);
  tuple v_109 = tuple_create();
  tuple_add(v_109, (void*)v_x2_106);
  tuple_add(v_109, (void*)0);
  tuple v_108 = tuple_create();
  tuple_add(v_108, (void*)v_x1_105);
  tuple_add(v_108, (void*)v_109);
  bool v_107 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_108);
  bool v_104;
  if (v_107)
  {
    bool v_110 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_106);
    v_104 = v_110;
  }
  else
  {
    v_104 = false;
  }
  return v_104;
}

bool f_test_3_7(env v_env_0, tuple v_xyn_114)
{
  int v_x_116 = (int)tuple_get(v_xyn_114, 0);
  tuple v_yn_117 = (tuple)tuple_get(v_xyn_114, 1);
  tuple v_y_118 = (tuple)tuple_get(v_yn_117, 0);
  int v_n_119 = (int)tuple_get(v_yn_117, 1);
  int v_y1_120 = (int)tuple_get(v_y_118, 0);
  tuple v_y2_121 = (tuple)tuple_get(v_y_118, 1);
  bool v_122 = v_x_116 == v_y1_120;
  bool v_115;
  if (v_122)
  {
    v_115 = false;
  }
  else
  {
    int v_126 = v_x_116 - v_y1_120;
    int v_125 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_126);
    int v_127 = v_n_119 + 1;
    bool v_124 = v_125 == v_127;
    bool v_123;
    if (v_124)
    {
      v_123 = false;
    }
    else
    {
      int v_131 = v_n_119 + 1;
      tuple v_130 = tuple_create();
      tuple_add(v_130, (void*)v_y2_121);
      tuple_add(v_130, (void*)v_131);
      tuple v_129 = tuple_create();
      tuple_add(v_129, (void*)v_x_116);
      tuple_add(v_129, (void*)v_130);
      bool v_128 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_129);
      v_123 = v_128;
    }
    v_115 = v_123;
  }
  return v_115;
}

bool f_test4_8(env v_env_0, tuple v_x_135)
{
  int v_x1_137 = (int)tuple_get(v_x_135, 0);
  tuple v_x2_138 = (tuple)tuple_get(v_x_135, 1);
  tuple v_141 = tuple_create();
  tuple_add(v_141, (void*)v_x2_138);
  tuple_add(v_141, (void*)0);
  tuple v_140 = tuple_create();
  tuple_add(v_140, (void*)v_x1_137);
  tuple_add(v_140, (void*)v_141);
  bool v_139 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_140);
  bool v_136;
  if (v_139)
  {
    bool v_142 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_138);
    v_136 = v_142;
  }
  else
  {
    v_136 = false;
  }
  return v_136;
}

bool f_test_4_9(env v_env_0, tuple v_xyn_146)
{
  int v_x_148 = (int)tuple_get(v_xyn_146, 0);
  tuple v_yn_149 = (tuple)tuple_get(v_xyn_146, 1);
  tuple v_y_150 = (tuple)tuple_get(v_yn_149, 0);
  int v_n_151 = (int)tuple_get(v_yn_149, 1);
  int v_y1_152 = (int)tuple_get(v_y_150, 0);
  tuple v_y2_153 = (tuple)tuple_get(v_y_150, 1);
  bool v_154 = v_x_148 == v_y1_152;
  bool v_147;
  if (v_154)
  {
    v_147 = false;
  }
  else
  {
    int v_158 = v_x_148 - v_y1_152;
    int v_157 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_158);
    int v_159 = v_n_151 + 1;
    bool v_156 = v_157 == v_159;
    bool v_155;
    if (v_156)
    {
      v_155 = false;
    }
    else
    {
      int v_163 = v_n_151 + 1;
      tuple v_162 = tuple_create();
      tuple_add(v_162, (void*)v_y2_153);
      tuple_add(v_162, (void*)v_163);
      tuple v_161 = tuple_create();
      tuple_add(v_161, (void*)v_x_148);
      tuple_add(v_161, (void*)v_162);
      bool v_160 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_161);
      v_155 = v_160;
    }
    v_147 = v_155;
  }
  return v_147;
}

bool f_test5_10(env v_env_0, tuple v_x_167)
{
  int v_x1_169 = (int)tuple_get(v_x_167, 0);
  tuple v_x2_170 = (tuple)tuple_get(v_x_167, 1);
  tuple v_173 = tuple_create();
  tuple_add(v_173, (void*)v_x2_170);
  tuple_add(v_173, (void*)0);
  tuple v_172 = tuple_create();
  tuple_add(v_172, (void*)v_x1_169);
  tuple_add(v_172, (void*)v_173);
  bool v_171 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_172);
  bool v_168;
  if (v_171)
  {
    bool v_174 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_170);
    v_168 = v_174;
  }
  else
  {
    v_168 = false;
  }
  return v_168;
}

bool f_test_5_11(env v_env_0, tuple v_xyn_178)
{
  int v_x_180 = (int)tuple_get(v_xyn_178, 0);
  tuple v_yn_181 = (tuple)tuple_get(v_xyn_178, 1);
  tuple v_y_182 = (tuple)tuple_get(v_yn_181, 0);
  int v_n_183 = (int)tuple_get(v_yn_181, 1);
  int v_y1_184 = (int)tuple_get(v_y_182, 0);
  tuple v_y2_185 = (tuple)tuple_get(v_y_182, 1);
  bool v_186 = v_x_180 == v_y1_184;
  bool v_179;
  if (v_186)
  {
    v_179 = false;
  }
  else
  {
    int v_190 = v_x_180 - v_y1_184;
    int v_189 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_190);
    int v_191 = v_n_183 + 1;
    bool v_188 = v_189 == v_191;
    bool v_187;
    if (v_188)
    {
      v_187 = false;
    }
    else
    {
      int v_195 = v_n_183 + 1;
      tuple v_194 = tuple_create();
      tuple_add(v_194, (void*)v_y2_185);
      tuple_add(v_194, (void*)v_195);
      tuple v_193 = tuple_create();
      tuple_add(v_193, (void*)v_x_180);
      tuple_add(v_193, (void*)v_194);
      bool v_192 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_193);
      v_187 = v_192;
    }
    v_179 = v_187;
  }
  return v_179;
}

bool f_test6_12(env v_env_0, tuple v_x_199)
{
  int v_x1_201 = (int)tuple_get(v_x_199, 0);
  tuple v_x2_202 = (tuple)tuple_get(v_x_199, 1);
  tuple v_205 = tuple_create();
  tuple_add(v_205, (void*)v_x2_202);
  tuple_add(v_205, (void*)0);
  tuple v_204 = tuple_create();
  tuple_add(v_204, (void*)v_x1_201);
  tuple_add(v_204, (void*)v_205);
  bool v_203 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_204);
  bool v_200;
  if (v_203)
  {
    bool v_206 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_202);
    v_200 = v_206;
  }
  else
  {
    v_200 = false;
  }
  return v_200;
}

bool f_test_6_13(env v_env_0, tuple v_xyn_210)
{
  int v_x_212 = (int)tuple_get(v_xyn_210, 0);
  tuple v_yn_213 = (tuple)tuple_get(v_xyn_210, 1);
  tuple v_y_214 = (tuple)tuple_get(v_yn_213, 0);
  int v_n_215 = (int)tuple_get(v_yn_213, 1);
  int v_y1_216 = (int)tuple_get(v_y_214, 0);
  tuple v_y2_217 = (tuple)tuple_get(v_y_214, 1);
  bool v_218 = v_x_212 == v_y1_216;
  bool v_211;
  if (v_218)
  {
    v_211 = false;
  }
  else
  {
    int v_222 = v_x_212 - v_y1_216;
    int v_221 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_222);
    int v_223 = v_n_215 + 1;
    bool v_220 = v_221 == v_223;
    bool v_219;
    if (v_220)
    {
      v_219 = false;
    }
    else
    {
      int v_227 = v_n_215 + 1;
      tuple v_226 = tuple_create();
      tuple_add(v_226, (void*)v_y2_217);
      tuple_add(v_226, (void*)v_227);
      tuple v_225 = tuple_create();
      tuple_add(v_225, (void*)v_x_212);
      tuple_add(v_225, (void*)v_226);
      bool v_224 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_225);
      v_219 = v_224;
    }
    v_211 = v_219;
  }
  return v_211;
}

bool f_test7_14(env v_env_0, tuple v_x_231)
{
  int v_x1_233 = (int)tuple_get(v_x_231, 0);
  tuple v_x2_234 = (tuple)tuple_get(v_x_231, 1);
  tuple v_237 = tuple_create();
  tuple_add(v_237, (void*)v_x2_234);
  tuple_add(v_237, (void*)0);
  tuple v_236 = tuple_create();
  tuple_add(v_236, (void*)v_x1_233);
  tuple_add(v_236, (void*)v_237);
  bool v_235 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_236);
  bool v_232;
  if (v_235)
  {
    bool v_238 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_234);
    v_232 = v_238;
  }
  else
  {
    v_232 = false;
  }
  return v_232;
}

bool f_test_7_15(env v_env_0, tuple v_xyn_242)
{
  int v_x_244 = (int)tuple_get(v_xyn_242, 0);
  tuple v_yn_245 = (tuple)tuple_get(v_xyn_242, 1);
  tuple v_y_246 = (tuple)tuple_get(v_yn_245, 0);
  int v_n_247 = (int)tuple_get(v_yn_245, 1);
  int v_y1_248 = (int)tuple_get(v_y_246, 0);
  tuple v_y2_249 = (tuple)tuple_get(v_y_246, 1);
  bool v_250 = v_x_244 == v_y1_248;
  bool v_243;
  if (v_250)
  {
    v_243 = false;
  }
  else
  {
    int v_254 = v_x_244 - v_y1_248;
    int v_253 = (*(int (*)(env, int))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_254);
    int v_255 = v_n_247 + 1;
    bool v_252 = v_253 == v_255;
    bool v_251;
    if (v_252)
    {
      v_251 = false;
    }
    else
    {
      int v_259 = v_n_247 + 1;
      tuple v_258 = tuple_create();
      tuple_add(v_258, (void*)v_y2_249);
      tuple_add(v_258, (void*)v_259);
      tuple v_257 = tuple_create();
      tuple_add(v_257, (void*)v_x_244);
      tuple_add(v_257, (void*)v_258);
      bool v_256 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_257);
      v_251 = v_256;
    }
    v_243 = v_251;
  }
  return v_243;
}

bool f_test8_16(env v_env_0, tuple v_x_263)
{
  int v_x1_265 = (int)tuple_get(v_x_263, 0);
  tuple v_x2_266 = (tuple)tuple_get(v_x_263, 1);
  tuple v_269 = tuple_create();
  tuple_add(v_269, (void*)v_x2_266);
  tuple_add(v_269, (void*)0);
  tuple v_268 = tuple_create();
  tuple_add(v_268, (void*)v_x1_265);
  tuple_add(v_268, (void*)v_269);
  bool v_267 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_268);
  bool v_264;
  if (v_267)
  {
    bool v_270 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_x2_266);
    v_264 = v_270;
  }
  else
  {
    v_264 = false;
  }
  return v_264;
}

tuple f_inc1_17(env v_env_0, int v_x_282)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  bool v_284 = v_x_282 < 8;
  tuple v_283;
  if (v_284)
  {
    int v_287 = v_x_282 + 1;
    tuple v_286 = tuple_create();
    tuple_add(v_286, (void*)0);
    tuple_add(v_286, (void*)v_287);
    tuple v_285 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc2_18_274))(closure_get_env(v_f_inc2_18_274), v_286);
    v_283 = v_285;
  }
  else
  {
    tuple v_288 = 0;
    v_283 = 0;
  }
  return v_283;
}

tuple f_inc2_18(env v_env_0, tuple v_xy_298)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_300 = (int)tuple_get(v_xy_298, 0);
  int v_y_301 = (int)tuple_get(v_xy_298, 1);
  bool v_302 = v_x_300 < 8;
  tuple v_299;
  if (v_302)
  {
    int v_306 = v_x_300 + 1;
    tuple v_305 = tuple_create();
    tuple_add(v_305, (void*)v_306);
    tuple_add(v_305, (void*)v_y_301);
    bool v_304 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 1)))(closure_get_env((closure)env_get(v_env_0, 1)), v_305);
    tuple v_303;
    if (v_304)
    {
      int v_310 = v_x_300 + 1;
      tuple v_309 = tuple_create();
      tuple_add(v_309, (void*)v_310);
      tuple_add(v_309, (void*)v_y_301);
      tuple v_308 = tuple_create();
      tuple_add(v_308, (void*)0);
      tuple_add(v_308, (void*)v_309);
      tuple v_307 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc3_19_275))(closure_get_env(v_f_inc3_19_275), v_308);
      v_303 = v_307;
    }
    else
    {
      int v_313 = v_x_300 + 1;
      tuple v_312 = tuple_create();
      tuple_add(v_312, (void*)v_313);
      tuple_add(v_312, (void*)v_y_301);
      tuple v_311 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc2_18_274))(closure_get_env(v_f_inc2_18_274), v_312);
      v_303 = v_311;
    }
    v_299 = v_303;
  }
  else
  {
    tuple v_314 = (*(tuple (*)(env, int))closure_get_fun(v_f_inc1_17_273))(closure_get_env(v_f_inc1_17_273), v_y_301);
    v_299 = v_314;
  }
  return v_299;
}

tuple f_inc3_19(env v_env_0, tuple v_xy_324)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_326 = (int)tuple_get(v_xy_324, 0);
  tuple v_y_327 = (tuple)tuple_get(v_xy_324, 1);
  bool v_328 = v_x_326 < 8;
  tuple v_325;
  if (v_328)
  {
    int v_332 = v_x_326 + 1;
    tuple v_331 = tuple_create();
    tuple_add(v_331, (void*)v_332);
    tuple_add(v_331, (void*)v_y_327);
    bool v_330 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 2)))(closure_get_env((closure)env_get(v_env_0, 2)), v_331);
    tuple v_329;
    if (v_330)
    {
      int v_336 = v_x_326 + 1;
      tuple v_335 = tuple_create();
      tuple_add(v_335, (void*)v_336);
      tuple_add(v_335, (void*)v_y_327);
      tuple v_334 = tuple_create();
      tuple_add(v_334, (void*)0);
      tuple_add(v_334, (void*)v_335);
      tuple v_333 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc4_20_276))(closure_get_env(v_f_inc4_20_276), v_334);
      v_329 = v_333;
    }
    else
    {
      int v_339 = v_x_326 + 1;
      tuple v_338 = tuple_create();
      tuple_add(v_338, (void*)v_339);
      tuple_add(v_338, (void*)v_y_327);
      tuple v_337 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc3_19_275))(closure_get_env(v_f_inc3_19_275), v_338);
      v_329 = v_337;
    }
    v_325 = v_329;
  }
  else
  {
    tuple v_340 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc2_18_274))(closure_get_env(v_f_inc2_18_274), v_y_327);
    v_325 = v_340;
  }
  return v_325;
}

tuple f_inc4_20(env v_env_0, tuple v_xy_350)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_352 = (int)tuple_get(v_xy_350, 0);
  tuple v_y_353 = (tuple)tuple_get(v_xy_350, 1);
  bool v_354 = v_x_352 < 8;
  tuple v_351;
  if (v_354)
  {
    int v_358 = v_x_352 + 1;
    tuple v_357 = tuple_create();
    tuple_add(v_357, (void*)v_358);
    tuple_add(v_357, (void*)v_y_353);
    bool v_356 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 3)))(closure_get_env((closure)env_get(v_env_0, 3)), v_357);
    tuple v_355;
    if (v_356)
    {
      int v_362 = v_x_352 + 1;
      tuple v_361 = tuple_create();
      tuple_add(v_361, (void*)v_362);
      tuple_add(v_361, (void*)v_y_353);
      tuple v_360 = tuple_create();
      tuple_add(v_360, (void*)0);
      tuple_add(v_360, (void*)v_361);
      tuple v_359 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc5_21_277))(closure_get_env(v_f_inc5_21_277), v_360);
      v_355 = v_359;
    }
    else
    {
      int v_365 = v_x_352 + 1;
      tuple v_364 = tuple_create();
      tuple_add(v_364, (void*)v_365);
      tuple_add(v_364, (void*)v_y_353);
      tuple v_363 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc4_20_276))(closure_get_env(v_f_inc4_20_276), v_364);
      v_355 = v_363;
    }
    v_351 = v_355;
  }
  else
  {
    tuple v_366 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc3_19_275))(closure_get_env(v_f_inc3_19_275), v_y_353);
    v_351 = v_366;
  }
  return v_351;
}

tuple f_inc5_21(env v_env_0, tuple v_xy_376)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_378 = (int)tuple_get(v_xy_376, 0);
  tuple v_y_379 = (tuple)tuple_get(v_xy_376, 1);
  bool v_380 = v_x_378 < 8;
  tuple v_377;
  if (v_380)
  {
    int v_384 = v_x_378 + 1;
    tuple v_383 = tuple_create();
    tuple_add(v_383, (void*)v_384);
    tuple_add(v_383, (void*)v_y_379);
    bool v_382 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 4)))(closure_get_env((closure)env_get(v_env_0, 4)), v_383);
    tuple v_381;
    if (v_382)
    {
      int v_388 = v_x_378 + 1;
      tuple v_387 = tuple_create();
      tuple_add(v_387, (void*)v_388);
      tuple_add(v_387, (void*)v_y_379);
      tuple v_386 = tuple_create();
      tuple_add(v_386, (void*)0);
      tuple_add(v_386, (void*)v_387);
      tuple v_385 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc6_22_278))(closure_get_env(v_f_inc6_22_278), v_386);
      v_381 = v_385;
    }
    else
    {
      int v_391 = v_x_378 + 1;
      tuple v_390 = tuple_create();
      tuple_add(v_390, (void*)v_391);
      tuple_add(v_390, (void*)v_y_379);
      tuple v_389 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc5_21_277))(closure_get_env(v_f_inc5_21_277), v_390);
      v_381 = v_389;
    }
    v_377 = v_381;
  }
  else
  {
    tuple v_392 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc4_20_276))(closure_get_env(v_f_inc4_20_276), v_y_379);
    v_377 = v_392;
  }
  return v_377;
}

tuple f_inc6_22(env v_env_0, tuple v_xy_402)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_404 = (int)tuple_get(v_xy_402, 0);
  tuple v_y_405 = (tuple)tuple_get(v_xy_402, 1);
  bool v_406 = v_x_404 < 8;
  tuple v_403;
  if (v_406)
  {
    int v_410 = v_x_404 + 1;
    tuple v_409 = tuple_create();
    tuple_add(v_409, (void*)v_410);
    tuple_add(v_409, (void*)v_y_405);
    bool v_408 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 5)))(closure_get_env((closure)env_get(v_env_0, 5)), v_409);
    tuple v_407;
    if (v_408)
    {
      int v_414 = v_x_404 + 1;
      tuple v_413 = tuple_create();
      tuple_add(v_413, (void*)v_414);
      tuple_add(v_413, (void*)v_y_405);
      tuple v_412 = tuple_create();
      tuple_add(v_412, (void*)0);
      tuple_add(v_412, (void*)v_413);
      tuple v_411 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc7_23_279))(closure_get_env(v_f_inc7_23_279), v_412);
      v_407 = v_411;
    }
    else
    {
      int v_417 = v_x_404 + 1;
      tuple v_416 = tuple_create();
      tuple_add(v_416, (void*)v_417);
      tuple_add(v_416, (void*)v_y_405);
      tuple v_415 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc6_22_278))(closure_get_env(v_f_inc6_22_278), v_416);
      v_407 = v_415;
    }
    v_403 = v_407;
  }
  else
  {
    tuple v_418 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc5_21_277))(closure_get_env(v_f_inc5_21_277), v_y_405);
    v_403 = v_418;
  }
  return v_403;
}

tuple f_inc7_23(env v_env_0, tuple v_xy_428)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_430 = (int)tuple_get(v_xy_428, 0);
  tuple v_y_431 = (tuple)tuple_get(v_xy_428, 1);
  bool v_432 = v_x_430 < 8;
  tuple v_429;
  if (v_432)
  {
    int v_436 = v_x_430 + 1;
    tuple v_435 = tuple_create();
    tuple_add(v_435, (void*)v_436);
    tuple_add(v_435, (void*)v_y_431);
    bool v_434 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 6)))(closure_get_env((closure)env_get(v_env_0, 6)), v_435);
    tuple v_433;
    if (v_434)
    {
      int v_440 = v_x_430 + 1;
      tuple v_439 = tuple_create();
      tuple_add(v_439, (void*)v_440);
      tuple_add(v_439, (void*)v_y_431);
      tuple v_438 = tuple_create();
      tuple_add(v_438, (void*)0);
      tuple_add(v_438, (void*)v_439);
      tuple v_437 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc8_24_280))(closure_get_env(v_f_inc8_24_280), v_438);
      v_433 = v_437;
    }
    else
    {
      int v_443 = v_x_430 + 1;
      tuple v_442 = tuple_create();
      tuple_add(v_442, (void*)v_443);
      tuple_add(v_442, (void*)v_y_431);
      tuple v_441 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc7_23_279))(closure_get_env(v_f_inc7_23_279), v_442);
      v_433 = v_441;
    }
    v_429 = v_433;
  }
  else
  {
    tuple v_444 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc6_22_278))(closure_get_env(v_f_inc6_22_278), v_y_431);
    v_429 = v_444;
  }
  return v_429;
}

tuple f_inc8_24(env v_env_0, tuple v_xy_454)
{
  closure v_f_inc1_17_273 = closure_create();
  closure_put_fun(v_f_inc1_17_273, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc1_17_273, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc2_18_274 = closure_create();
  closure_put_fun(v_f_inc2_18_274, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc2_18_274, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc3_19_275 = closure_create();
  closure_put_fun(v_f_inc3_19_275, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc3_19_275, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc4_20_276 = closure_create();
  closure_put_fun(v_f_inc4_20_276, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc4_20_276, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc5_21_277 = closure_create();
  closure_put_fun(v_f_inc5_21_277, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc5_21_277, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc6_22_278 = closure_create();
  closure_put_fun(v_f_inc6_22_278, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc6_22_278, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc7_23_279 = closure_create();
  closure_put_fun(v_f_inc7_23_279, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc7_23_279, (void*)(closure)env_get(v_env_0, 7));
  closure v_f_inc8_24_280 = closure_create();
  closure_put_fun(v_f_inc8_24_280, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 0));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 1));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 2));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 3));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 4));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 5));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 6));
  closure_add_env(v_f_inc8_24_280, (void*)(closure)env_get(v_env_0, 7));
  int v_x_456 = (int)tuple_get(v_xy_454, 0);
  tuple v_y_457 = (tuple)tuple_get(v_xy_454, 1);
  bool v_458 = v_x_456 < 8;
  tuple v_455;
  if (v_458)
  {
    int v_462 = v_x_456 + 1;
    tuple v_461 = tuple_create();
    tuple_add(v_461, (void*)v_462);
    tuple_add(v_461, (void*)v_y_457);
    bool v_460 = (*(bool (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 7)))(closure_get_env((closure)env_get(v_env_0, 7)), v_461);
    tuple v_459;
    if (v_460)
    {
      int v_466 = v_x_456 + 1;
      tuple v_465 = tuple_create();
      tuple_add(v_465, (void*)v_466);
      tuple_add(v_465, (void*)v_y_457);
      tuple v___464 = (*(tuple (*)(env, tuple))closure_get_fun((closure)env_get(v_env_0, 0)))(closure_get_env((closure)env_get(v_env_0, 0)), v_465);
      tuple v___467 = 0;printf("%s", "\n");
      int v_469 = v_x_456 + 1;
      tuple v_468 = tuple_create();
      tuple_add(v_468, (void*)v_469);
      tuple_add(v_468, (void*)v_y_457);
      tuple v_463 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc8_24_280))(closure_get_env(v_f_inc8_24_280), v_468);
      v_459 = v_463;
    }
    else
    {
      int v_472 = v_x_456 + 1;
      tuple v_471 = tuple_create();
      tuple_add(v_471, (void*)v_472);
      tuple_add(v_471, (void*)v_y_457);
      tuple v_470 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc8_24_280))(closure_get_env(v_f_inc8_24_280), v_471);
      v_459 = v_470;
    }
    v_455 = v_459;
  }
  else
  {
    tuple v_473 = (*(tuple (*)(env, tuple))closure_get_fun(v_f_inc7_23_279))(closure_get_env(v_f_inc7_23_279), v_y_457);
    v_455 = v_473;
  }
  return v_455;
}

int __main(env v_env_0)
{
  closure v_f_abs_0_2 = closure_create();
  closure_put_fun(v_f_abs_0_2, (void*)f_abs_0);
  closure v_f_dots_pr_1_7 = closure_create();
  closure_put_fun(v_f_dots_pr_1_7, (void*)f_dots_pr_1);
  closure v_f_row_pr_2_14 = closure_create();
  closure_put_fun(v_f_row_pr_2_14, (void*)f_row_pr_2);
  closure_add_env(v_f_row_pr_2_14, (void*)v_f_dots_pr_1_7);
  closure v_f_board_pr_3_23 = closure_create();
  closure_put_fun(v_f_board_pr_3_23, (void*)f_board_pr_3);
  closure_add_env(v_f_board_pr_3_23, (void*)v_f_row_pr_2_14);
  closure v_f_test2_4_70 = closure_create();
  closure_put_fun(v_f_test2_4_70, (void*)f_test2_4);
  closure_add_env(v_f_test2_4_70, (void*)v_f_abs_0_2);
  closure v_f_test_2_5_80 = closure_create();
  closure_put_fun(v_f_test_2_5_80, (void*)f_test_2_5);
  closure_add_env(v_f_test_2_5_80, (void*)v_f_abs_0_2);
  closure v_f_test3_6_102 = closure_create();
  closure_put_fun(v_f_test3_6_102, (void*)f_test3_6);
  closure_add_env(v_f_test3_6_102, (void*)v_f_test2_4_70);
  closure_add_env(v_f_test3_6_102, (void*)v_f_test_2_5_80);
  closure v_f_test_3_7_113 = closure_create();
  closure_put_fun(v_f_test_3_7_113, (void*)f_test_3_7);
  closure_add_env(v_f_test_3_7_113, (void*)v_f_abs_0_2);
  closure_add_env(v_f_test_3_7_113, (void*)v_f_test_2_5_80);
  closure v_f_test4_8_134 = closure_create();
  closure_put_fun(v_f_test4_8_134, (void*)f_test4_8);
  closure_add_env(v_f_test4_8_134, (void*)v_f_test3_6_102);
  closure_add_env(v_f_test4_8_134, (void*)v_f_test_3_7_113);
  closure v_f_test_4_9_145 = closure_create();
  closure_put_fun(v_f_test_4_9_145, (void*)f_test_4_9);
  closure_add_env(v_f_test_4_9_145, (void*)v_f_abs_0_2);
  closure_add_env(v_f_test_4_9_145, (void*)v_f_test_3_7_113);
  closure v_f_test5_10_166 = closure_create();
  closure_put_fun(v_f_test5_10_166, (void*)f_test5_10);
  closure_add_env(v_f_test5_10_166, (void*)v_f_test4_8_134);
  closure_add_env(v_f_test5_10_166, (void*)v_f_test_4_9_145);
  closure v_f_test_5_11_177 = closure_create();
  closure_put_fun(v_f_test_5_11_177, (void*)f_test_5_11);
  closure_add_env(v_f_test_5_11_177, (void*)v_f_abs_0_2);
  closure_add_env(v_f_test_5_11_177, (void*)v_f_test_4_9_145);
  closure v_f_test6_12_198 = closure_create();
  closure_put_fun(v_f_test6_12_198, (void*)f_test6_12);
  closure_add_env(v_f_test6_12_198, (void*)v_f_test5_10_166);
  closure_add_env(v_f_test6_12_198, (void*)v_f_test_5_11_177);
  closure v_f_test_6_13_209 = closure_create();
  closure_put_fun(v_f_test_6_13_209, (void*)f_test_6_13);
  closure_add_env(v_f_test_6_13_209, (void*)v_f_abs_0_2);
  closure_add_env(v_f_test_6_13_209, (void*)v_f_test_5_11_177);
  closure v_f_test7_14_230 = closure_create();
  closure_put_fun(v_f_test7_14_230, (void*)f_test7_14);
  closure_add_env(v_f_test7_14_230, (void*)v_f_test6_12_198);
  closure_add_env(v_f_test7_14_230, (void*)v_f_test_6_13_209);
  closure v_f_test_7_15_241 = closure_create();
  closure_put_fun(v_f_test_7_15_241, (void*)f_test_7_15);
  closure_add_env(v_f_test_7_15_241, (void*)v_f_abs_0_2);
  closure_add_env(v_f_test_7_15_241, (void*)v_f_test_6_13_209);
  closure v_f_test8_16_262 = closure_create();
  closure_put_fun(v_f_test8_16_262, (void*)f_test8_16);
  closure_add_env(v_f_test8_16_262, (void*)v_f_test7_14_230);
  closure_add_env(v_f_test8_16_262, (void*)v_f_test_7_15_241);
  closure v_f_inc1_17_281 = closure_create();
  closure_put_fun(v_f_inc1_17_281, (void*)f_inc1_17);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc1_17_281, (void*)v_f_test8_16_262);
  closure v_f_inc2_18_297 = closure_create();
  closure_put_fun(v_f_inc2_18_297, (void*)f_inc2_18);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc2_18_297, (void*)v_f_test8_16_262);
  closure v_f_inc3_19_323 = closure_create();
  closure_put_fun(v_f_inc3_19_323, (void*)f_inc3_19);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc3_19_323, (void*)v_f_test8_16_262);
  closure v_f_inc4_20_349 = closure_create();
  closure_put_fun(v_f_inc4_20_349, (void*)f_inc4_20);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc4_20_349, (void*)v_f_test8_16_262);
  closure v_f_inc5_21_375 = closure_create();
  closure_put_fun(v_f_inc5_21_375, (void*)f_inc5_21);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc5_21_375, (void*)v_f_test8_16_262);
  closure v_f_inc6_22_401 = closure_create();
  closure_put_fun(v_f_inc6_22_401, (void*)f_inc6_22);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc6_22_401, (void*)v_f_test8_16_262);
  closure v_f_inc7_23_427 = closure_create();
  closure_put_fun(v_f_inc7_23_427, (void*)f_inc7_23);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc7_23_427, (void*)v_f_test8_16_262);
  closure v_f_inc8_24_453 = closure_create();
  closure_put_fun(v_f_inc8_24_453, (void*)f_inc8_24);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_board_pr_3_23);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test2_4_70);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test3_6_102);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test4_8_134);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test5_10_166);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test6_12_198);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test7_14_230);
  closure_add_env(v_f_inc8_24_453, (void*)v_f_test8_16_262);
  tuple v_1 = (*(tuple (*)(env, int))closure_get_fun(v_f_inc1_17_281))(closure_get_env(v_f_inc1_17_281), 0);
  return 0;
}

int main (int argc, char *argv)
{
  init_lib();
  


  __main(0);
  return 0;
}
