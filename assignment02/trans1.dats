(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans1.sats"
typedef loc = $Posloc.location_t
macdef prerr_loc = $Posloc.prerr_location

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

#define Some0 option0_some
#define None0 option0_none

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
implement fprint_e1xp (out, e) = fprint (out, "dummy print e1xp\n")  // todo

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
abstype tyerr
typedef tyerr_pool = list0 tyerr
(* record all the error for future output *)
extern fun tyerr_pool_add (pool: tyerr_pool, loc: loc, msg: String): tyerr_pool
extern fun tyerr_pool_append (p1: tyerr_pool, p2: tyerr_pool): tyerr_pool
extern fun tyerr_pool_make (): tyerr_pool

local
assume tyerr = '{loc = loc, msg = String}
in
implement tyerr_pool_add (pool, loc, msg) = 
  '{loc = loc, msg = msg} :: pool

implement tyerr_pool_append (p1, p2) = list0_append (p1, p2)

implement tyerr_pool_make () = nil
end  // end of [local]

val tyerr_pool_nil = tyerr_pool_make ()  // empty error pool

// exception TypeError of (loc, String)


extern fun oftype (Gamma: ctx, e0: e0xp): (e1xp, tyerr_pool)

extern fun typcheck (Gamma: ctx, e0: e0xp, t1: t1yp): (e1xp, tyerr_pool)

fun oftype_ann (Gamma: ctx, loc: loc, e0: e0xp, t0: t0yp): 
  (e1xp, tyerr_pool) = let
  val t1 = trans1_typ (t0)
  val (e1, tyerrs) = typcheck (Gamma, e0, t1)
  val e1a = e1xp_make_ann (loc, e1, t1)
in
  (e1a, tyerrs)
end

fun oftype_if (Gamma: ctx, loc: loc, 
  e0_if: e0xp, e0_then: e0xp, e0opt_else: e0xpopt): (e1xp, tyerr_pool) = let
  val (e1_if, tyerrs1) = typcheck (Gamma, e0_if, t1yp_bool)
in
  case+ e0opt_else of
  | Some0 e0_else => let
    val (e1_then, tyerrs2) = oftype (Gamma, e0_then)
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
    val (e1_else, tyerrs3) = typcheck (Gamma, e0_else, e1_then.e1xp_typ)
    val tyerrs = tyerr_pool_append (tyerrs, tyerrs3)
    (* assume the type of if statement = the then branch *)
    val e1 = e1xp_make_if (loc, e1_if, e1_then, Some0 e1_else, e1_then.e1xp_typ)
  in
    (e1, tyerrs)
  end
  | None0 () => let
    val (e1_then, tyerrs2) = typcheck (Gamma, e0_then, t1yp_unit)
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
    (* assume the type of if statement t1yp_unit *)
    val e1 = e1xp_make_if (loc, e1_if, e1_then, None0, t1yp_unit)
  in
    (e1, tyerrs)
  end
end
    
(* fill the environment and do the transformation *)
extern fun oftype_declst (Gamma: ctx, decs: d0eclst): 
  (ctx, d1eclst, tyerr_pool)

extern fun oftype_dec (Gamma: ctx, dec: d0ec): (ctx, d1ec, tyerr_pool)

extern fun oftype_valdeclst (Gamma: ctx, v0aldecs: v0aldeclst):
  (ctx, v1aldeclst, tyerr_pool)

extern fun oftype_valdec (Gamma: ctx, v0aldec: v0aldec):
  (ctx, v1aldec, tyerr_pool)

implement oftype_declst (Gamma, decs) = let
  fun helper (init: (ctx, d1eclst, tyerr_pool), dec: d0ec):<cloref1>
    (ctx, d1eclst, tyerr_pool) = let
    val (gamma, d1ec, tyerrs) = oftype_dec (init.0, dec)
    val d1ecs = d1ec :: init.1
    val tyerrs = tyerr_pool_append (init.2, tyerrs)
  in
    (gamma, d1ecs, tyerrs)
  end
in
  list0_fold_left (helper, (Gamma, nil, tyerr_pool_nil), decs)
end

(* extern fun oftype_dec (Gamma: ctx, dec: d0ec): (ctx, d1ec, tyerr_pool) *)
implement oftype_dec (Gamma, dec) = let
  val d0ec_loc = dec.d0ec_loc
  val d0ec_node = dec.d0ec_node
  val+ D0ECval (isrec, v0aldecs) = d0ec_node
in
  if isrec = true then 
    ETRACE_MSG_OPR ("oftype_dec = error\n", ETRACE_LEVEL_ERROR, 
    abort (ERRORCODE_FORBIDDEN))  // todo
  else let
    val (Gamma1, v1aldecs, tyerrs) = oftype_valdeclst (Gamma, v0aldecs)
    val d1ec = '{d1ec_loc = d0ec_loc, d1ec_node = D1ECval (isrec, v1aldecs)}
  in
    (Gamma1, d1ec, tyerrs)
  end
end

implement oftype_valdeclst (Gamma, v0aldecs) = let
  fun helper (init: (ctx, v1aldeclst, tyerr_pool), v0aldec: v0aldec):<cloref1>
    (ctx, v1aldeclst, tyerr_pool) = let
    val (gamma, v1aldec, tyerrs) = oftype_valdec (init.0, v0aldec)
    val v1aldecs = v1aldec :: init.1
    val tyerrs = tyerr_pool_append (init.2, tyerrs)
  in
    (gamma, v1aldecs, tyerrs)
  end
in
  list0_fold_left (helper, (Gamma, nil, tyerr_pool_nil), v0aldecs)
end

  
implement oftype_valdec (Gamma, v0aldec) = let
  val loc = v0aldec.v0aldec_loc
  val nam = v0aldec.v0aldec_nam
  val t0ypopt = v0aldec.v0aldec_ann
  val def = v0aldec.v0aldec_def
in
  case+ t0ypopt of
  | Some0 t0yp => let
    val t1yp = trans1_typ (t0yp)
    val (e1xp, tyerrs) = typcheck (Gamma, def, t1yp)
    (* maybe not match, use the annotated one *)
    val v1ar = v1ar_make (loc, nam, t1yp)
    val v1aldec = '{v1aldec_loc = loc, v1aldec_var = v1ar, v1aldec_def = e1xp}
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1aldec, tyerrs)
  end
  | None0 () => let
    val (e1xp, tyerrs) = oftype (Gamma, def)
    val v1ar = v1ar_make (loc, nam, e1xp.e1xp_typ)
    val v1aldec = '{v1aldec_loc = loc, v1aldec_var = v1ar, v1aldec_def = e1xp}
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1aldec, tyerrs)
  end
end  // end of [oftype_valdec]
  

fun oftype_let (Gamma: ctx, loc: loc, decs: d0eclst, e0_body: e0xp):
  (e1xp, tyerr_pool) = let
  val (Gamma1, d1ecs, tyerrs1) = oftype_declst (Gamma, decs)
  val (e1, tyerrs2) = oftype (Gamma1, e0_body)
  val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
in
  (e1xp_make_let (loc, d1ecs, e1, e1.e1xp_typ), tyerrs)
end

implement oftype (Gamma, e0) = let
  val e0_node = e0.e0xp_node
  val e0_loc = e0.e0xp_loc
in
  case+ e0_node of
  | E0XPann (e0a, t0a) => oftype_ann (Gamma, e0_loc, e0a, t0a)
  // | E1XPapp (e0fun, e0args) => 
  | E0XPbool (b) => (e1xp_make_bool (e0_loc, b), tyerr_pool_nil)
  | E0XPint (i) => (e1xp_make_int (e0_loc, i), tyerr_pool_nil)
  | E0XPif (e0_if, e0_then, e0opt_else) => 
    oftype_if (Gamma, e0_loc, e0_if, e0_then, e0opt_else)
  | E0XPlet (d0eclst_local, e0_body) => 
    oftype_let (Gamma, e0_loc, d0eclst_local, e0_body)
  | _(*todo*) => ETRACE_MSG_OPR ("oftype ~ error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_FORBIDDEN))
end

implement typcheck (Gamma, e0, t1) = let
  val (e1, tyerrs) = oftype (Gamma, e0)
  val ty_cmp = lte_t1yp_t1yp (e1.e1xp_typ, t1)
in
  if ty_cmp = true then (e1, tyerrs)
  else let
    val () = prerr_loc (e1.e1xp_loc)
    val () = prerr ": error(type) ..."
    val () = prerr_newline ()
    val errmsg = "todo .........."
  in
    (e1, tyerr_pool_add (tyerr_pool_nil, e1.e1xp_loc, errmsg))
  end
end

implement trans1_exp (e0xp) = let
  val (e1xp, tyerrs) = oftype (ctx_nil, e0xp)
in
  e1xp
end


