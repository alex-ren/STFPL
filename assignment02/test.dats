(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

dynload "contrib/parcomb/dynloadall.dats"

(* ****** ****** *)

dynload "absyn.dats"
dynload "symbol.dats"
dynload "error.dats"
dynload "fixity.dats"
dynload "parser.dats"
dynload "interp0.dats"

(* ****** ****** *)

staload "absyn.sats"
staload "parser.sats"
staload "interp0.sats"
staload "error.sats"


(* ****** ****** *)

implement
main () = () where {
  val () = begin
    print "Please input a program written in STFPL:"; print_newline ()
  end // end of [val]
  val prog = parse_from_stdin ()
  val () = print "prog =\n"
  val () = fprint_e0xp (stdout_ref, prog)
  val () = print_newline ()
  val v = interp0_exp(prog)
  val () = print_newline ()
  val () = fprint_v0al (stdout_ref, v)
  val () = print_newline ()
} // end of [main]

(* ****** ****** *)

(* end of [test.dats] *)
