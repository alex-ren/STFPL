(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload
Posloc = "contrib/parcomb/SATS/posloc.sats"

(* ****** ****** *)

staload Absyn = "absyn.sats"

(* ****** ****** *)

staload
Trans1 = "trans1.sats"
typedef e1xp = $Trans1.e1xp

(* ****** ****** *)

(* desc: type for temporary variable *)
abstype tmpvar_t
typedef tmpvar = tmpvar_t

fun fprint_tmpvar (out: FILEref, x: tmpvar): void
overload fprint with fprint_tmpvar
fun print_tmpvar (x: tmpvar): void
overload print with print_tmpvar

(* ****** ****** *)

(* desc: type for function label *)
abstype funlab_t
typedef funlab = funlab_t

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

(* by Zhiqiang Ren ***** *)
(* valprim is either a literal value or
 * a tag for a temporary variable
 *)
datatype valprim = // primitive values
  | VParg of int // function arguments: the ith argument
  | VPbool of bool // boolean constants
  | VPfun of funlab // function labels
  | VPint of int // integer constants
  | VPstr of string // string constants
  | VPtmp of tmpvar // tmporaries
  | VPtup of valprimlst // tuples 

(*
** please extend the datatype if you need to
*)
where valprimlst = list0 (valprim)

fun fprint_valprim (out: FILEref, x: valprim): void
overload fprint with fprint_valprim

fun fprint_valprimlst (out: FILEref, xs: valprimlst): void
overload fprint with fprint_valprimlst

(* ****** ****** *)

datatype instr_node =
  | INSTRcall of (tmpvar, valprim, valprimlst) // fun call
  | INSTRcond of (valprim, instrlst, instrlst) // conditional
  | INSTRmove_val of (tmpvar(*x*), valprim(*v*)) // x := v
  | INSTRopr of (tmpvar, $Absyn.opr, valprimlst) // primtive operator

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
fun funent_get_body (ent: funent): instrlst
fun funent_get_ret (ent: funent): valprim

fun funlab_get_name (fl: funlab): string


(* ****** ****** *)

(* end of [trans2.sats] *)




