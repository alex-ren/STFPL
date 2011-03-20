
(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans2.sats"
staload "trans_cpp.sats"
staload "error.sats"
// staload "symbol.sats"

// staload _(*anon*) = "symbol.dats"

// typedef opr = $Absyn.opr
// typedef loc = $Posloc.location_t
// typedef symbol = $Symbol.symbol_t
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
// staload _(*anon*) = "prelude/DATS/reference.dats" 
// 
// #define :: list0_cons
// #define cons list0_cons
// #define nil list0_nil
// 
// #define Some0 option0_some
// #define None0 option0_none
// 
// val valprim_void = VPtup (list0_nil)
// 
// fun instr_add (
//   res: &instrlst, x: instr
// ) : void = res := list0_cons (x, res)
// 
// fun instr_make (loc: loc, ins_node: instr_node): instr = '{
//   instr_loc = loc, instr_node = ins_node
// }  // end of [instr_make]
// 
// symintr tmpvar_new
// extern fun tmpvar_new_anon (): tmpvar_t
// extern fun tmpvar_new_name (v: v1ar): tmpvar_t
// overload tmpvar_new with tmpvar_new_anon
instrlst

local
  assume ostream_t = string
in
  implement ostream_new () = ""

  implement ostream_in (os, s) = let
    val () = os := string0_append(os, s)
  in end

  implement print_ostream (os) = print os
end  // end of [local]

abstype statements_t
typedef statements = statements_t

extern fun statements_to_string (stats: statements, level: int): string

extern fun trans_cpp_instrs (instrs: instrlst): statements
extern fun trans_cpp_fundef (fundef: funent): statements

val arg_pad = "__args": string
val indent_pad = "  ": string
val scope_beg = "\n{\n": string
val scope_end = "\n}\n": string

local
  assume statements_t = list0 string
in
  implement statements_to_string (stats, level) = let
    fun level_string (i: int): string =
      if i <= 0 then "" else indent_pad + level_string (i - 1)

    val indent_pad = level_string (level)
    fun helper (init: string, x: string):<cloref1> string = 
      init + indent_pad + x + "\n"
  in
    list0_fold_left (helper, "", stats)
  end  // end of [statements_to_string]

end  // end of [local]
      

fun trans_cpp_fun_decl (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val nam = funlab_get_name (fl)
    val stat = "\nvoid * " + nam + "("
    val stat = stat + (if nargs = 0 then ");\n" else "void *);\n")
  in
    init + stat
  end

  val header = list0_fold_left (trans, "", fns)
in
  ostream_in (os, header)
end

fun trans_cpp_fun_def (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val nam = funlab_get_name (fl)
    val fundef = "\nvoid * " + nam + "("
    val fundef = fundef + (if nargs = 0 then ")" else ("void * " + arg_pad + ")"))
    val fundef = fundef + scope_beg
    val fundef = 
  in
    init + stat
  end

  val header = list0_fold_left (trans, "", fns)
  val () = ostream_in (os, header)
in
end

implement trans_cpp (instrs, fns) = let
  var os = ostream_new ()
  val () = trans_cpp_fun_decl (fns, os)
  val () = trans_cpp_fun_def (fns, os)
in
  os
end




