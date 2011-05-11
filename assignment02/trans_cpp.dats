
(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans2.sats"
staload "trans_cpp.sats"
staload "error.sats"
staload "absyn.sats"
staload "symbol.sats"

staload "ostream.sats"
staload "string_opr.sats"

(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
// staload _(*anon*) = "prelude/DATS/reference.dats" 
// 
#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

val machine_bits = 32

val i32_64 = (if machine_bits = 32 then "int" else "long"): string

val env_str = "env"
val env_tmpvar = tmpvar_new (env_str)
val env_arg = make_valprim (VPtmp (env_tmpvar), T2YPenv)

(* header for the generated cpp files *)
val header = "#include \"stfpl_header.h\"\n\n": string
val header = (header + "#include <stdio.h>\n\n"): string
// val ftyp_0 = "__ftype0": string  // nullary function type
// val ftyp_1 = "__ftype1": string  // multi args function type
// val header_ftyp = "typedef void * (*" + ftyp_0 + ")();\n"
// val header_ftyp = header_ftyp + "typedef void * (*" + ftyp_1 + ")(void *);\n"
val initialization_str = "init_lib();"




// #define Some0 option0_some
// #define None0 option0_none
datatype statement_t =
  | STATplain of string
  | STATcomp of statements_t
where statements_t = list0 statement_t

typedef statements = statements_t
typedef statement = statement_t

extern fun statements_to_string (stats: statements, level: int): string

extern fun trans_cpp_instrs (instrs: instrlst): statements
extern fun trans_cpp_fundef (fundef: funent): statements

val arg_pad = "__args": string
val indent_pad = "  ": string
val scope_beg = "{": string
val scope_end = "}": string

implement statements_to_string (stats, level) = let
  fun level_string (i: int): string =
    if i <= 0 then "" else indent_pad + level_string (i - 1)
  
  val indent_pad = level_string (level)
in
  case+ stats of
  | cons (stat, stats1) => 
    (case+ stat of
    | STATplain str => let
      val cur = indent_pad + str + "\n"
      val rest = statements_to_string (stats1, level)
    in
      cur + rest
    end
    | STATcomp stats' => let
      val cur = statements_to_string (stats', level + 1)
      val rest = statements_to_string (stats1, level)
    in
      cur + rest
    end
    )
  | nil () => ""
end  // end of [statements_to_string]

fun trans_cpp_typ (t2yp: t2yp): string =
  case+ t2yp of
  | T2YPint ()  => i32_64
  | T2YPbool () => "bool"
  | T2YPstr ()  => "string"
  | T2YPenv ()  => "env"
  | T2YPlist (_) => "list"
  | T2YPvar ()  => "any"
  | T2YPclo (_, _, _)  => "closure"
  | T2YPtup (_)  => "tuple"

fun trans_cpp_valprimlst_typ (args: valprimlst, i: int): string = loop (args, i) where {
  fun loop (args: valprimlst, i: int): string = 
    case+ args of
    | cons (arg, args1) => let
      val t2yp = arg.valprim_typ

      val arg_typ = trans_cpp_typ (t2yp)
      val arg_str = if (i > 0) then ", " + arg_typ else arg_typ
    in
      arg_str + loop (args1, i + 1)
    end
    | nil () => ""
}

fun trans_cpp_args (args: valprimlst): string = loop (args, 0) where {
  fun loop (args: valprimlst, i: int): string = 
    case+ args of
    | cons (arg, args1) => let
      val t2yp = arg.valprim_typ
      val node = arg.valprim_node
      val tmpvar = (case+ node of
          | VPtmp (tmpvar) => tmpvar
          | _ => let
             // val () = fprint_valprim (stderr_ref, arg)
          in
             ETRACE_MSG_OPR ("trans_cpp_args args should be VPtmp\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
          end
          ): tmpvar
      val arg_nam = tmpvar_get_name (tmpvar)
      val arg_typ = trans_cpp_typ (t2yp)
      val arg_str = arg_typ + " " + arg_nam
      val arg_str = if (i > 0) then ", " + arg_str else arg_str
    in
      arg_str + loop (args1, i + 1)
    end
    | nil () => ""
}

fun trans_cpp_fun_decl (ent: funent_t):<cloref1> string = let
  val fl = funent_get_lab (ent)
  val nam = funlab_get_name (fl)
  val args = funent_get_args (ent)

  val ret_vp = funent_get_ret (ent)
  val ret_typ = trans_cpp_typ (ret_vp.valprim_typ)

  val stat = ret_typ + " " + nam + "("
  val stat = stat + trans_cpp_args (cons (env_arg, args)) + ")"
in
  stat
end

fun trans_cpp_funlst_decl (fns: list0 funent_t, os: &ostream): void = let
  fun helper (init: string, ent: funent_t):<cloref1> string = let
    val fn_str = trans_cpp_fun_decl (ent)
    val ret = init + "\n" + fn_str + ";"
  in
    ret
  end

  val header = list0_fold_left (helper, "", fns)
in
  ostream_in (os, header)
end

extern fun trans_cpp_fun_body (
  narg: int, body: instrlst, ret: valprim): statements

extern fun trans_cpp_instrlst (body: instrlst): statements
extern fun trans_cpp_instr (instr: instr): statements

extern fun trans_cpp_valprim (vp: valprim): string
extern fun trans_cpp_valprimlst (vps: valprimlst): list0 string

fun trans_cpp_funlst_def (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val body = funent_get_body (ent)
    val ret = funent_get_ret (ent)
    val nam = funlab_get_name (fl)

    val fundef = trans_cpp_fun_decl (ent)

    val fundef = fundef + "\n" + scope_beg + "\n"
    val funbody = trans_cpp_fun_body (nargs, body, ret)
    val fundef = fundef + statements_to_string (funbody, 1)
    val fundef = fundef + scope_end + "\n\n"
  in
    init + fundef
  end

  val header = list0_fold_left (trans, "", fns)
  val () = ostream_in (os, header)
in
end

implement trans_cpp_fun_body (narg, body, ret) = let
  val stats = trans_cpp_instrlst (body)

  val ret_typ = ret.valprim_typ
  val ret_typ = trans_cpp_typ (ret_typ)

  val stats = list0_append<statement> (stats, 
              cons (STATplain ("return " (* (" + ret_typ + ")" *) + 
                trans_cpp_valprim (ret) + ";"), nil))
in
  stats
end

implement trans_cpp_valprim (vp) = let
  val node = vp.valprim_node
  val typ = vp.valprim_typ
  val typ_str = trans_cpp_typ (typ)
in
  case+ node of
  | VPenv (pos) => "(" + typ_str + ")env_get(" + 
        tmpvar_get_name (env_tmpvar) + ", " + tostring_int (pos) + ")"
  | VPbool (b) => tostring_bool (b)
  | VPclo (tmpvar, fl, vps) => tmpvar_get_name (tmpvar)
  | VPint (i) => tostring_int (i)
  | VPstr (str) => string_formalize (str)
  | VPtmp (tmpvar) => tmpvar_get_name (tmpvar)
  | VPtup (tmpvar, vps) => let
    // val () = printf ("trans_cpp_valprim -- VPtup\n", @())
    val ret = if list0_length (vps) = 0 then 
          "0" else tmpvar_get_name (tmpvar)
    // val () = printf ("trans_cpp_valprim10 -- VPtup\n", @())
  in
    ret
  end
end


implement trans_cpp_valprimlst (vps) =
  case+ vps of 
  | cons (vp, vps1) => cons (trans_cpp_valprim (vp), 
                             trans_cpp_valprimlst (vps1))
  | nil () => nil

implement trans_cpp_instrlst (body) = let
  fun loop (body: instrlst, accu: statements): statements =
    case+ body of
    | cons (instr, body1) => let
      // val () = printf ("trans_cpp_instrlst\n", @())
      val stats = trans_cpp_instr (instr)
      // val () = printf ("trans_cpp_instrlst10\n", @())
      val accu = list0_append (accu, stats)
    in
      loop (body1, accu)
    end
    | nil () => accu
in
  loop (body, nil)
end

extern fun trans_cpp_instr_call (ret: tmpvar, f: valprim, 
  args: valprimlst, ret_typ: t2yp): statements

extern fun trans_cpp_instr_cond (ret: tmpvar, typ: t2yp, vp: valprim, 
  brthen: instrlst, brelse: instrlst): statements
  
extern fun trans_cpp_instr_opr (ret: tmpvar, typ: t2yp, opr: opr, 
  args: valprimlst): statements

extern fun trans_cpp_instr_tup (ret: tmpvar, vps: valprimlst): statements

extern fun trans_cpp_instr_closure (
  ret: tmpvar, fl: funlab_t, vps: valprimlst): statements

extern fun trans_cpp_instr_proj (ret: tmpvar, typ: t2yp, vp: valprim, 
  pos: int): statements


implement trans_cpp_instr_opr (ret, typ, opr, args) = let
  val+ OPR sym = opr
  val vs = trans_cpp_valprimlst (args)
  val typ_str = trans_cpp_typ (typ)
  val stat = typ_str + " " + tmpvar_get_name (ret) + " = "
  val (opr_str, needret) = 
    (case+ 0 of
    | _ when sym = symbol_PLUS => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " + " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_MINUS => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " - " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_TIMES => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " * " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_SLASH => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " / " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_UMINUS => let
        val- s1 :: _ = vs in ("-1 * " + s1, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GT => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " > " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GTE => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " >= " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_LT => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " < " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_LTE => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " <= " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_EQ => let      
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " == " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_NEQ => let
        val- s1 :: s2 :: _ = vs
      in
        (s1 + " != " + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_PRINT => let
        val- s :: _ = vs
      in
        ("printf(\"%s\", " + s + ")", false)
      end // end of [_ when ...]
    | _ when sym = symbol_PRINT_INT => let
        val- i  :: _ = vs
      in
        ("printf(\"%d\", " + i + ")", false)
      end // end of [_ when ...]
    | _ => ETRACE_MSG_OPR ("trans_cpp_instr_opr unsupported operator\n", 
                      ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
      // end of [_]
    )

    val stat = (if needret then stat + opr_str + ";" 
                else stat + "0;" + opr_str + ";")
in
  cons (STATplain (stat), nil)
end  // end of [trans_cpp_instr_opr]

(*
extern fun trans_cpp_instr_tup (ret: tmpvar, vps: valprimlst): statements
*)
implement trans_cpp_instr_tup (ret, vps) = let
  val len = list0_length (vps)
  // val len_str = tostring_int (len)
  val nam = tmpvar_get_name (ret)
  val stat = STATplain (if len = 0 then "tuple " + nam + " = 0;"
              else "tuple " + nam + " = tuple_create();")

  val elements = trans_cpp_valprimlst (vps)

  fun fill_tup (nam: string, elements: list0 string, pos: int): statements =
    case+ elements of
    | cons (ele, elements1) => let
      val stat = STATplain ("tuple_add(" + nam + ", (void*)" + ele + ");")
    in
      cons (stat, fill_tup (nam, elements1, pos + 1))
    end
    | nil () => nil

  val stats_fill = fill_tup (nam, elements, 0)
in
  cons (stat, stats_fill)
end

implement trans_cpp_instr_cond (ret, typ, vp, brthen, brelse) = let
  // val () = printf ("trans_cpp_instr_cond\n", @())
  val ret_str = tmpvar_get_name (ret)
  val ret_typ = trans_cpp_typ (typ)
  val stat_dec = STATplain (ret_typ + " " + ret_str + ";")

  val v_str = trans_cpp_valprim (vp)
  val stat_if = STATplain ("if (" + v_str + ")")
  
  // val () = printf ("trans_cpp_instr_cond10\n", @())
  val stats_then = trans_cpp_instrlst (brthen)
  // val () = printf ("trans_cpp_instr_cond20\n", @())
  val stats_else = trans_cpp_instrlst (brelse)
  // val () = printf ("trans_cpp_instr_cond30\n", @())
in
  stat_dec :: stat_if :: STATplain (scope_beg) 
    :: STATcomp (stats_then) :: STATplain (scope_end) 
    :: STATplain ("else") :: STATplain (scope_beg) :: STATcomp (stats_else) 
    :: STATplain (scope_end) :: nil
end

implement trans_cpp_instr_proj (ret, typ, vp, pos) = let
  val ret_str = tmpvar_get_name (ret)
  val ret_typ = trans_cpp_typ (typ)
  val v_str = trans_cpp_valprim (vp)

  val stats = STATplain (ret_typ + " " + ret_str + " = " + 
              "(" + ret_typ + ")" +
              "tuple_get(" + v_str + ", " + tostring_int (pos) + ");")
in
  stats :: nil
end

(* extern fun trans_cpp_instr_closure (
  ret: tmpvar, fl: funlab_t, vps: valprimlst): statements *)
implement trans_cpp_instr_closure (ret, fl, vps) = let
  val ret_str = tmpvar_get_name (ret)
  val stat_c_clo = "closure " + ret_str + " = closure_create();"

  val f_nam = funlab_get_name (fl)
  val stat_add_fun = "closure_put_fun(" + ret_str + ", (void*)" + f_nam + ");"

  fun loop (clo_nam: string, vps: valprimlst,
    init: statements): statements =
    case+ vps of
    | cons (vp, vps1) => let
      val arg = trans_cpp_valprim (vp)
      val stat = "closure_add_env(" + clo_nam + ", (void*)" + arg + ");"
      val init' = cons (STATplain stat, init)
    in
      loop (clo_nam, vps1, init')
    end
    | nil () => init

  val stats = cons (STATplain stat_c_clo, nil)
  val stats = cons (STATplain stat_add_fun, stats)
  val stats = loop (ret_str, vps, stats)
  val stats = list0_reverse (stats)
in
  stats
end

(*
extern fun trans_cpp_instr_call (ret: tmpvar, f: valprim, 
  args: valprimlst, ret_typ: t2yp): statements
*)
implement trans_cpp_instr_call (ret, f, args, ret_typ) = let
  val ret_str = tmpvar_get_name (ret)

  // name of the closure
  val f_nam = trans_cpp_valprim (f)

  // build the function type  // no need anymore
  // / val f_typ = f.valprim_typ
  // / val- T2YPclo (_, _, ret_typ1) = f_typ

  val args_typ_str = trans_cpp_valprimlst_typ (args, 1)
  val ret_typ_str = trans_cpp_typ (ret_typ)

  // We have two ways to figure out the type of the function
  // From f_typ or args and ret_typ
  // They maybe lead to different types.
  // e.g.
  // list_cons: real type (derived from f_typ) is 
  // (list ( * )(env, any, list))
  // list_cons: printed type (derived from args and ret_typ) is 
  // (list ( * )(env, int, list))

  // list_head: real type (derived from f_typ) is 
  // (any ( * )(env, list))
  // list_head: printed type (derived from args and ret_typ) is 
  // (int ( * )(env, list))
  val clo_typ_str = "(" + ret_typ_str + " (*)(env" + args_typ_str + "))"

  val args_strlst = trans_cpp_valprimlst (args)

  fun loop (init: string, args: list0 string, i: int): string =
    case+ args of
    | cons (arg, args1) => loop (init + (if i > 0 then ", " else "") + arg, args1, i + 1)
    | nil () => init

  val args_str = "(closure_get_env(" + f_nam + ")" + loop ("", args_strlst, 1) + ")"

  val stats = STATplain (ret_typ_str + " " + ret_str + " = " + 
             "(*" + clo_typ_str + "closure_get_fun(" + f_nam + "))" + args_str + ";") :: nil
in
  stats
end

implement trans_cpp_instr (instr) =
  case+ instr.instr_node of
  | INSTRcall (ret, f, args, ret_typ, _) =>
    trans_cpp_instr_call (ret, f, args, ret_typ)
  | INSTRcond (ret, typ, v, brthen, brelse) =>
    trans_cpp_instr_cond (ret, typ, v, brthen, brelse)
  | INSTRmove_val (tmpv, vp) => let
    // val () = printf ("trans_cpp_instr -- INSTRmove_val\n", @())
    val nam = tmpvar_get_name (tmpv)
    // val () = printf ("trans_cpp_instr -- INSTRmove_val10\n", @())
    val vpnam = trans_cpp_valprim (vp)
    // val () = printf ("trans_cpp_instr -- INSTRmove_val20\n", @())
    val stat = STATplain (nam + " = " + vpnam + ";")
    // val () = printf ("trans_cpp_instr -- INSTRmove_val30\n", @())
  in
    cons (stat, nil)
  end
  | INSTRopr (ret, t2yp, opr, vps) => let
    // val () = printf ("opr\n", @())
  in
    trans_cpp_instr_opr (ret, t2yp, opr, vps)
  end
  | INSTRtup (ret, vps) =>
    trans_cpp_instr_tup (ret, vps)
  | INSTRclosure (ret, fl, vps) =>
    trans_cpp_instr_closure (ret, fl, vps)
  | INSTRproj (ret, typ, v, pos) => let
    // val () = printf ("proj\n", @())
  in
    trans_cpp_instr_proj (ret, typ, v, pos)
  end

implement trans_cpp (instrs, fns) = let
  var os = ostream_new ()

  val () = ostream_in (os, header)
  // val () = ostream_in (os, header_ftyp)

  val main_ent = funent_make (mainlab, 1, nil, instrs, 
    make_valprim (VPint 0, T2YPint) (*just a dummy return value*), nil)
  val fns = list0_append (fns, cons (main_ent, nil))

  val () = trans_cpp_funlst_decl (fns, os)
  val () = ostream_in (os, "\n\n")
  val () = trans_cpp_funlst_def (fns, os)
 
   val body_stats = STATplain (initialization_str) :: STATplain ("\n\n")
       :: STATplain (funlab_get_name (mainlab) + "(0);")
       :: STATplain ("return 0;") :: nil
  
   val main_stats = STATplain ("int main (int argc, char *argv[])")
       :: STATplain (scope_beg) :: STATcomp (body_stats)
       :: STATplain (scope_end) :: nil
   
   val mainstr = statements_to_string (main_stats, 0)
 
   val () = ostream_in (os, mainstr)
in
  os
end






