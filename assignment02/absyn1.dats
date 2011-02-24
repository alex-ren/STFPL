
(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)


(* ****** ****** *)

staload "trans1.sats"

macdef fprint_symbol = $Symbol.fprint_symbol
macdef fprint_opr = $Absyn.fprint_opr

(* ****** ****** *)

#define Some option0_some
#define None option0_none

#define nil list0_nil
#define cons list0_cons
#define :: list0_cons

(* ****** ****** *)

implement
fprint_t1yp (out, t) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case+ t of
  | T1YPbase sym => fprint_symbol (out, sym)
  | T1YPfun (t1, t2) => let
      val isatm = (case+ t1 of
        | T1YPbase _ => true | T1YPtup _ => true | _ => false
      ) : bool
    in  
      if ~isatm then prstr "(";
      fprint_t1yp (out, t1);
      if ~isatm then prstr ")";
      prstr " -> ";
      fprint_t1yp (out, t2)
    end // end of [T1YPfun]
  | T1YPtup ts => begin
      prstr "("; fprint_t1yplst (out, ts); prstr ")"
    end // end of [T1YPtup] 
end // end of [fprint_t1yp]

implement
fprint_t1yplst
  (out, ts) = loop (ts, 0) where {
  fun loop (ts: t1yplst, i: int):<cloref1> void =
    case+ ts of
    | list0_cons (t, ts) => loop (ts, i+1) where {
        val () = if i > 0 then fprint_string (out, ", ")
        val () = fprint_t1yp (out, t)
      } // end of [list0_cons]
    | list0_nil () => () // end of [list0_nil]
  // end of [loop]
} // end of [fprint_t1yplst]

fn fprint_v1ar
  (out: FILEref, v1ar: v1ar): void = () where {
  // val () = fprint_string (out, "(")
  val () = fprint_symbol (out, v1ar.v1ar_nam)
  val () = fprint_string (out, ": ")
  val () = fprint_t1yp (out, v1ar.v1ar_typ)
  // val () = fprint_string (out, ")")
} // end of [fprint_v1ar]

fn fprint_v1arlst
  (out, v1ars) = loop (v1ars, 0) where {
  fun loop (v1ars: v1arlst, i: int)
    :<cloref1> void = case+ v1ars of
    | cons (v1ar, v1ars) => loop (v1ars, i+1) where {
        val () = if i > 0 then fprint_string (out, ", ")
        val () = fprint_v1ar (out, v1ar)
      } // end of [cons]
    | nil () => ()
  // end of [loop]  
} (* end of [fprint_v1arlst] *)

(* ****** ****** *)

implement fprint_e1xp (out, e1) = let
  macdef prexp (e) = fprint_e1xp (out, ,(e))
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case+ e1.e1xp_node of
  | E1XPann (e, t) => begin
      prstr "E1XPann("; prexp e; prstr ": "; fprint_t1yp (out, t); prstr ")"
    end // end of [E1XPann]
  | E1XPapp (e_fun, e_arg) => begin
      prstr "E1XPapp(";
      prexp e_fun; prstr "; "; prexp e_arg;
      prstr ")"
    end // end of [E1XPapp]
  | E1XPbool b => begin
      prstr "E1XPbool("; fprint_bool (out, b); prstr ")"
    end // end of [E1XPbool] 
  | E1XPfix (f, args, body) => begin
      prstr "E1XPfix(";
      fprint_v1ar (out, f);
      prstr " (";
      fprint_v1arlst (out, args);
      prstr ") => ";
      fprint_e1xp (out, body);
      prstr ")"
    end // end of [E1XPlam]  
  | E1XPif (e1, e2, oe3) => begin
      prstr "E1XPif(";
      prexp e1; prstr " $then "; prexp e2;
      begin
        case+ oe3 of Some e3 => (prstr " $else "; prexp e3) | None () => ()
      end;
      prstr ")"
    end // end of [E1XPif]
  | E1XPint i => begin
      prstr "E1XPint("; fprint_int (out, i); prstr ")"
    end // end of [E1XPint]
  | E1XPlam (args, body) => begin
      prstr "E1XPlam((";
      fprint_v1arlst (out, args);
      prstr "): ";
      fprint_t1yp (out, body.e1xp_typ);
      prstr " => ";
      fprint_e1xp (out, body);
      prstr ")"
    end // end of [E1XPlam]  
  | E1XPlet (decs, e_body) => begin
      prstr "E1XPlet(";
      fprint_d1eclst (out, decs); prstr " $in "; prexp e_body;
      prstr ")"
    end // end of [E1XPlet]
  | E1XPopr (sym, es) => begin
      prstr "E1XPopr(";
      fprint_opr (out, sym); prstr "; "; fprint_e1xplst (out, es);
      prstr ")"
    end // end of [E1XPop]
  | E1XPproj (e, i) => begin
      prstr "E1XPproj("; prexp e; prstr "; "; fprint_int (out, i); prstr ")"
    end // end of [E1XPproj]
  | E1XPstr s => begin
      prstr "E1XPstr("; fprint_string (out, s); prstr ")"
    end // end of [E1XPstr]
  | E1XPtup es => begin
        prstr "E1XPtup("; fprint_e1xplst (out, es); prstr ")"
    end // end of [E1XPlist]    
  | E1XPvar (v1ar) => begin
      prstr "E1XPvar("; fprint_v1ar (out, v1ar); prstr ")"
    end // end of [E1XPvar]
(*
  | _ => ()
*)
end // end of [fprint_e1xp]

implement fprint_e1xplst
  (out, es) = loop (es, 0) where {
  fun loop (es: e1xplst, i: int)
    :<cloref1> void = case+ es of
    | cons (e, es) => loop (es, i+1) where {
        val () = if i > 0 then fprint_string (out, ", ")
        val () = fprint_e1xp (out, e)
      } // end of [cons]
    | nil () => ()
  // end of [loop]  
} (* end of [fprint_e1xplst] *)

implement print_e1xp (e) = fprint_e1xp (stdout_ref, e)
implement prerr_e1xp (e) = fprint_e1xp (stderr_ref, e)

implement fprint_d1eclst (out, decs) = loop (decs, 0) where {
  fun loop (decs: d1eclst, i: int)
    :<cloref1> void = case+ decs of
    | cons (dec, decs') => loop (decs', i+1) where {
        val () = if i > 0 then fprint_string (out, "; ")
        val () = fprint_d1ec (out, dec)
      } // end of [cons]
    | nil () => ()
  // end of [loop]  
} (* end of [fprint_d1eclst] *)

implement fprint_d1ec (out, dec) = let
  val+ D1ECval (_, valdecs) = dec.d1ec_node
in
  fprint_v1aldeclst (out, valdecs)
end

implement fprint_v1aldeclst (out, valdecs) = loop (valdecs, 0) where {
  fun loop (valdecs: v1aldeclst, i: int)
    :<cloref1> void = case+ valdecs of
    | cons (valdec, valdecs') => loop (valdecs', i+1) where {
        val () = if i > 0 then fprint_string (out, ", ")
        val () = fprint_v1aldec (out, valdec)
      } // end of [cons]
    | nil () => ()
  // end of [loop]  
} (* end of [fprint_v1aldeclst] *)

implement fprint_v1aldec (out, valdec) = begin
  fprint_string (out, "$val "); fprint_v1ar (out, valdec.v1aldec_var);
  fprint_string (out, " $= "); fprint_e1xp (out, valdec.v1aldec_def) end


(* ****** ****** *)

(* end of [absyn1.dats] *)
