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
dynload "trans_closure.dats"
dynload "trans2.dats"
dynload "libfunctions.dats"  // after trans2
dynload "trans_cpp.dats"

(* ****** ****** *)

staload "absyn.sats"
staload "parser.sats"
staload "interp0.sats"
staload "interp1.sats"
staload "error.sats"
staload "trans1.sats"
staload "trans_closure.sats"
staload "trans2.sats"
staload "trans_cpp.sats"


(* ****** ****** *)

implement
main () = () where {
  // val () = begin
  //   print "Please input a program written in STFPL:"; print_newline ()
  // end // end of [val]
  val prog = parse_from_stdin ()
  val () = fprint (stderr_ref,
      "\n\nbefore type checking ==================================\n\n")
  val () = fprint (stderr_ref, "prog =\n")
  val () = fprint_e0xp (stderr_ref, prog)
  val () = fprint (stderr_ref, "\n")

  val () = fprint (stderr_ref, 
         "\n\nafter type inference ==================================\n\n")
  val (prog1, err) = trans1_exp (prog)
  val () = fprint_e1xp (stderr_ref, prog1)
  val () = fprint (stderr_ref, "\n")
  
  val () = if err <> 0 then let
    val () = fprint (stderr_ref, "Type error exists, compiler exits\n")
  in end else let
    
    val () = fprint (stderr_ref, 
        "\n\nafter closure formation ==================================\n\n")
    val prog_clo = trans_closure (prog1)
    val () = fprint_e1xp (stderr_ref, prog_clo)
    val () = fprint (stderr_ref, "\n")

    // val () = fprint (stderr_ref, 
    //   "\n\ninterp0 ==================================\n\n")
    // val v = interp0_exp(prog)
    // val () = fprint (stderr_ref, "\n")
    // val () = fprint_v0al (stderr_ref, v)
    // val () = fprint (stderr_ref, "\n")

    // val () = fprint (stderr_ref, 
    //      "\n\ninterp1 ==================================\n\n")
    // val v = interp1_exp(prog1)
    // val () = fprint (stderr_ref, "\n")
    // val () = fprint_v1al (stderr_ref, v)
    // val () = fprint (stderr_ref, "\n")

    val () = fprint (stderr_ref, 
          "\n\ntransform to IR ==================================\n\n")
    val (irs, fns) = trans2_exp (prog1)
    // val () = fprint (stderr_ref, 
    //  "\n\nmain function ==================================\n\n")
    // val () = fprint_instrlst (stderr_ref, irs)
    // val () = fprint (stderr_ref, "\n")

    val os = trans_cpp (irs, fns)
    val () = print_ostream (os)
    val () = fprint (stderr_ref, "\n")
  in end
} // end of [main]

(* ****** ****** *)

(* end of [test.dats] *)
