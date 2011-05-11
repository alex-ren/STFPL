(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload
Posloc = "contrib/parcomb/SATS/posloc.sats"

(* ****** ****** *)

staload Absyn = "absyn.sats"
staload Symbol = "symbol.sats"

(* ****** ****** *)

staload
Trans1 = "trans1.sats"
typedef e1xp = $Trans1.e1xp

(* ****** ****** *)

(* desc: type for temporary variable *)
abstype tmpvar_t
typedef tmpvar = tmpvar_t

fun tmpvar_get_name (v: tmpvar): string

fun fprint_tmpvar (out: FILEref, x: tmpvar): void
overload fprint with fprint_tmpvar
fun print_tmpvar (x: tmpvar): void
overload print with print_tmpvar

symintr tmpvar_new
fun tmpvar_new_anon (): tmpvar_t
fun tmpvar_new_v1ar (v: $Trans1.v1ar): tmpvar_t
fun tmpvar_new_string (str: string): tmpvar_t
fun tmpvar_new_string_name (str: string): tmpvar_t  // no counter no. added
overload tmpvar_new with tmpvar_new_anon
overload tmpvar_new with tmpvar_new_v1ar
overload tmpvar_new with tmpvar_new_string

(* ****** ****** *)

(* desc: type for function label *)
abstype funlab_t
typedef funlab = funlab_t

// for use of creating library function
fun funlab_allocate (nam: $Symbol.symbol_t): funlab_t
fun funlab_equal (lab1: funlab, lab2: funlab): bool
overload = with funlab_equal

fun fprint_funlab (out: FILEref, x: funlab): void
overload fprint with fprint_funlab
fun print_funlab (x: funlab): void
overload print with print_funlab

(* ****** ****** *)

(* desc: type for function entry *)
abstype funent_t
typedef funent = funent_t

fun fprint_funent (out: FILEref, x: funent): void
overload fprint with fprint_funent
fun print_funent (x: funent): void
overload print with print_funent

(* ****** ****** *)

(* ****** ****** *)
datatype t2yp =
  | T2YPint
  | T2YPbool
  | T2YPstr
  | T2YPenv
  | T2YPlist of t2yp
  | T2YPvar
  // nargs, args (including the closure as the first parameter), ret
  | T2YPclo of (int, t2yplst, t2yp)  
  | T2YPtup of (t2yplst)
where t2yplst = list0 (t2yp)

(* by Zhiqiang Ren ***** *)
(* valprim is either a literal value or
 * a tag for a temporary variable
 *)
datatype valprim_node = // primitive values
  | VPenv of int // closure parameter: the ith parameter
  | VPbool of bool // boolean constants
  | VPclo of (tmpvar, funlab, valprimlst)
  | VPint of int // integer constants
  | VPstr of string // string constants
  | VPtmp of tmpvar // temporaries
  | VPtup of (tmpvar, valprimlst) // (name of tuples, tuples)

where valprim = '{
  valprim_node = valprim_node,
  valprim_typ = t2yp
}

(*
** please extend the datatype if you need to
*)
and valprimlst = list0 (valprim)
// end of [where]

fun make_valprim (node: valprim_node, typ: t2yp): valprim

fun fprint_valprim (out: FILEref, x: valprim): void
overload fprint with fprint_valprim

fun fprint_valprimlst (out: FILEref, xs: valprimlst): void
overload fprint with fprint_valprimlst

(* ****** ****** *)

datatype instr_node =
  | INSTRcall of (tmpvar, valprim, valprimlst, 
                  t2yp(*return type*), bool(*is tail call*)) // fun call
  // conditional  // no return val, so no tmpvar
  | INSTRcond of (tmpvar, t2yp, valprim, instrlst, instrlst) 
  | INSTRmove_val of (tmpvar(*x*), valprim(*v*)) // x := v
  // primtive operator
  | INSTRopr of (tmpvar, t2yp(*ret typ*), $Absyn.opr, valprimlst)
  // no instruction for empty tuple
  | INSTRtup of (tmpvar, valprimlst) // create tuple  
  // create closures
  | INSTRclosure of (tmpvar, funlab, valprimlst)  
  | INSTRproj of (tmpvar, t2yp, valprim, int) // projection

where instr = '{
  instr_loc= $Posloc.location_t, instr_node = instr_node
} // end of [instr]

and instrlst = list0 (instr)

fun fprint_instr (out: FILEref, x: instr): void
overload fprint with fprint_instr
fun fprint_instrlst (out: FILEref, xs: instrlst): void
overload fprint with fprint_instrlst

fun print_instr (x: instr): void
overload print with print_instr

(* ****** ****** *)

fun trans2_exp (e: e1xp): (instrlst, list0 funent_t)

fun funent_get_lab (ent: funent): funlab
fun funent_get_narg (ent: funent): int
fun funent_get_args (ent: funent): valprimlst
fun funent_get_body (ent: funent): instrlst
fun funent_get_ret (ent: funent): valprim

fun funent_add (fl: funlab, ent: funent): void
fun funent_lookup (fl: funlab): funent
fun funent_getall (): list0 funent

fun funlab_get_name (fl: funlab): string
fun funlab_get_valprim (vp: valprim): funlab

val mainlab: funlab

fun funent_make (
  fl: funlab, nargs: int, args: valprimlst, 
  body: instrlst, ret: valprim, env: valprimlst): funent

fun trans2_typ (t1yp: $Trans1.t1yp): t2yp

fun fprint_valprim (out: FILEref, vp: valprim): void
fun fprint_valprimlst (out: FILEref, vp: valprimlst): void
fun fprint_instr (out: FILEref, ins: instr): void
fun fprint_instrlst (out: FILEref, inslst: instrlst): void
fun fprint_funlst (out: FILEref, fns: list0 funent_t): void
(* ****** ****** *)

(* end of [trans2.sats] *)




