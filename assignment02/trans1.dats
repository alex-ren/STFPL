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
        val res(*_already*) = symenv_insert (res, ct.0, ct.1) in loop (cts, res)
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
end // end of [theConstTypFind]

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

extern fun oftype_valdeclst_rec (Gamma: ctx, v0aldecs: v0aldeclst):
  (ctx, v1aldeclst, tyerr_pool)

extern fun oftype_valdec (Gamma: ctx, v0aldec: v0aldec):
  (ctx, v1aldec, tyerr_pool)

extern fun oftype_valdec_rec (Gamma: ctx, v0aldec: v0aldec): (v1aldec, tyerr_pool)

implement oftype_declst (Gamma, decs) = let
  fun helper (init: (ctx, d1eclst, tyerr_pool), dec: d0ec):<cloref1>
    (ctx, d1eclst, tyerr_pool) = let
    val (gamma, d1ec, tyerrs) = oftype_dec (init.0, dec)
    val d1ecs = d1ec :: init.1
    val tyerrs = tyerr_pool_append (init.2, tyerrs)
  in
    (gamma, d1ecs, tyerrs)
  end
  val (gamma, d1ecs, tyerrs) = list0_fold_left (helper, (Gamma, nil, tyerr_pool_nil), decs)
  val d1ecs = list0_reverse (d1ecs)  // maintain the order
in
  (gamma, d1ecs, tyerrs)
end

(* extern fun oftype_dec (Gamma: ctx, dec: d0ec): (ctx, d1ec, tyerr_pool) *)
implement oftype_dec (Gamma, dec) = let
  val d0ec_loc = dec.d0ec_loc
  val d0ec_node = dec.d0ec_node
  val+ D0ECval (isrec, v0aldecs) = d0ec_node
  val (Gamma1, v1aldecs, tyerrs) = if isrec = true then 
      oftype_valdeclst_rec (Gamma, v0aldecs)
    else oftype_valdeclst (Gamma, v0aldecs)
  val d1ec = '{d1ec_loc = d0ec_loc, d1ec_node = D1ECval (isrec, v1aldecs)}
in
  (Gamma1, d1ec, tyerrs)
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
  val (gamma, v1aldecs, tyerrs) = 
        list0_fold_left (helper, (Gamma, nil, tyerr_pool_nil), v0aldecs)
  val v1aldecs = list0_reverse (v1aldecs)  // maintain the order
in
  (gamma, v1aldecs, tyerrs)
end

implement oftype_valdeclst_rec (Gamma, v0aldecs) = let
  fun fillin_env (Gamma: ctx, valdecs: v0aldeclst): (ctx, tyerr_pool) =
    case+ valdecs of
    | cons (valdec, valdecs1) => let
      val loc = valdec.v0aldec_loc
      val nam = valdec.v0aldec_nam
      val (t1yp, tyerrs1) = case+ valdec.v0aldec_ann of
        | Some0 t0yp => (trans1_typ (t0yp), tyerr_pool_nil)
        | None0 () => let 
          val () = prerr_loc (loc)
          val () = prerr ": recursively declared value must have type annotated"
          val () = prerr_newline ()
          val errmsg = "recursively declared value must have type annotated"
        in
          (* assume the type is int *)
          (t1yp_int, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
        end
      val Gamma1 = symenv_insert (Gamma, nam, v1ar_make (loc, nam, t1yp))
      val (Gamma2, tyerrs2) = fillin_env (Gamma1, valdecs1)
      val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
    in
      (Gamma2, tyerrs)
    end
    | nil () => (Gamma, tyerr_pool_nil)

  val (Gamma1, tyerrs1) = fillin_env (Gamma, v0aldecs)

  fun helper (init: (v1aldeclst, tyerr_pool), v0aldec: v0aldec):<cloref1>
    (v1aldeclst, tyerr_pool) = let
    val (v1aldec, tyerrs) = oftype_valdec_rec (Gamma1, v0aldec)
    val v1aldecs = v1aldec :: init.0
    val tyerrs = tyerr_pool_append (init.1, tyerrs)
  in
    (v1aldecs, tyerrs)
  end

  val (v1aldecs, tyerrs) = list0_fold_left (helper, (nil, nil), v0aldecs)
  val v1aldecs = list0_reverse (v1aldecs)
in
  (Gamma1, v1aldecs, tyerrs)
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
  
(* extern fun oftype_valdec_rec (Gamma: ctx, v0aldec: v0aldec): (v1aldec, tyerr_pool) *)
implement oftype_valdec_rec (Gamma, v0aldec) = let
  val nam = v0aldec.v0aldec_nam
  val loc = v0aldec.v0aldec_loc
  val v1aropt = symenv_lookup<v1ar> (Gamma, nam)
in
  case+ v1aropt of
  | Some0 v1ar => let
    val (def, tyerrs) = typcheck (Gamma, v0aldec.v0aldec_def, v1ar.v1ar_typ)
    val v1aldec = '{v1aldec_loc = loc, v1aldec_var = v1ar, v1aldec_def = def}
  in
    (v1aldec, tyerrs)
  end
  | None0 () => ETRACE_MSG_OPR ("oftyp_valdec_rec var not found\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
end

fun oftype_let (Gamma: ctx, loc: loc, decs: d0eclst, e0_body: e0xp):
  (e1xp, tyerr_pool) = let
  val (Gamma1, d1ecs, tyerrs1) = oftype_declst (Gamma, decs)
  val (e1, tyerrs2) = oftype (Gamma1, e0_body)
  val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
in
  (e1xp_make_let (loc, d1ecs, e1, e1.e1xp_typ), tyerrs)
end

extern fun oftyp_arglst (Gamma: ctx, a0rgs: a0rglst): (ctx, v1arlst, t1yplst, tyerr_pool)

extern fun oftyp_arg (Gamma: ctx, a0rg: a0rg): (ctx, v1ar, tyerr_pool)

implement oftyp_arglst (Gamma, a0rgs) = let
  fun helper (init: (ctx, v1arlst, t1yplst, tyerr_pool), a0rg: a0rg)
    :<cloref1> (ctx, v1arlst, t1yplst, tyerr_pool) = let
    val (gamma, v1ar, tyerrs) = oftyp_arg (init.0, a0rg)
    val v1ars = v1ar :: init.1
    val t1yps = v1ar.v1ar_typ :: init.2
    val tyerrs = tyerr_pool_append (init.3, tyerrs)
  in
    (gamma, v1ars, t1yps, tyerrs)
  end
  val (gamma, v1ars, t1yps, tyerrs) = 
      list0_fold_left (helper, (Gamma, nil, nil, tyerr_pool_nil), a0rgs)
  val v1ars = list0_reverse (v1ars)
  val t1yps = list0_reverse (t1yps)
in
  (gamma, v1ars, t1yps, tyerrs)
end

implement oftyp_arg (Gamma, a0rg) = let
  val loc = a0rg.a0rg_loc
  val t0ypopt = a0rg.a0rg_typ
  val nam = a0rg.a0rg_nam
in
  case+ t0ypopt of
  | Some0 t0yp => let
    val t1yp = trans1_typ (t0yp)
    val v1ar = v1ar_make (loc, nam, t1yp)
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1ar, tyerr_pool_nil)
  end
  | None0 () => let
    val () = prerr_loc (loc)
    val () = prerr ": arg must have type"
    val () = prerr_newline ()
    val errmsg = "arg must have type"

    (* assume the type is int *)
    val v1ar = v1ar_make (loc, nam, t1yp_int)
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1ar, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
  end
end

fun oftype_lam (Gamma: ctx, loc: loc, a0rgs: a0rglst, t0ypopt: t0ypopt, e0xp: e0xp):
  (e1xp, tyerr_pool) = let
  val (Gamma1, v1ars, t1yps, tyerrs1) = oftyp_arglst (Gamma, a0rgs)
  (* If there is only one argument, then the input type is not a tuple. *)
  val t1yp_args = if list0_length (t1yps) = 1 then let
      val- cons (t1yp_arg, _) = t1yps in t1yp_arg end
    else T1YPtup (t1yps)
in
  case+ t0ypopt of
  | Some0 t0yp => let
    val t1yp = trans1_typ (t0yp)
    val (e1xp_body, tyerrs2) = typcheck (Gamma1, e0xp, t1yp)
    val e1xp_lam = e1xp_make_lam (loc, v1ars, e1xp_body, T1YPfun (t1yp_args, t1yp))
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
  in
    (e1xp_lam, tyerrs2)
  end
  | None0 () => let
    val (e1xp_body, tyerrs2) = oftype (Gamma1, e0xp)
    val e1xp_lam = e1xp_make_lam (loc, v1ars, e1xp_body, T1YPfun (t1yp_args, e1xp_body.e1xp_typ))
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
  in
    (e1xp_lam, tyerrs2)
  end
end

fun oftype_opr (Gamma: ctx, loc: loc, opr: opr, e0xps: e0xplst): (e1xp, tyerr_pool) = let
  val t1yp_opr = theConstTypFind (opr)
in
  case+ t1yp_opr of
  | T1YPfun (t1yp_args, t1yp_ret) => let
    val e0xp_tup = '{e0xp_loc = loc, e0xp_node = E0XPtup (e0xps)}
    val (e1xp_tup, tyerrs) = typcheck (Gamma, e0xp_tup, t1yp_args)
  in
    case+ e1xp_tup.e1xp_node of
    | E1XPtup (e1xps) => let
      val e1xp = e1xp_make_opr (loc, opr, e1xps, t1yp_ret)
    in
      (e1xp, tyerrs)
    end
    | _ => ETRACE_MSG_OPR ("oftype_opr: should not happen\n", ETRACE_LEVEL_ERROR,
             abort (ERRORCODE_FORBIDDEN))
  end
  | _ => ETRACE_MSG_OPR ("oftype_opr: opr should have function type\n", ETRACE_LEVEL_ERROR,
             abort (ERRORCODE_FORBIDDEN))
end

fun oftype_proj (Gamma: ctx, loc: loc, e0xp: e0xp, i: int): (e1xp, tyerr_pool) = let
  val (e1xp, tyerrs) = oftype (Gamma, e0xp)
in
  case+ e1xp.e1xp_typ of
  | T1YPtup (t1yps) => let
    val t1ypopt = list0_nth_opt<t1yp> (t1yps, i)
  in
    case+ t1ypopt of
    | Some t1ypitem => (e1xp_make_proj (loc, e1xp, i, t1ypitem), tyerrs)
    | None () => let
      (* out of bound: use int as the type *)
      val e1xp_proj = e1xp_make_proj (loc, e1xp, i, t1yp_int)
      val () = prerr_loc (loc)
      val () = prerr ": projection out of bound"
      val () = prerr_newline ()
      val errmsg = "projection out of bound"
    in
      (e1xp_proj, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
    end
  end
  | _ => let
    (* not tuple: use whatever type it has *)
    val e1xp_proj = e1xp_make_proj (loc, e1xp, i, e1xp.e1xp_typ)
    val () = prerr_loc (loc)
    val () = prerr ": projection on non-tuple type"
    val () = prerr_newline ()
    val errmsg = "projection on non-tuple type"
  in
    (e1xp_proj, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
  end
end

fun oftype_tup (Gamma: ctx, loc: loc, e0xps: e0xplst): (e1xp, tyerr_pool) = let
  fun helper (init: (e1xplst, t1yplst, tyerr_pool), e0xp):<cloref1>
    (e1xplst, t1yplst, tyerr_pool) = let
    val (e1xp, tyerrs) = oftype (Gamma, e0xp)
    val e1xps = e1xp :: init.0
    val t1yps = e1xp.e1xp_typ :: init.1
    val tyerrs = tyerr_pool_append (init.2, tyerrs)
  in
    (e1xps, t1yps, tyerrs)
  end
  val (e1xps, t1yps, tyerrs) = list0_fold_left (helper, (nil, nil, tyerr_pool_nil), e0xps)
  val e1xps = list0_reverse (e1xps)
  val t1yps = list0_reverse (t1yps)
in
  (e1xp_make_tup (loc, e1xps, T1YPtup (t1yps)), tyerrs)
end

fun oftype_var (Gamma: ctx, loc: loc, nam: symbol_t): (e1xp, tyerr_pool) = let
  val v1aropt = symenv_lookup<v1ar> (Gamma, nam)
in
  case+ v1aropt of
  | Some0 v1ar => (e1xp_make_var (loc, v1ar), tyerr_pool_nil)
  | None0 () => let
    val () = prerr_loc (loc)
    val () = prerr ": no such var"
    val () = prerr_newline ()
    val errmsg = "oftype_var: no such var"
    (* no such var, assume it is int *)
    val v1ar = v1ar_make (loc, nam, t1yp_int)
  in
    (e1xp_make_var (loc, v1ar), tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
  end
end

fun oftype_fix (Gamma: ctx, loc: loc, 
  nam: symbol_t, paras: a0rglst, retopt: t0ypopt, body: e0xp): (e1xp, tyerr_pool) = let
  val (Gamma1, args, t1yps, tyerrs1) = oftyp_arglst (Gamma, paras)
  (* If there is only one argument, then the input type is not a tuple. *)
  val t1yp_args = if list0_length (t1yps) = 1 then let
      val- cons (t1yp_arg, _) = t1yps in t1yp_arg end
    else T1YPtup (t1yps)
  
  val (fixtyp, retty) = (case+ retopt of
    | Some0 retty => let
      val retty = trans1_typ (retty)
    in
      (T1YPfun (t1yp_args, retty), retty)
    end
    | None0 () => let
      val () = prerr_loc (loc)
      val () = prerr ": oftype_fix, return type not specified, int assumed"
      val () = prerr_newline ()
      val errmsg = "oftype_fix, return type not specified, int assumed"    
      val retty = t1yp_int
    in
      (* no such var, assume it is int *)
      (T1YPfun (t1yp_args, retty), retty)
    end
  )

  val f_v1ar = v1ar_make (loc, nam, fixtyp)
  val Gamma2 = symenv_insert (Gamma1, nam, f_v1ar)
  val (e1xp_body, tyerrs2) = typcheck (Gamma2, body, retty)

  val e1xpfix = e1xp_make_fix (loc, f_v1ar, args, e1xp_body, fixtyp)
  val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
in
  (e1xpfix, tyerrs)
end

fun oftype_app (Gamma: ctx, loc: loc, f: e0xp, args: e0xp): (e1xp, tyerr_pool) = let
  val (f, tyerrs) = oftype (Gamma, f)
in
  case+ f.e1xp_typ of
  | T1YPfun (paras_typ, ret_typ) => let
    val (args, tyerrs) = typcheck (Gamma, args, paras_typ)
    val e1xp = e1xp_make_app (loc, f, args, ret_typ)
  in
    (e1xp, tyerrs)
  end
  | _ => let
    val () = prerr_loc (loc)
    val () = prerr ": error(type) ... expected a function type"
    val () = prerr " ... actual: "
    val () = fprint_t1yp (stderr_ref, f.e1xp_typ)
    val () = prerr_newline ()
    val errmsg = "function type needed"
  in
    (* return f as the result as app *)
    (f, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
  end
end
  
implement oftype (Gamma, e0) = let
  val e0_node = e0.e0xp_node
  val e0_loc = e0.e0xp_loc
in
  case+ e0_node of
  | E0XPann (e0a, t0a) => oftype_ann (Gamma, e0_loc, e0a, t0a)
  | E0XPapp (e0fun, e0args) => oftype_app (Gamma, e0_loc, e0fun, e0args)
  | E0XPbool (b) => (e1xp_make_bool (e0_loc, b), tyerr_pool_nil)
  | E0XPfix (f, paras, t0ypopt, body) => oftype_fix (Gamma, e0_loc, f, paras, t0ypopt, body)
  | E0XPif (e0_if, e0_then, e0opt_else) => 
    oftype_if (Gamma, e0_loc, e0_if, e0_then, e0opt_else)
  | E0XPint (i) => (e1xp_make_int (e0_loc, i), tyerr_pool_nil)
  | E0XPlam (a0rgs, t0ypopt, e0xp) => oftype_lam (Gamma, e0_loc, a0rgs, t0ypopt, e0xp)
  | E0XPlet (d0eclst_local, e0_body) => 
    oftype_let (Gamma, e0_loc, d0eclst_local, e0_body)
  | E0XPopr (opr, e0xps) => oftype_opr (Gamma, e0_loc, opr, e0xps)
  | E0XPproj (e0xp, i) => oftype_proj (Gamma, e0_loc, e0xp, i)
  | E0XPstr (str) => (e1xp_make_str (e0_loc, str), tyerr_pool_nil)
  | E0XPtup (e0xps) => oftype_tup (Gamma, e0_loc, e0xps)
  | E0XPvar (nam) => oftype_var (Gamma, e0_loc, nam)
  // | _ => ETRACE_MSG_OPR ("oftype: error unexpected\n", ETRACE_LEVEL_ERROR, 
  //           abort (ERRORCODE_FORBIDDEN))
end

implement typcheck (Gamma, e0, t1) = let
  val (e1, tyerrs) = oftype (Gamma, e0)
  val ty_cmp = lte_t1yp_t1yp (e1.e1xp_typ, t1)
in
  if ty_cmp = true then (e1, tyerrs)
  else let
    val () = prerr_loc (e1.e1xp_loc)
    val () = prerr ": error(type) ... expected: "
    val () = fprint_t1yp (stderr_ref, t1)
    val () = prerr " ... actual: "
    val () = fprint_t1yp (stderr_ref, e1.e1xp_typ)
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


