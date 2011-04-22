(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)
//
// Abstract Syntax Tree for STFPL (simply typed functional
// programming language)
//
// The code was originally written by Hongwei Xi in May 2005
//
(* ****** ****** *)

staload Posloc = "contrib/parcomb/SATS/posloc.sats"

(* ****** ****** *)

staload Symbol = "symbol.sats"

(* ****** ****** *)

datatype t0yp_node =
  | T0YPbase of $Symbol.symbol_t
  | T0YPfun of (t0yp, t0yp)
  | T0YPtup of t0yplst
// end of [t0yp_node]

where t0yp = '{
  t0yp_loc= $Posloc.location_t, t0yp_node= t0yp_node
} // end of [t0yp]

and t0ypopt = option0 t0yp and t0yplst = list0 t0yp

(* ****** ****** *)

fun fprint_t0yp (out: FILEref, _: t0yp): void
fun fprint_t0yplst (out: FILEref, _: t0yplst): void

(* ****** ****** *)

fun t0yp_make_sym (_: $Posloc.location_t, _: $Symbol.symbol_t):<> t0yp 
fun t0yp_make_fun (_: $Posloc.location_t, arg: t0yp, res: t0yp):<> t0yp
fun t0yp_make_tup (_: $Posloc.location_t, _: t0yplst):<> t0yp

(* ****** ****** *)

datatype opr = OPR of ($Symbol.symbol_t)

fun fprint_opr (out: FILEref, opr: opr): void

(* ****** ****** *)

datatype e0xp_node =
  | E0XPann of (e0xp, t0yp)
  | E0XPapp of (e0xp, e0xp)
  | E0XPbool of bool
  | E0XPfix of ($Symbol.symbol_t, a0rglst, t0ypopt, e0xp)
  | E0XPif of (e0xp, e0xp, e0xpopt)
  | E0XPint of int
  | E0XPlam of (a0rglst, t0ypopt, e0xp)
  | E0XPlet of (d0eclst, e0xp)
  | E0XPopr of (opr, e0xplst)
  | E0XPproj of (e0xp, int)
  | E0XPstr of string
  | E0XPtup of e0xplst
  | E0XPvar of $Symbol.symbol_t
// end of [e0xp_node]

and d0ec_node =
  | D0ECval of (bool(*isrec*), v0aldeclst)
// end of [d0ec_node]

where e0xp = '{
    e0xp_loc= $Posloc.location_t, e0xp_node= e0xp_node
  } // end of [e0xp]

and e0xplst = list0 e0xp
and e0xpopt = option0 e0xp

and a0rg = @{
  a0rg_loc= $Posloc.location_t, a0rg_nam= $Symbol.symbol_t, a0rg_typ= t0ypopt
} // end of [a0rg] 
and a0rglst = list0 a0rg

and d0ec = '{
  d0ec_loc= $Posloc.location_t, d0ec_node= d0ec_node
} // end of [d0ec]
and d0eclst = list0 (d0ec)

and v0aldec = '{
  v0aldec_loc= $Posloc.location_t
, v0aldec_nam= $Symbol.symbol_t
, v0aldec_ann= t0ypopt
, v0aldec_def= e0xp
}
and v0aldeclst = list0 (v0aldec)
// end of [where]

(* ****** ****** *)

fun fprint_d0eclst (out: FILEref, _: d0eclst): void
fun fprint_d0ec (out: FILEref, _: d0ec): void
fun fprint_v0aldeclst (out: FILEref, _: v0aldeclst): void
fun fprint_v0aldec (out: FILEref, _: v0aldec): void

fun fprint_e0xp (out: FILEref, _: e0xp): void
fun fprint_e0xplst (out: FILEref, _: e0xplst): void

fun prerr_e0xp (e: e0xp): void
fun print_e0xp (e: e0xp): void

(* ****** ****** *)

fun e0xp_make_ann (_: $Posloc.location_t, e: e0xp, t: t0yp):<> e0xp
fun e0xp_make_app (_: $Posloc.location_t, _fun: e0xp, _arg: e0xp):<> e0xp
fun e0xp_make_bool (_: $Posloc.location_t, _: bool):<> e0xp
fun e0xp_make_fix (_: $Posloc.location_t, _: $Symbol.symbol_t, _: a0rglst, _: t0ypopt, _: e0xp):<> e0xp
fun e0xp_make_if (_: $Posloc.location_t, _: e0xp, _: e0xp, _: e0xpopt):<> e0xp
fun e0xp_make_int (_: $Posloc.location_t, _: int):<> e0xp
fun e0xp_make_lam (_: $Posloc.location_t, _: a0rglst, _: t0ypopt, _: e0xp):<> e0xp
fun e0xp_make_let (_: $Posloc.location_t, ds: d0eclst, e: e0xp):<> e0xp
fun e0xp_make_opr (_: $Posloc.location_t, _: opr, _: e0xplst):<> e0xp
fun e0xp_make_proj (_: $Posloc.location_t, e: e0xp, i: int):<> e0xp
fun e0xp_make_str (_: $Posloc.location_t, _: string):<> e0xp
fun e0xp_make_tup (_: $Posloc.location_t, _: e0xplst):<> e0xp
fun e0xp_make_var (_: $Posloc.location_t, _: $Symbol.symbol_t):<> e0xp

(* ****** ****** *)

fun d0ec_make_val (_: $Posloc.location_t, isrec: bool, vds: v0aldeclst):<> d0ec 

(* ****** ****** *)

(* end of [absyn.sats] *)
(* vi: set syntax=sml: *)

