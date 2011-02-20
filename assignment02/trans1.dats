(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans1.sats"
typedef loc = $Posloc.location_t

(* ****** ****** *)

staload "error.sats"
staload "symbol.sats"
typedef sym = symbol_t


staload "absyn.sats"

(* ****** ****** *)


(* ****** ****** *)
staload _(*anon*) = "symbol.dats"

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
staload _(*anon*) = "prelude/DATS/list_vt.dats" 
staload _(*anon*) = "libats/DATS/funmap_avltree.dats" 

#define :: list0_cons
#define cons list0_cons
#define nil list0_nil


(* ****** ****** *)

val t1yp_bool = T1YPbase symbol_BOOL
val t1yp_int = T1YPbase symbol_INT
val t1yp_string = T1YPbase symbol_STRING
val t1yp_unit = T1YPtup (list0_nil)

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

(* ****** ****** *)

implement
trans1_typ (t) = aux (t) where {
  fun aux (t: t0yp): t1yp = case+ t.t0yp_node of
    | T0YPbase sym => begin case+ 0 of
        | _ when sym = symbol_UNIT => t1yp_unit | _ => T1YPbase sym
      end // end of [T0YPbase]  
    | T0YPfun (t1, t2) => T1YPfun (aux t1, aux t2)
    | T0YPtup (ts) => T1YPtup (list0_map_fun (ts, aux))
  // end of [aux]
} // end of [trans1_typ]   

(* ****** ****** *)

abstype theConstTypMap_t
extern fun theConstTypFind (opr: opr): t1yp

local

assume theConstTypMap_t = symenv_t (t1yp)

#define :: list0_cons; #define nil list0_nil
macdef list0_sing (x) = list0_cons (,(x), list0_nil ())

val theConstTypMap =
  res where {
  val t1yp_int1 = T1YPtup (t1yp_int :: nil)
  val t1yp_int2 = T1YPtup (t1yp_int :: t1yp_int :: nil)
  val t1yp_str1 = T1YPtup (t1yp_string :: nil)
  val t1yp_aop = T1YPfun (t1yp_int2, t1yp_int)
  val t1yp_bop = T1YPfun (t1yp_int2, t1yp_bool)
  typedef T = @(sym, t1yp)
  val cts = (
    (symbol_PLUS, t1yp_aop) ::
    (symbol_MINUS, t1yp_aop) ::
    (symbol_TIMES, t1yp_aop) ::
    (symbol_SLASH, t1yp_aop) ::
    (symbol_UMINUS, T1YPfun (t1yp_int1, t1yp_int)) ::
    (symbol_GT, t1yp_bop) ::
    (symbol_GTE, t1yp_bop) ::
    (symbol_LT, t1yp_bop) ::
    (symbol_LTE, t1yp_bop) ::
    (symbol_EQ, t1yp_bop) ::
    (symbol_NEQ, t1yp_bop) ::
    (symbol_PRINT_INT, T1YPfun (t1yp_int1, t1yp_unit)) ::
    (symbol_PRINT, T1YPfun (t1yp_str1, t1yp_unit)) ::
    nil ()
  ) : list0 (T) // end of [val]
  val res: theConstTypMap_t = symenv_make ()
  fun loop (
    cts: list0 (T), res: theConstTypMap_t
  ) : theConstTypMap_t =
    case+ cts of
    | ct :: cts => let
        val ret(*_already*) = symenv_insert (res, ct.0, ct.1) in loop (cts, res)
      end // end of [::]
    | nil () => res
  // end of [loop]  
  val res = loop (cts, res)
} // end of [val]

in // in of [local]

implement
theConstTypFind (opr) = let
  val+ OPR sym = opr
  val ans = symenv_lookup<t1yp> (theConstTypMap, sym)
in
  case+ ans of
  | option0_some tp => tp
  | option0_none () => let
      val () = begin
        prerr "exit(STFPL)";
        prerr ": unrecognized constant ["; prerr sym; prerr "]";
        prerr_newline ()
      end (* end of [val] *)
    in
      abort {t1yp} (1)
    end // end of [option_none]    
end // end of [theConstMapFind]

end // end of [local]

(* ****** ****** *)

fun lte_t1yp_t1yp
  (t1: t1yp, t2: t1yp): bool = case+ (t1, t2) of
    | (T1YPbase sym1, T1YPbase sym2) => sym1 = sym2
    | (T1YPfun (t11, t12), T1YPfun (t21, t22)) =>
        lte_t1yp_t1yp (t21, t11) andalso lte_t1yp_t1yp (t12, t22)
      // end of [T1YPfun, T1YPfun]
    | (T1YPtup ts1, T1YPtup ts2) => lte_t1yplst_t1yplst (ts1, ts2)
    | (_, _) => false
// end of [lte_t1yp_t1yp]

and lte_t1yplst_t1yplst (ts1: t1yplst, ts2: t1yplst): bool =
  case+ (ts1, ts2) of
  | (list0_cons (t1, ts1), list0_cons (t2, ts2)) =>
      lte_t1yp_t1yp (t1, t2) andalso lte_t1yplst_t1yplst (ts1, ts2)
    // end of [list0_cons, list0_cons]
  | (list0_nil (), list0_nil ()) => true
  | (_, _) => false
// end of [lte_t1yplst_t1yplst]

implement print_t1yp (t) = fprint_t1yp (stdout_ref, t)
implement prerr_t1yp (t) = fprint_t1yp (stderr_ref, t)

(* ****** ****** *)

implement
v1ar_make (loc, sym, t) = '{
  v1ar_loc= loc, v1ar_nam= sym, v1ar_typ= t, v1ar_def= option0_none ()
} // end of [v1ar_make]

implement
e1xp_make_ann (loc, e, t) = '{
  e1xp_loc= loc, e1xp_node = E1XPann (e, t), e1xp_typ= t
} // end of [e1xp_make_ann]

implement
e1xp_make_app (loc, e1, e2, t) = '{
  e1xp_loc= loc, e1xp_node = E1XPapp (e1, e2), e1xp_typ= t
} // end of [e1xp_make_app]

implement
e1xp_make_bool (loc, b) = '{
  e1xp_loc= loc, e1xp_node = E1XPbool b, e1xp_typ= t1yp_bool
} // end of [e1xp_make_bool]

implement
e1xp_make_fix (loc, f, xs, body, t_fun) = '{
  e1xp_loc= loc, e1xp_node = E1XPfix (f, xs, body), e1xp_typ= t_fun
} // end of [e1xp_make_fix]

implement
e1xp_make_if (loc, e1, e2, oe3, t) = '{
  e1xp_loc= loc, e1xp_node = E1XPif (e1, e2, oe3), e1xp_typ= t
} // end of [e1xp_make_if]

implement
e1xp_make_int (loc, i) = '{
  e1xp_loc= loc, e1xp_node = E1XPint i, e1xp_typ= t1yp_int
} // end of [e1xp_make_int]

implement
e1xp_make_lam (loc, xs, body, t_fun) = '{
  e1xp_loc= loc, e1xp_node = E1XPlam (xs, body), e1xp_typ= t_fun
} // end of [e1xp_make_lam]

implement
e1xp_make_let (loc, decs, body, t_let) = '{
  e1xp_loc= loc, e1xp_node= E1XPlet (decs, body), e1xp_typ= t_let
} // end of [e1xp_make_let]

implement
e1xp_make_opr (loc, opr, es, t_res) = '{
  e1xp_loc= loc, e1xp_node= E1XPopr (opr, es), e1xp_typ= t_res
} // end of [e1xp_make_opr]

implement
e1xp_make_proj (loc, e, i, t_proj) = '{
  e1xp_loc= loc, e1xp_node= E1XPproj (e, i), e1xp_typ= t_proj
} // end of [e1xp_make_proj]

implement
e1xp_make_str (loc, s) = '{
  e1xp_loc= loc, e1xp_node = E1XPstr s, e1xp_typ= t1yp_string
} // end of [e1xp_make_str]

implement
e1xp_make_tup (loc, es, t_tup) = '{
  e1xp_loc= loc, e1xp_node = E1XPtup es, e1xp_typ= t_tup
} // end of [e1xp_make_tup]

implement
e1xp_make_var (loc, x) = '{
  e1xp_loc= loc, e1xp_node = E1XPvar x, e1xp_typ= x.v1ar_typ
} // end of [e1xp_make_var]

implement
v1aldec_make (loc, x, def) = '{
  v1aldec_loc= loc, v1aldec_var= x, v1aldec_def= def
} // end of [v1aldec_make]

implement
d1ec_make_val (loc, isrec, vds) = '{
  d1ec_loc= loc, d1ec_node= D1ECval (isrec, vds)
} // end of [d1ec_make_val]

(* ****** ****** *)

extern typedef "v1ar_t" = v1ar

%{$

ats_bool_type
eq_v1ar_v1ar (v1ar_t x1, v1ar_t x2) {
  return (x1 == x2 ? ats_true_bool : ats_false_bool) ;
} /* end of [eq_v1ar_v1ar] */

ats_void_type
v1ar_set_def (
  ats_ptr_type x
, ats_ptr_type oe
) {
  ((v1ar_t)x)->atslab_v1ar_def = oe ;  return ;
} /* end of [v1ar_set_def] */

%} // end of [%{$]

(* ****** ****** *)

typedef ctx = symenv_t (v1ar)
val ctx_nil = symenv_make () // empty context


(* ****** ****** *)
abstype type_error
(* record all the error for future output *)
extern fun type_error_add (loc: loc, msg: String): bool
extern fun type_error_has (): bool
extern fun type_error_get (n: int): option0 type_error

local
assume type_error = '{loc = loc, msg = String}
val error_pool: ref (list0 type_error) = ref_make_elt<list0  type_error> (nil)
in
implement type_error_add (loc, msg) = let
  val () = !error_pool := '{loc = loc, msg = msg} :: !error_pool

implement type_error_has () =
  case+ !error_pool of cons (_, _) => true | nil () => false

in
  true
end
end  // end of [local]


exception TypeError of (loc, String)


extern fun oftype (Gamma: ctx, e: e0xp): e1xp

extern fun typcheck (Gamma: ctx, e: e0xp, t: t1yp): e1xp

////
implement typcheck (Gamma, e, t) = let
  val e0_node = e0.e0xp_node
  val e0_loc = e0.e0xp_loc
in
  case+ e0.e0xp_node of
  | E0XPann (e0xp, t0yp) => let

(* todo may throw fatal *)
extern fun trans1_exp_1 (e: e0xp): e1xp

(*
fun trans1_exp_ann (Gamma: ctx, e0xp: e0xp, loc: loc, t0yp: t0yp): e1xp = let
  val t1yp = trans1_typ (t0yp)
in
  if typcheck (Gamma, e0xp, t1yp) = true then let
    val e1xp = trans1_exp (e0xp)
  in
    e1xp_make_ann (loc, e1xp, t1yp)
  end else let
    val err = type_error_add (loc, "trans1_exp_ann")
    val dummy = '{e1xp_loc = loc, 
                  e1xp_node = E1XPint (825), 
                  e1xp_typ = t1yp}
  in
    e1xp_make_ann (loc, dummy, t1yp)
  end
end  // end of [trans1_exp_ann]
*)
    
// fun trans1_exp_app (Gamma: ctx, e0_fun: e0xp, e0_args: e0xp, loc: loc): e1xp =

(* ************
implement trans1_exp (e0) = let
  val e1xp = trans1_exp_1 (e0)
in
  if type_error_has () = true then // todo print error msg
    ETRACE_MSG_OPR ("trans1_exp: type error", ETRACE_LEVEL_INFO,
           abort (ERRORCODE_TYPE_ERROR))
  else e1xp
end
************* *)

(* ************
implement trans1_exp_1 (e0) = let
  val e0_node = e0.e0xp_node
  val e0_loc = e0.e0xp_loc
in
  case+ e0.e0xp_node of
  | E0XPann (e0xp, t0yp) => trans1_exp_ann (ctx_nil, e0xp, e0_loc, t0yp)
  | E1XPapp (e0_fun, e0_args) => trans1_exp_app (ctx_nil, e0_fun, e0_args, e0_loc)
  | _ => ETRACE_MSG_OPR ("trans1_exp ~ error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_FORBIDDEN))
end
************* *)

    

(* ****** ****** *)

(* end of [trans1.dats] *)
