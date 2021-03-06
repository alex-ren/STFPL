(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload Symbol = "symbol.sats"
staload Posloc = "contrib/parcomb/SATS/posloc.sats"
(* ****** ****** *)

staload Absyn = "absyn.sats"

(* ****** ****** *)
abstype t1Var

datatype t1yp =
  | T1YPbase of $Symbol.symbol_t
  // by rzq: we still have the info
  // about how many args the function
  // takes (may be n args or 1 arg which
  // is a tuple of n elements)
  | T1YPfun of (ref int(*args*), t1yp, t1yp)
  | T1YPtup of t1yplst
  | T1YPtup_vl of ref t1yplst
  | T1YPvar of t1Var
  | T1YPdummy of ()
  | T1YPlist of (t1Var)
// end of [t1yp]

where t1yplst = list0 (t1yp)
  and t1ypopt = option0 (t1yp)
  and t1ypref = ref (t1yp)

fun t1Var_new (): t1Var
fun t1Var_get_nam (X: t1Var): int
fun t1Var_get_typ (X: t1Var): t1yp
fun t1Var_set_typ (X: t1Var, t: t1yp): void

val t1yp_bool: t1yp
val t1yp_int: t1yp
val t1yp_string: t1yp
val t1yp_unit: t1yp

fun fprint_t1yp (out: FILEref, t: t1yp): void 
fun fprint_t1yplst (out: FILEref, t: t1yplst): void 

fun tostring_t1yp (t: t1yp): string
fun tostring_t1yplst (t: t1yplst): string

fun print_t1yp (t: t1yp): void 
fun prerr_t1yp (t: t1yp): void 

overload print with print_t1yp
overload prerr with prerr_t1yp
fun t1yp_normalize (t: t1yp): t1yp

(* ****** ****** *)
abstype valprim_t (* declared in [trans2.sats] *)

datatype e1xp_node =
  | E1XPann of (e1xp, t1yp)
  | E1XPapp of (e1xp, e1xp)
  | E1XPbool of bool
  | E1XPfix of (v1ar, v1arlst, e1xp, ref v1arlst(* for closure *))
  | E1XPif of (e1xp, e1xp, e1xpopt)
  | E1XPint of int
  | E1XPlam of (v1arlst, e1xp, ref v1arlst(* for closure *))
  | E1XPlet of (d1eclst, e1xp)
  | E1XPopr of ($Absyn.opr, e1xplst)
  | E1XPproj of (e1xp, int)
  | E1XPstr of string
  | E1XPtup of e1xplst
  | E1XPvar of v1ar
//  | E1XPfixclo of (v1ar, v1arlst, e1xp, v1arlst) (* for closure stage *)
//  | E1XPlamclo of (v1arlst, e1xp, v1arlst) (* for closure stage *)

and d1ec_node =
  | D1ECval of (bool(*isrec*), v1aldeclst)
// end of [d1ec_node]

where e1xp = '{
  e1xp_loc= $Posloc.location_t
, e1xp_node= e1xp_node
, e1xp_typ= t1yp
// , e1xp_esc=ref ($Symbol.symlst)  // todo to remove
} // end of [e1xp] 

and e1xplst = list0 (e1xp)
and e1xpopt = option0 (e1xp)

// two purpose: 1. as functoin args; 2. as let declarations
and v1ar = '{  
  v1ar_loc= $Posloc.location_t, 
  v1ar_nam= $Symbol.symbol_t, 
  v1ar_typ= t1yp, 
  v1ar_def= ref (e1xpopt),
  v1ar_val= ref (option0 (valprim_t))
} // end of [v1ar]
and v1arlst = list0 (v1ar)

and d1ec = '{
  d1ec_loc= $Posloc.location_t, d1ec_node= d1ec_node
}
and d1eclst = list0 (d1ec)

and v1aldec = '{
  v1aldec_loc= $Posloc.location_t
, v1aldec_var= v1ar
, v1aldec_def= e1xp
}
and v1aldeclst = list0 (v1aldec)
// end of [where]

(* test the node is a first level function *)
fun e0xp_node_is_fun (e_node: $Absyn.e0xp_node): option0 t1yp

(* test the node is a first level function *)
fun e1xp_node_is_fun (e_node: e1xp_node): bool

fun e1xp_node_fun_get_env (e_node: e1xp_node): option0 v1arlst

(* ****** ****** *)


fun fprint_d1eclst (out: FILEref, _: d1eclst): void
fun fprint_d1ec (out: FILEref, _: d1ec): void
fun fprint_v1aldeclst (out: FILEref, _: v1aldeclst): void
fun fprint_v1aldec (out: FILEref, _: v1aldec): void

fun fprint_e1xp (out: FILEref, _: e1xp): void
fun fprint_e1xplst (out: FILEref, _: e1xplst): void

fun prerr_e1xp (e: e1xp): void
fun print_e1xp (e: e1xp): void

(* ****** ****** *)

fun v1ar_make (_: $Posloc.location_t, _: $Symbol.symbol_t, _: t1yp): v1ar

fun eq_v1ar_v1ar
  (x1: v1ar, x2: v1ar): bool = "eq_v1ar_v1ar"
overload = with eq_v1ar_v1ar

fun v1ar_set_def
  (x: v1ar, def: e1xpopt): void = "v1ar_set_def"
// end of [v1ar_set_def]

(* ****** ****** *)

fun e1xp_make (loc: $Posloc.location_t, node: e1xp_node, t1yp: t1yp): e1xp
fun e1xp_make_ann (_: $Posloc.location_t, e: e1xp, t: t1yp): e1xp
fun e1xp_make_app (_: $Posloc.location_t, e1: e1xp, e2: e1xp, t: t1yp): e1xp
fun e1xp_make_bool (_: $Posloc.location_t, b: bool): e1xp
fun e1xp_make_fix (_: $Posloc.location_t, f: v1ar, xs: v1arlst, body: e1xp, t: t1yp): e1xp
fun e1xp_make_if (_: $Posloc.location_t, e1: e1xp, e2: e1xp, oe3: e1xpopt, t: t1yp): e1xp
fun e1xp_make_int (_: $Posloc.location_t, i: int): e1xp
fun e1xp_make_lam (_: $Posloc.location_t, xs: v1arlst, body: e1xp, t: t1yp): e1xp
fun e1xp_make_let (_: $Posloc.location_t, decs: d1eclst, body: e1xp, t: t1yp): e1xp
fun e1xp_make_opr (_: $Posloc.location_t, opr: $Absyn.opr, es: e1xplst, t: t1yp): e1xp
fun e1xp_make_proj (_: $Posloc.location_t, e: e1xp, i: int, t: t1yp): e1xp
fun e1xp_make_str (_: $Posloc.location_t, s: string): e1xp
fun e1xp_make_tup (_: $Posloc.location_t, es: e1xplst, t: t1yp): e1xp
fun e1xp_make_var (_: $Posloc.location_t, x: v1ar): e1xp

fun v1aldec_make (_: $Posloc.location_t, x: v1ar, def: e1xp): v1aldec
fun d1ec_make_val (_: $Posloc.location_t, isrec: bool, vds: v1aldeclst): d1ec

(* ****** ****** *)

fun trans1_typ (_: $Absyn.t0yp): t1yp

(* return value
 0: O.K.
 1: type conflict
 2: type ambiguity
 3: both
*)
fun trans1_exp (_: $Absyn.e0xp): (e1xp, int)

fun trans1_build_err (t_act: t1yp, t_expect: t1yp): string
(* ****** ****** *)

(* end of [trans1.sats] *)
(* vi: set syntax=sml: *)



