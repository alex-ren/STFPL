
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

// staload _(*anon*) = "symbol.dats"

// typedef opr = $Absyn.opr

// typedef loc = $Posloc.location_t
// typedef symbol = $Symbol.symbol_t
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
// staload _(*anon*) = "prelude/DATS/reference.dats" 
// 
#define :: list0_cons
#define cons list0_cons
#define nil list0_nil


(* header for the generated cpp files *)
val header = "#include <cstdio>\n\n"
val ftyp_0 = "__ftype0": string  // nullary function type
val ftyp_1 = "__ftype1": string  // multi args function type
val header_ftyp = "typedef void * (*" + ftyp_0 + ")();\n"
val header_ftyp = header_ftyp + "typedef void * (*" + ftyp_1 + ")(void **);\n"

(* string functions *)
extern
fun string_implode (cs: list0 char): string = "atspre_string_implode"
extern
fun string_explode (str: string): list0 char = "atspre_string_explode"

fun string_formalize (str: string): string = let
  val cs = string_explode (str)
  fun loop (cs: list0 char, accu: list0 char): list0 char =
    case+ cs of
    | cons (c, cs1) => if c = '\n' then loop (cs1, 'n' :: '\\' :: accu)
                       else loop (cs1, c :: accu)
    | nil () => accu

  val cs = loop (cs, nil)
  val cs = list0_reverse (cs)
in
  string_implode (cs)
end




// #define Some0 option0_some
// #define None0 option0_none

local
  assume ostream_t = string
in
  implement ostream_new () = ""

  implement ostream_in (os, s) = let
    val () = os := string0_append(os, s)
  in end

  implement print_ostream (os) = print os
end  // end of [local]

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

fun trans_cpp_fun_decl (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val nam = funlab_get_name (fl)
    val stat = "\nvoid * " + nam + "("
    val stat = stat + (if nargs = 0 then ");\n" 
                       else if nargs = 1 then "void *);\n"
                       else "void **);\n")
  in
    init + stat
  end

  val header = list0_fold_left (trans, "", fns)
in
  ostream_in (os, header)
end

extern fun trans_cpp_fun_body (narg: int, body: instrlst, ret: valprim): statements

extern fun trans_cpp_instrlst (body: instrlst, isunary: bool): statements
extern fun trans_cpp_instr (instr: instr, isunary: bool): statements

extern fun trans_cpp_valprim (vp: valprim, isunary: bool): string
extern fun trans_cpp_valprimlst (vps: valprimlst, isunary: bool): list0 string

fun trans_cpp_fun_def (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val body = funent_get_body (ent)
    val ret = funent_get_ret (ent)
    val nam = funlab_get_name (fl)
    val fundef = "\nvoid * " + nam + "("
    val fundef = fundef + (if nargs = 0 then ")" 
                           else if nargs = 1 then ("void * " + arg_pad + ")")
                           else ("void ** " + arg_pad + ")"))
    val fundef = fundef + "\n" + scope_beg + "\n"
    val funbody = trans_cpp_fun_body (nargs, body, ret)
    val fundef = fundef + statements_to_string (funbody, 1)
    val fundef = fundef + scope_end + "\n"
  in
    init + fundef
  end

  val header = list0_fold_left (trans, "", fns)
  val () = ostream_in (os, header)
in
end

implement trans_cpp_fun_body (narg, body, ret) = let
  val isunary = (narg = 1)
  val stats = trans_cpp_instrlst (body, isunary)
  val stats = list0_append<statement> (stats, 
              cons (STATplain ("return (void *)" + 
                trans_cpp_valprim (ret, isunary) + ";"), nil))
in
  stats
end

implement trans_cpp_valprim (vp, isunary) = 
  case+ vp of
  | VParg (n) => if isunary then arg_pad else "" + arg_pad + "" + "[" + tostring_int (n) + "]"
  | VPbool (b) => tostring_bool (b)
  | VPfun (fl) => funlab_get_name (fl)
  | VPint (i) => tostring_int (i)
  | VPstr (str) => string_formalize (str)
  | VPtmp (tmpvar) => tmpvar_get_name (tmpvar)
  | VPtup (tmpvar, vps) => let
    // val () = printf ("trans_cpp_valprim -- VPtup\n", @())
    val ret = if list0_length (vps) = 0 then "NULL" else tmpvar_get_name (tmpvar)
    // val () = printf ("trans_cpp_valprim10 -- VPtup\n", @())
  in
    ret
  end

implement trans_cpp_valprimlst (vps, isunary) =
  case+ vps of 
  | cons (vp, vps1) => cons (trans_cpp_valprim (vp, isunary), 
                             trans_cpp_valprimlst (vps1, isunary))
  | nil () => nil

implement trans_cpp_instrlst (body, isunary) = let
  fun loop (body: instrlst, isunary: bool, 
    accu: statements): statements =
    case+ body of
    | cons (instr, body1) => let
      // val () = printf ("trans_cpp_instrlst\n", @())
      val stats = trans_cpp_instr (instr, isunary)
      // val () = printf ("trans_cpp_instrlst10\n", @())
      val accu = list0_append (accu, stats)
    in
      loop (body1, isunary, accu)
    end
    | nil () => accu
in
  loop (body, isunary, nil)
end

extern fun trans_cpp_instr_opr (ret: tmpvar, opr: opr, 
  args: valprimlst, isunary: bool): statements

extern fun trans_cpp_instr_tup (ret: tmpvar, vps: valprimlst, 
  isunary: bool): statements

extern fun trans_cpp_instr_cond (ret: tmpvar, vp: valprim, 
  brthen: instrlst, brelse: instrlst, isunary: bool): statements
  
extern fun trans_cpp_instr_proj (ret: tmpvar, vp: valprim, 
  pos: int, isunary: bool): statements

extern fun trans_cpp_instr_call (ret: tmpvar, f: valprim, 
  args: valprimlst, iswrapper: bool, isunary: bool): statements

implement trans_cpp_instr_opr (ret, opr, args, isunary) = let
  val+ OPR sym = opr
  val vs = trans_cpp_valprimlst (args, isunary)
  val stat = "void * " + tmpvar_get_name (ret) + " = "
  val (opr_str, needret) = 
    (case+ 0 of
    | _ when sym = symbol_PLUS => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " + " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_MINUS => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " - " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_TIMES => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " * " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_SLASH => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " / " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_UMINUS => let
        val- s1 :: _ = vs in ("-1 * (long)" + s1, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GT => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " > " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GTE => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " >= " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_LT => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " < " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_LTE => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " <= " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_EQ => let      
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " == " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_NEQ => let
        val- s1 :: s2 :: _ = vs
      in
        ("(long)" + s1 + " != " + "(long)" + s2, true)
      end // end of [_ when ...]
    | _ when sym = symbol_PRINT => let
        val- s :: _ = vs
      in
        ("printf(\"%s\", \"" + s + "\")", false) 
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

    val stat = (if needret then stat + "(void *) (" + opr_str + ");" 
                else stat + "NULL;" + opr_str + ";")
in
  cons (STATplain (stat), nil)
end  // end of [trans_cpp_instr_opr]

(*
extern fun trans_cpp_instr_tup (ret: tmpvar, vps: valprimlst, 
  isunary: bool): statements
*)
implement trans_cpp_instr_tup (ret, vps, isunary) = let
  val len = list0_length (vps)
  val len_str = tostring_int (len)
  val nam = tmpvar_get_name (ret)
  val stat = STATplain (if len = 0 then "void * " + nam + " = NULL;"
              else "void * " + nam + " = (void *) (new void * [" + len_str + "] ());")

  val elements = trans_cpp_valprimlst (vps, isunary)

  fun fill_tup (nam: string, elements: list0 string, pos: int): statements =
    case+ elements of
    | cons (ele, elements1) => let
      val stat = STATplain ("((void **)" + nam + ")[" + tostring_int (pos) + "] = (void *)" + ele + ";")
    in
      cons (stat, fill_tup (nam, elements1, pos + 1))
    end
    | nil () => nil

  val stats_fill = fill_tup (nam, elements, 0)
in
  cons (stat, stats_fill)
end

implement trans_cpp_instr_cond (ret, vp, brthen, brelse, isunary) = let
  // val () = printf ("trans_cpp_instr_cond\n", @())
  val ret_str = tmpvar_get_name (ret)
  val stat_dec = STATplain ("void * " + ret_str + " = NULL;")

  val v_str = trans_cpp_valprim (vp, isunary)
  val stat_if = STATplain ("if (" + v_str + ")")
  
  // val () = printf ("trans_cpp_instr_cond10\n", @())
  val stats_then = trans_cpp_instrlst (brthen, isunary)
  // val () = printf ("trans_cpp_instr_cond20\n", @())
  val stats_else = trans_cpp_instrlst (brelse, isunary)
  // val () = printf ("trans_cpp_instr_cond30\n", @())
in
  stat_dec :: stat_if :: STATplain (scope_beg) 
    :: STATcomp (stats_then) :: STATplain (scope_end) 
    :: STATplain ("else") :: STATplain (scope_beg) :: STATcomp (stats_else) 
    :: STATplain (scope_end) :: nil
end

implement trans_cpp_instr_proj (ret, vp, pos, isunary) = let
  val ret_str = tmpvar_get_name (ret)
  val v_str = trans_cpp_valprim (vp, isunary)

  val stats = STATplain ("void * " + ret_str + " = " + "((void **)" + v_str + ")[" +
      tostring_int (pos) + "];")
in
  stats :: nil
end

extern fun trans_cpp_instr_tup (ret: tmpvar, vps: valprimlst, 
  isunary: bool): statements

(*
extern fun trans_cpp_instr_call (ret: tmpvar, f: valprim, 
  args: valprimlst, iswrapper: bool, isunary: bool): statements
*)
implement trans_cpp_instr_call (ret, f, args, iswrapper, isunary) = let
  val ret_str = tmpvar_get_name (ret)
  val f_str = trans_cpp_valprim (f, isunary)
  val nargs = list0_length (args)

  // type convertion of function
  val typfun = if (nargs = 0) then "(" + ftyp_0 + ")"
               else "(" + ftyp_1 + ")"
in
  if iswrapper = false then let
    (* use the ret to hold the args, later it will be used to hold the result as well *)
    val args_stats = trans_cpp_instr_tup (ret, args, isunary)

    val para_str = if (nargs = 0) then "()"
                   else ("((void **)" + ret_str + ")"): string

    val stats = STATplain (ret_str + " = (" + typfun +
        f_str + ")" + para_str + ";") :: nil

    val stats = list0_append (args_stats, stats)
  in
    stats
  end else let
    val- cons (v, nil ()) = args  // denifintely not tuple
    val v_str = trans_cpp_valprim (v, isunary)

    val para_str = if (nargs = 0) then "()"
                   else ("((void **)" + v_str + ")"): string

    val stats = STATplain ("void * " + ret_str + " = (" + typfun +
        f_str + ")" + para_str + ";") :: nil
  in
    stats
  end
end

implement trans_cpp_instr (instr, isunary) =
  case+ instr.instr_node of
  | INSTRcall (ret, f, args, iswrapper) =>
    trans_cpp_instr_call (ret, f, args, iswrapper, isunary)
  | INSTRcond (ret, v, brthen, brelse) =>
    trans_cpp_instr_cond (ret, v, brthen, brelse, isunary)
  | INSTRmove_val (tmpv, vp) => let
    // val () = printf ("trans_cpp_instr -- INSTRmove_val\n", @())
    val nam = tmpvar_get_name (tmpv)
    // val () = printf ("trans_cpp_instr -- INSTRmove_val10\n", @())
    val vpnam = trans_cpp_valprim (vp, isunary)
    // val () = printf ("trans_cpp_instr -- INSTRmove_val20\n", @())
    val stat = STATplain (nam + " = (void *)" + vpnam + ";")
    // val () = printf ("trans_cpp_instr -- INSTRmove_val30\n", @())
  in
    cons (stat, nil)
  end
  | INSTRopr (ret, opr, vps) => let
    // val () = printf ("opr\n", @())
  in
    trans_cpp_instr_opr (ret, opr, vps, isunary)
  end
  | INSTRtup (ret, vps) =>
    trans_cpp_instr_tup (ret, vps, isunary)
  | INSTRproj (ret, v, pos) => let
    // val () = printf ("proj\n", @())
  in
    trans_cpp_instr_proj (ret, v, pos, isunary)
  end

implement trans_cpp (instrs, fns) = let
  var os = ostream_new ()

  val () = ostream_in (os, header)
  val () = ostream_in (os, header_ftyp)

  val main_ent = funent_make_label (mainlab, 0, instrs, 
    VPstr "NULL" (*just a dummy return value*))
  val fns = list0_append (fns, cons (main_ent, nil))

  val () = trans_cpp_fun_decl (fns, os)
  val () = trans_cpp_fun_def (fns, os)

  val body_stats = STATplain (funlab_get_name (mainlab) + "();")
      :: STATplain ("return 0;") :: nil
 
  val main_stats = STATplain ("\nint main (int argc, char *argv)")
      :: STATplain (scope_beg) :: STATcomp (body_stats)
      :: STATplain (scope_end) :: nil
  
  val mainstr = statements_to_string (main_stats, 0)

  val () = ostream_in (os, mainstr)
in
  os
end





