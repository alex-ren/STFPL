(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "error.sats"

(* ****** ****** *)

implement abort (err: int) = $raise Fatal (err)



(* ****** ****** *)

(* end of [error.dats] *)
