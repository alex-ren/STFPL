(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload Absyn = "absyn.sats"
staload Symbol = "symbol.sats"

(* ****** ****** *)

datatype v0al =
  | V0ALbool of bool
  | V0ALint of int
  | V0ALstr of string
  | V0ALtup of v0allst
  | V0ALclo of (env, $Absyn.e0xp)
  | V0ALfix of (env, $Absyn.e0xp)
  | V0ALref of (ref v0al)

where env = $Symbol.symenv_t (v0al)
and v0allst = list0 v0al

(* ****** ****** *)

fun fprint_v0al (out: FILEref, v: v0al): void
fun fprint_v0allst (out: FILEref, vs: v0allst): void

fun print_v0al (v: v0al): void and prerr_v0al (v: v0al): void

(* ****** ****** *)

//
// Please implement an interpreter for the raw abstract syntax trees:
//
fun interp0_exp (e: $Absyn.e0xp): v0al

(* ****** ****** *)

(* end of [interp0.sats] *)
