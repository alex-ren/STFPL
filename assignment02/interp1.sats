(*
** Course: Concepts of Programming Languages (BU CAS CS 320)
** Semester: Summer I, 2009
** Instructor: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
*)

//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Time: June, 2009
//

(* ****** ****** *)

//
// An interpreter for STFPL (a simple typed functional programming language)
// The code was originally written by Hongwei Xi in May 2005
//

(* ****** ****** *)

staload TRANS1 = "trans1.sats"

(* ****** ****** *)

datatype v1al =
  | V1ALbool of bool
  | V1ALint of int
  | V1ALstr of string
  | V1ALtup of list0 v1al 
  | V1ALclo of (env, $TRANS1.v1arlst, $TRANS1.e1xp)
// end of [v1al]

where env = list0 @($TRANS1.v1ar, v1al)

(* ****** ****** *)

fun fprint_v1al (out: FILEref, v: v1al): void
fun fprint_v1allst (out: FILEref, vs: list0 v1al): void

fun print_v1al (v: v1al): void and prerr_v1al (v: v1al): void

(* ****** ****** *)

fun interp1_exp (e: $TRANS1.e1xp): v1al

(* ****** ****** *)

(* end of [interp1.sats] *)
