(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)
//
// A parser for STFPL (a simple typed functional programming language)
// The code was originally written by Hongwei Xi in May 2005
//
(* ****** ****** *)

staload "absyn.sats"

(* ****** ****** *)

fun parse_from_stdin (): e0xp
fun parse_from_file (filename: string): e0xp

(* ****** ****** *)

(* end of [parser.sats] *)
