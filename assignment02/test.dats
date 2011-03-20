(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

dynload "contrib/parcomb/dynloadall.dats"

(* ****** ****** *)

dynload "absyn.dats"
dynload "absyn1.dats"
dynload "symbol.dats"
dynload "error.dats"
dynload "fixity.dats"
dynload "parser.dats"
dynload "interp0.dats"
dynload "interp1.dats"
dynload "trans1.dats"
dynload "trans2.dats"
dynload "trans_cpp.dats"

(* ****** ****** *)

staload "absyn.sats"
staload "parser.sats"
staload "interp0.sats"
staload "interp1.sats"
staload "error.sats"
staload "trans1.sats"
staload "trans2.sats"
staload "trans_cpp.sats"


(* ****** ****** *)

implement
main () = () where {
  val () = begin
    print "Please input a program written in STFPL:"; print_newline ()
  end // end of [val]
  val prog = parse_from_stdin ()
  val () = print "\n\nbefore type checking ==================================\n\n"
  val () = print "prog =\n"
  val () = fprint_e0xp (stdout_ref, prog)
  val () = print_newline ()

  val () = print "\n\nafter type inference ==================================\n\n"
  val prog1 = trans1_exp (prog)
  val () = fprint_e1xp (stdout_ref, prog1)
  val () = print_newline ()

  // val () = print "\n\ninterp0 ==================================\n\n"
  // val v = interp0_exp(prog)
  // val () = print_newline ()
  // val () = fprint_v0al (stdout_ref, v)
  // val () = print_newline ()

  // val () = print "\n\ninterp1 ==================================\n\n"
  // val v = interp1_exp(prog1)
  // val () = print_newline ()
  // val () = fprint_v1al (stdout_ref, v)
  // val () = print_newline ()

  val () = print "\n\ntransform to IR ==================================\n\n"
  val (irs, fns) = trans2_exp (prog1)

  val os = trans_cpp (irs, fns)
  val () = print_ostream (os)
  val () = print_newline ()
} // end of [main]

(* ****** ****** *)

(* end of [test.dats] *)
