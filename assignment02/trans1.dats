(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans1.sats"
typedef loc = $Posloc.location_t
macdef location_none = $Posloc.location_none
macdef prerr_loc = $Posloc.prerr_location
macdef fprint_location = $Posloc.fprint_location

(* ****** ****** *)

staload "error.sats"
staload "symbol.sats"
typedef sym = symbol_t


staload "absyn.sats"

(* ****** ****** *)

(* library functions *)
staload "libfunctions.sats"

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

implement t1yp_bool = T1YPbase symbol_BOOL
implement t1yp_int = T1YPbase symbol_INT
implement t1yp_string = T1YPbase symbol_STRING
implement t1yp_unit = T1YPtup (list0_nil)

(* ****** ****** *)

(* fun trans1_build_err (t_act: t1yp, t_expect: t1yp): String *)
implement trans1_build_err (t_act, t_expect) = let
  val msg = "typematch failed ... expected: " +
    tostring_t1yp (t_expect) + " ... actual: " + 
    tostring_t1yp (t_act)
in
  msg
end
(* ****** ****** *)
local

assume t1Var = '{
  nam= int, lnk= ref (t1yp)
} // end of [t1Var]

val count = ref<int> (0)

in

implement t1Var_get_nam (X) = X.nam
implement t1Var_get_typ (X) = !(X.lnk)
implement t1Var_set_typ (X, t) = !(X.lnk) := t

implement t1Var_new (): t1Var = let
  val n = !count; val () = !count := n+1
in '{
  nam= n, lnk= ref (T1YPdummy)
} end // [t1Var_new]

end // end of [local]

fun eq_t1Var_t1Var
  (X1: t1Var, X2: t1Var): bool =
  t1Var_get_nam (X1) = t1Var_get_nam (X2)
overload = with eq_t1Var_t1Var

fun neq_t1Var_t1Var
  (X1: t1Var, X2: t1Var): bool = ~(X1 = X2)
overload <> with neq_t1Var_t1Var
(* ****** ****** *)

abstype tyerr
typedef tyerr_pool = list0 tyerr
(* record all the error for future output *)
extern fun tyerr_pool_add (pool: tyerr_pool, loc: loc, msg: string): tyerr_pool
symintr tyerr_pool_add_tail
extern fun tyerr_pool_add_tail_loc (pool: tyerr_pool, loc: loc, msg: string): tyerr_pool
extern fun tyerr_pool_add_tail_noloc (pool: tyerr_pool, msg: string): tyerr_pool
overload tyerr_pool_add_tail with tyerr_pool_add_tail_loc
overload tyerr_pool_add_tail with tyerr_pool_add_tail_noloc
extern fun tyerr_pool_append (p1: tyerr_pool, p2: tyerr_pool): tyerr_pool
extern fun tyerr_pool_make (): tyerr_pool
extern fun tyerr_pool_size (pool: tyerr_pool): int

extern fun fprint_tyerr_pool (out: FILEref, pool: tyerr_pool): void
extern fun print_tyerr_pool (pool: tyerr_pool): void
extern fun prerr_tyerr_pool (pool: tyerr_pool): void

extern fun fprint_tyerr (out: FILEref, tyerr: tyerr): void
extern fun print_tyerr (tyerr: tyerr): void
extern fun prerr_tyerr (tyerr: tyerr): void

local
assume tyerr = '{loc = loc, msg = string}
in
implement tyerr_pool_add (pool, loc, msg) = 
  '{loc = loc, msg = msg} :: pool

implement tyerr_pool_add_tail_loc (pool, loc, msg) = 
  tyerr_pool_append (pool, '{loc = loc, msg = msg} :: nil)

implement tyerr_pool_add_tail_noloc (pool, msg) = 
  tyerr_pool_append (pool, '{loc = location_none, msg = msg} :: nil)

implement tyerr_pool_size (pool) =
  list0_length (pool)

implement tyerr_pool_append (p1, p2) = list0_append (p1, p2)

implement tyerr_pool_make () = nil

implement fprint_tyerr_pool (out, pool) = aux (out, pool, 0) where {
  fun aux (out: FILEref, pool: tyerr_pool, i: int): void = 
    case+ pool of
    | cons (tyerr, pool1) => (
      fprint_tyerr (out, tyerr);
      (*if (i > 0) then*) fprint (out, "\n");
      aux (out, pool1, i + 1))
    | nil () => ()
}

implement print_tyerr_pool (pool) = fprint_tyerr_pool (stdout_ref, pool)
implement prerr_tyerr_pool (pool) = fprint_tyerr_pool (stderr_ref, pool)

implement fprint_tyerr (out, tyerr) = () where {
  // todo cannot print location, should use out
  // val () = print_location (tyerr.loc)
  val _ = fprint (out, "???@" + tyerr.msg)
} 

implement print_tyerr (tyerr: tyerr) = fprint_tyerr (stdout_ref, tyerr)
implement prerr_tyerr (tyerr: tyerr) = fprint_tyerr (stderr_ref, tyerr)

end  // end of [local]

val tyerr_pool_nil = tyerr_pool_make ()  // empty error pool
(* ******** ********* *)

implement
trans1_typ (t) = aux (t) where {
  fun aux (t: t0yp): t1yp = case+ t.t0yp_node of
    | T0YPbase sym => begin case+ 0 of
        | _ when sym = symbol_UNIT => t1yp_unit 
        | _ when sym = symbol_LIST => let
          val t1var = t1Var_new ()
          val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
        in
          T1YPlist (t1var) // list X
        end
        | _ => T1YPbase sym
      end // end of [T0YPbase]  
    | T0YPfun (t1, t2) => T1YPfun (ref ~1(*don't know the no. of args yet*), 
                                   aux t1, aux t2)
    | T0YPtup (ts) => T1YPtup (list0_map_fun (ts, aux))
  // end of [aux]
} // end of [trans1_typ]   

(* ****** ****** *)
(*
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
*)

(* ****** ****** *)
(* The result can be
1. T1YPvar with dummy inside (one level)
2. commond type
// -------------
We have three boxes: x, y, z
(x:int, ref (y:int, ref (z:int, ref dummy))) becomes
(x:int, ref (z:int, ref dummy))
(y:int, ref (z:int, ref dummy))
(z:int, ref dummy)
// -------------
returen value is (z, dummy)
*)
implement t1yp_normalize (t) = 
  case+ t of
  | T1YPvar (X) => let
      val t1 = t1Var_get_typ (X)
    in
      case+ t1 of
      | T1YPdummy () => t
      | _ => t1 where {
          val t1 = t1yp_normalize (t1)
          val () = t1Var_set_typ (X, t1)
          // we return t1, but modify t as well
          // In effect, suppose we have a box (T1YPvar), if it 
          // contains dummy, then we do nothing and return the box.
          // If the box contains something else, we normalize this
          // content, put the new content back to the box, and return
          // the new content as the result of normalization of the box.
        } // [_]
    end // end of [T1YPvar]
  | T1YPlist (X) => let
    val t1 = t1Var_get_typ (X)
  in
      case+ t1 of
      | T1YPdummy () => t
      | _ => t where {
          val t1 = t1yp_normalize (t1)
          val () = t1Var_set_typ (X, t1)
        } // [_]
  end  // end of [T1YPlist]
    
  | _ => t // end of [_]
// end of [t1yp_normalize]


fun t1yp_lst_normalize (ts: t1yplst): t1yplst = 
  list0_map_fun<t1yp><t1yp> (ts, t1yp_normalize)

fun make_t1ypvar_lst (n: int): list0 t1yp =
  if n = 0 then nil ()
  else cons (T1YPvar (t1Var_new ()), make_t1ypvar_lst (n - 1))

(* ****** ****** *)
(* if we only use this match, then there would be
no indented T1YPvar
*)
(* t1: the actual type of the exp
   t2: the type it should be
*)
fun match_t1yp_t1yp
  (t1: t1yp, t2: t1yp, tyerrs: tyerr_pool): (bool, tyerr_pool) = let
  val t1 = t1yp_normalize (t1)
  val t2 = t1yp_normalize (t2)
  // val () = fprint (stderr_ref, "=============match_t1yp_t1yp\n")
in
  case+ (t1, t2) of
  | (T1YPvar X1, T1YPvar X2) => (true, tyerrs) where {
      val () = if X1 <> X2 then t1Var_set_typ (X1, t2)
    } // end of [T1YPvar, T1YPvar]
  | (T1YPvar X1, _) => (t1Var_set_typ (X1, t2); (true, tyerrs))
  | (_, T1YPvar X2) => (t1Var_set_typ (X2, t1); (true, tyerrs))
//
  | (T1YPbase sym1, T1YPbase sym2) => 
    if sym1 = sym2 then (true, tyerrs) else let
      val errmsg = trans1_build_err (t1, t2)
      val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
    in
      (false, tyerrs1)
    end
  | (T1YPfun (n1, t11, t12), T1YPfun (n2, t21, t22)) => let
      val () = if !n1 = ~1 then !n1 := !n2
      val () = if !n2 = ~1 then !n2 := !n1
      val (b1, tyerrs1) = match_t1yp_t1yp (t11, t21, tyerrs)
      val (b2, tyerrs2) = match_t1yp_t1yp (t12, t22, tyerrs1)
    in
      ((!n1 = !n2) && b1 && b2, tyerrs2)
    end // end of [T1YPfun, T1YPfun]
  | (T1YPtup ts1, T1YPtup ts2) => match_t1yplst_t1yplst (ts1, ts2, true, tyerrs)
  | (T1YPtup_vl rfts1, T1YPtup ts2) => let 
    val ts1 = !rfts1
    val len1 = list0_length (ts1)
    val len2 = list0_length (ts2)
    val ts1 = (if len1 >= len2 then ts1 else 
      list0_append<t1yp> (ts1, make_t1ypvar_lst (len2 - len1))
    )
    val res = match_t1yplst_t1yplst_l (ts1, ts2, true, tyerrs)
    val ts1 = t1yp_lst_normalize (ts1)
    val () = !rfts1 := ts1
  in
    res
  end
  | (T1YPtup ts1, T1YPtup_vl rfts2) => let 
    val ts2 = !rfts2
    val len1 = list0_length (ts1)
    val len2 = list0_length (ts2)
    val ts2 = (if len1 <= len2 then ts2 else 
      list0_append<t1yp> (ts2, make_t1ypvar_lst (len1 - len2))
    )
    val res = match_t1yplst_t1yplst (ts1, ts2, true, tyerrs)
    val ts2 = t1yp_lst_normalize (ts2)
    val () = !rfts2 := ts2
  in
    res
  end
  | (T1YPtup_vl rfts1, T1YPtup_vl rfts2) => let 
    val ts1 = !rfts1
    val ts2 = !rfts2
    val len1 = list0_length (ts1)
    val len2 = list0_length (ts2)
    val (ts1, ts2) = (if len1 <= len2 then 
      (list0_append<t1yp> (ts1, make_t1ypvar_lst (len2 - len1)), ts2)
    else
      (ts1, list0_append<t1yp> (ts2, make_t1ypvar_lst (len1 - len2)))
    )
    val res = match_t1yplst_t1yplst (ts1, ts2, true, tyerrs)
    val ts1 = t1yp_lst_normalize (ts1)
    val ts2 = t1yp_lst_normalize (ts2)
    val () = !rfts1 := ts1
    val () = !rfts2 := ts2
  in
    res
  end
  | (T1YPlist X1, T1YPlist X2) => let
    val t1 = t1Var_get_typ (X1)
    val t2 = t1Var_get_typ (X2)
  in
    match_t1yp_t1yp (t1, t2, tyerrs)
  end
  | (T1YPlist _, _) => let
    val errmsg = trans1_build_err (t1, t2)
    val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
  in (false, tyerrs1) end
  | (_, T1YPlist _) => let
    val errmsg = trans1_build_err (t1, t2)
    val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
  in (false, tyerrs1) end
  | (_, _) => let
    val errmsg = trans1_build_err (t1, t2)
    val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
  in (false, tyerrs1) end
end // end of [match_t1yp_t1yp]

and match_t1yplst_t1yplst (
  ts1: t1yplst, ts2: t1yplst, res: bool, tyerrs: tyerr_pool
) : (bool, tyerr_pool) =
  case+ (ts1, ts2) of
  | (list0_cons (t1, ts1),
     list0_cons (t2, ts2)) => let
      val (res1, tyerrs1) = match_t1yp_t1yp (t1, t2, tyerrs)
      val res = (
        if res1 then res else false
      ) : bool
    in
      match_t1yplst_t1yplst (ts1, ts2, res, tyerrs1)
    end // end of [list0_cons, list0_cons]
  | (list0_nil (), list0_nil ()) => (res, tyerrs)
  | (_, _) => let
    val errmsg = "two type lists are not of the size length"
    val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
  in
    (false, tyerrs1)
  end
// end of [lte_t1yplst_t1yplst]

(* it's O.K. if the left is longer than the right *) 
and match_t1yplst_t1yplst_l (
  ts1: t1yplst, ts2: t1yplst, res: bool, tyerrs: tyerr_pool
) : (bool, tyerr_pool) =
  case+ (ts1, ts2) of
  | (list0_cons (t1, ts1),
     list0_cons (t2, ts2)) => let
      val (res1, tyerrs1) = match_t1yp_t1yp (t1, t2, tyerrs)
      val res = (
        if res1 then res else false
      ) : bool
    in
      match_t1yplst_t1yplst_l (ts1, ts2, res, tyerrs1)
    end // end of [list0_cons, list0_cons]
  | (_, list0_nil ()) => (res, tyerrs)
  | (_, _) => let
    val errmsg = "expecting longer list"
    val tyerrs1 = tyerr_pool_add_tail (tyerrs, errmsg)
  in
    (false, tyerrs1)
  end
// end of [lte_t1yplst_t1yplst]

(* ****** ****** *)
implement
v1ar_make (loc, sym, t) = '{
  v1ar_loc= loc, v1ar_nam= sym, v1ar_typ= t, 
  v1ar_def= ref_make_elt<option0 e1xp> (None0), v1ar_val = ref<option0 valprim_t>(None0)
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
  e1xp_loc= loc, 
  e1xp_node = E1XPfix (f, xs, body, ref_make_elt<v1arlst> (nil)), 
  e1xp_typ= t_fun
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
  e1xp_loc= loc, 
  e1xp_node = E1XPlam (xs, body, ref_make_elt<v1arlst> (nil)),
  e1xp_typ= t_fun
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

// v1ar is defined in trans1.sats
extern typedef "v1ar_t" = v1ar

(* can be deleted? *)
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
      val def = valdec.v0aldec_def
      val tyerrs1 = tyerr_pool_nil

      val (t1yp, tyerrs1) = // peak the definition
        case+ e0xp_node_is_fun (def.e0xp_node) of
        | Some0 fnt1yp => 
          (case+ valdec.v0aldec_ann of
          | Some0 t0yp => let
            val ann_t1yp = trans1_typ (t0yp)
            val (bmatch, tyerrs1) = match_t1yp_t1yp (fnt1yp, ann_t1yp, tyerrs1)
            val tyerrs1 = if bmatch <> true then let
              val errmsg = trans1_build_err (fnt1yp, ann_t1yp)
            in 
              tyerr_pool_add_tail (tyerrs1, loc, errmsg)
            end else tyerrs1
          in
            (fnt1yp, tyerrs1)
          end
          | None0 () => (fnt1yp, tyerrs1)
          ): (t1yp, tyerr_pool)
        | None0 () =>  // not a function
          (case+ valdec.v0aldec_ann of
          | Some0 t0yp => (trans1_typ (t0yp), tyerrs1)
          | None0 () => (T1YPvar (t1Var_new ()), tyerrs1)
          ): (t1yp, tyerr_pool)

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
    val v1ar = v1ar_make (loc, nam, T1YPvar (t1Var_new ()))
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1ar, tyerr_pool_nil)
  end
    (*let  serve as comment
    val () = prerr_loc (loc)
    val () = prerr ": arg must have type"
    val () = prerr_newline ()
    val errmsg = "arg must have type"

    (* assume the type is int *)
    val v1ar = v1ar_make (loc, nam, t1yp_int)
    val Gamma1 = symenv_insert (Gamma, nam, v1ar)
  in
    (Gamma1, v1ar, tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
  end *)
end

fun oftype_lam (Gamma: ctx, loc: loc, a0rgs: a0rglst, t0ypopt: t0ypopt, e0xp: e0xp):
  (e1xp, tyerr_pool) = let
  val (Gamma1, v1ars, t1yps, tyerrs1) = oftyp_arglst (Gamma, a0rgs)
  val args = list0_length (t1yps)
  (* If there is only one argument, then the input type is not a tuple. *)
  val t1yp_args = if args = 1 then let
      val- cons (t1yp_arg, _) = t1yps in t1yp_arg end
    else T1YPtup (t1yps)
in
  case+ t0ypopt of
  | Some0 t0yp => let
    val t1yp = trans1_typ (t0yp)
    val (e1xp_body, tyerrs2) = typcheck (Gamma1, e0xp, t1yp)
    val e1xp_lam = e1xp_make_lam (loc, v1ars, e1xp_body, 
             T1YPfun (ref_make_elt<int> (args), t1yp_args, t1yp))
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
  in
    (e1xp_lam, tyerrs2)
  end
  | None0 () => let
    val (e1xp_body, tyerrs2) = oftype (Gamma1, e0xp)
    val e1xp_lam = e1xp_make_lam (loc, v1ars, e1xp_body, 
         T1YPfun (ref_make_elt<int> (args), t1yp_args, e1xp_body.e1xp_typ))
    val tyerrs = tyerr_pool_append (tyerrs1, tyerrs2)
  in
    (e1xp_lam, tyerrs2)
  end
end

fun oftype_opr (Gamma: ctx, loc: loc, opr: opr, e0xps: e0xplst): (e1xp, tyerr_pool) = let
  val t1yp_opt = libOprTypFind (opr)
in
  case+ t1yp_opt of
  | Some0 t1yp_opr => (
    case+ t1yp_opr of
    | T1YPfun (_, t1yp_args, t1yp_ret) => let
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
    )
  | None0 () => ETRACE_MSG_OPR (
      "oftype_opr: (no such operator should not happen\n", ETRACE_LEVEL_ERROR,
      abort (ERRORCODE_FORBIDDEN))
end

fun oftype_proj (Gamma: ctx, loc: loc, e0xp: e0xp, i: int): (e1xp, tyerr_pool) = let
  val (e1xp, tyerrs) = oftype (Gamma, e0xp)
  (* normalize first *)
  val t = t1yp_normalize (e1xp.e1xp_typ)
in
  case+ t of
  | T1YPtup (t1yps) => let
    val t1ypopt = list0_nth_opt<t1yp> (t1yps, i)
  in
    case+ t1ypopt of
    | Some0 t1ypitem => (e1xp_make_proj (loc, e1xp, i, t1ypitem), tyerrs)
    | None0 () => let
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
  | T1YPvar (t1var) => let
    val t1varlst = make_t1ypvar_lst (i + 1)
    val- Some0 (t1ypitem) = list0_nth_opt (t1varlst, i)
    val () = t1Var_set_typ (t1var, T1YPtup_vl (ref<t1yplst> (t1varlst)))
  in
    (e1xp_make_proj (loc, e1xp, i, t1ypitem), tyerr_pool_nil)
  end
  | T1YPtup_vl (rft1yps) => let
    val t1yps = !rft1yps
    val len = list0_length (t1yps)
  in
    if len > i then let
      val- Some0 (t1ypitem) = list0_nth_opt (t1yps, i)
    in
      (e1xp_make_proj (loc, e1xp, i, t1ypitem), tyerr_pool_nil)
    end else let
      val t1varlst = make_t1ypvar_lst (i + 1 - len)
      (* get the last one *)
      val- Some0 (t1ypitem) = list0_nth_opt (t1varlst, i - len)
      val t1yps = list0_append (t1yps, t1varlst)
      val () = !rft1yps := t1yps
    in
      (e1xp_make_proj (loc, e1xp, i, t1ypitem), tyerr_pool_nil)
    end
  end
  | _ => let
    (* not tuple: use whatever type it has *)
    val e1xp_proj = e1xp_make_proj (loc, e1xp, i, e1xp.e1xp_typ)
    // val () = prerr_loc (loc)
    // val () = prerr ": projection on non-tuple type"
    // val () = prerr_newline ()
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
  // current environment
  val v1aropt = symenv_lookup<v1ar> (Gamma, nam)
in
  case+ v1aropt of
  | Some0 v1ar => (e1xp_make_var (loc, v1ar), tyerr_pool_nil)
  | None0 () => let
    // library function / operator
    val t1yp_opt = libSymTypFind (nam)
  in
    case+ t1yp_opt of
    | Some0 t1yp => (e1xp_make_var (loc, v1ar_make (loc, nam, t1yp)), 
                     tyerr_pool_nil)
    | None0 () => let
      // val () = prerr_loc (loc)
      // val () = prerr ": no such var"
      // val () = prerr_newline ()
      val errmsg = "oftype_var: no such var, assuming its type is int"
      (* no such var, assume it is int *)
      val v1ar = v1ar_make (loc, nam, t1yp_int)
    in
      (e1xp_make_var (loc, v1ar), tyerr_pool_add (tyerr_pool_nil, loc, errmsg))
    end
  end
end

fun oftype_fix (Gamma: ctx, loc: loc, 
  nam: symbol_t, paras: a0rglst, retopt: t0ypopt, body: e0xp): (e1xp, tyerr_pool) = let
  val (Gamma1, args, t1yps, tyerrs1) = oftyp_arglst (Gamma, paras)
  val nargs = list0_length (t1yps)
  (* If there is only one argument, then the input type is not a tuple. *)
  val t1yp_args = if nargs = 1 then let
      val- cons (t1yp_arg, _) = t1yps in t1yp_arg end
    else T1YPtup (t1yps)
  
  val (fixtyp, retty) = (case+ retopt of
    | Some0 retty => let
      val retty = trans1_typ (retty)
    in
      (T1YPfun (ref_make_elt<int> (nargs), t1yp_args, retty), retty)
    end
    | None0 () => let
      val retty = T1YPvar (t1Var_new ())
    in
      (T1YPfun (ref_make_elt<int> (nargs), t1yp_args, retty), retty)
    end
    (*let
      val () = prerr_loc (loc)
      val () = prerr ": oftype_fix, return type not specified, int assumed"
      val () = prerr_newline ()
      val errmsg = "oftype_fix, return type not specified, int assumed"    
      val retty = t1yp_int
    in
      (* no such var, assume it is int *)
      (T1YPfun (t1yp_args, retty), retty)
    end*)
    
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
  val (f, tyerrs_f) = oftype (Gamma, f)
  (* do the normalization first *)
  val e1xp_fun = t1yp_normalize (f.e1xp_typ)
in
  case+ e1xp_fun of
  | T1YPfun (_, paras_typ, ret_typ) => let
    val (args, tyerrs_args) = typcheck (Gamma, args, paras_typ)
    val tyerrs = tyerr_pool_append (tyerrs_f, tyerrs_args)
    val e1xp = e1xp_make_app (loc, f, args, ret_typ)
  in
    (e1xp, tyerrs)
  end
  | T1YPvar (t1var) => let
    val () = prerr ": ============================\n"
    val () = prerr ": You should not see me.\n"
    val (args, tyerrs_args) = oftype (Gamma, args)
    val tyerrs = tyerr_pool_append (tyerrs_f, tyerrs_args)
    val ret_typ = T1YPvar (t1Var_new ())
    val ty_fun = T1YPfun (ref_make_elt<int> (~1), args.e1xp_typ, ret_typ)
    val () = t1Var_set_typ (t1var, ty_fun)
    val e1xp = e1xp_make_app (loc, f, args, ret_typ)
    // val _ = t1yp_normalize (f.e1xp_typ)  unnecessary, let others do this
  in
    (e1xp, tyerrs)
  end
  | _ => let
    // val () = prerr_loc (loc)
    // val () = prerr ": error(type) ... expected a function type"
    // val () = prerr " ... actual: "
    // val () = fprint_t1yp (stderr_ref, f.e1xp_typ)
    // val () = prerr_newline ()
    val errmsg = "function type needed" + ("... actual is ": string)
    val errmsg = errmsg + (tostring_t1yp e1xp_fun)
  in
    (* return f as the result as app *)
    (f, tyerr_pool_add_tail (tyerrs_f, loc, errmsg))
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

(* fun e0xp_node_is_fun (e_node: e0xp_node): option0 t1yp *)
(* take the type from the function definition *)
implement e0xp_node_is_fun (e_node) =
  case+ e_node of
  | E0XPann (e1, _) => e0xp_node_is_fun (e1.e0xp_node)
  | E0XPfix (_, a0rgs, t0ypopt, _) => let
    val args = list0_length (a0rgs)
    
    // (ctx, v1arlst, t1yplst, tyerr_pool)
    val (ctx, _, t1yps, _) = oftyp_arglst (ctx_nil, a0rgs)  
    val argst1yp = (if args = 1 then let
        val- cons (t1yp, _) = t1yps in t1yp end
      else T1YPtup t1yps): t1yp
      
    val rett1yp = case+ t0ypopt of
    | Some0 t0yp => trans1_typ (t0yp)
    | None0 () => T1YPvar (t1Var_new ())
    val fixt1yp = T1YPfun (ref_make_elt<int> (args), argst1yp, rett1yp)
  in
    Some0 fixt1yp
  end
  | E0XPlam (a0rgs, t0ypopt, _) => let
    val args = list0_length (a0rgs)
    
    // (ctx, v1arlst, t1yplst, tyerr_pool)
    val (ctx, _, t1yps, _) = oftyp_arglst (ctx_nil, a0rgs)  
    val argst1yp = (if args = 1 then let
        val- cons (t1yp, _) = t1yps in t1yp end
      else T1YPtup t1yps): t1yp
      
    val rett1yp = case+ t0ypopt of
    | Some0 t0yp => trans1_typ (t0yp)
    | None0 () => T1YPvar (t1Var_new ())
    val lamt1yp = T1YPfun (ref_make_elt<int> (args), argst1yp, rett1yp)
  in
    Some0 lamt1yp
  end
  | _ => None0

(* fun e1xp_node_is_fun (e_node: e1xp_node): bool *)
implement e1xp_node_is_fun (e_node) =
  case+ e_node of
  | E1XPann (e1, _) => e1xp_node_is_fun (e1.e1xp_node)
  | E1XPfix (_, _, _, _) => true
  | E1XPlam (_, _, _) => true
  | _ => false

(* fun e1xp_node_fun_get_env (e_node: e1xp_node): option0 v1arlst *)
implement e1xp_node_fun_get_env (e_node) =
  case+ e_node of
  | E1XPann (e1, _) => e1xp_node_fun_get_env (e1.e1xp_node)
  | E1XPfix (_, _, _, env_ref) => Some0 !env_ref
  | E1XPlam (_, _, env_ref) => Some0 !env_ref
  | _ => None0

implement typcheck (Gamma, e0, t1) = let
  val (e1, tyerrs) = oftype (Gamma, e0)

  // val () = fprint (stderr_ref, "=============typcheck@")
  // val () = prerr_loc (e1.e1xp_loc)
  // val () = prerr " ... expected: "
  // val () = fprint_t1yp (stderr_ref, t1)
  // val () = prerr " ... actual: "
  // val () = fprint_t1yp (stderr_ref, e1.e1xp_typ)
  // val () = prerr_newline ()
  
  val (ty_cmp, tyerrs) = match_t1yp_t1yp (e1.e1xp_typ, t1, tyerrs)
in
  if ty_cmp = true then (e1, tyerrs)
  else let
    // val () = prerr_loc (e1.e1xp_loc)
    // val () = prerr ": error(type) ... expected: "
    // val () = fprint_t1yp (stderr_ref, t1)
    // val () = prerr " ... actual: "
    // val () = fprint_t1yp (stderr_ref, e1.e1xp_typ)
    // val () = prerr_newline ()
    val errmsg = trans1_build_err (e1.e1xp_typ, t1)
  in
    (e1, tyerr_pool_add_tail (tyerrs, e1.e1xp_loc, errmsg))
  end
end

(* auxilliary function for list opertation *)
fun {a:t@ype} list_scan_accu (xs: list0 a, scanner: a -> (a, int)): 
  (list0 a, int) = let
  fun loop (xs: list0 a, scanner: a -> (a, int), accu1: list0 a, accu2: int): 
  (list0 a, int) =
    case+ xs of
    | cons (x, xs1) => let
      val (x, amb) = scanner x
    in
      loop (xs1, scanner, cons (x, accu1), accu2 + amb)
    end
    | nil () => (accu1, accu2)
  
  val (xs, amb) = loop (xs, scanner, nil (), 0)
  val xs = list0_reverse (xs)
in
  (xs, amb)
end

(* ret value:
   0: no ambiguity
   > 0: has ambiguity
*)
extern fun t1yp_finalize (t: t1yp): (t1yp, int)

fun t1yp_lst_finalize (ts: t1yplst): (t1yplst, int) =
  list_scan_accu (ts, t1yp_finalize)

implement t1yp_finalize (t) = let
  val t1 = t1yp_normalize (t)
in
  case+ t1 of
  | T1YPbase (x) => (t1, 0)
  | T1YPfun (x, args, ret) => let
    val (args, amb1) = t1yp_finalize (args)
    val (ret, amb2) = t1yp_finalize (ret)
  in
    (T1YPfun (x, args, ret), amb1 + amb2)
  end
  | T1YPtup (t1yps) => let
    val (t1yps, amb) = t1yp_lst_finalize (t1yps)
  in
    (T1YPtup (t1yps), amb)
  end
  | T1YPtup_vl (ref_t1yps) => let
    val (t1yps, amb) = t1yp_lst_finalize (!ref_t1yps)
  in
    (T1YPtup (t1yps), amb)
  end
  | T1YPvar (_) => (t1, 1)
  | T1YPdummy () => ETRACE_MSG_OPR ("t1yp_finalize T1YPdummy is found\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
  | T1YPlist (X) => let
    val t = t1Var_get_typ (X)
    val (t, amb) = t1yp_finalize (t)
    val () = t1Var_set_typ (X, t)
  in
    (t1, amb)
  end
end // end of [t1yp_finalize]

(* remove T1YPtup_vl and T1YPvar, T1YPdummy *)
(* return value:
     0: O.K.
     not 0: ambiguity
*)
// Caution: This function creates a new e1xp, which shares nothing with the old one.
extern fun e1xp_t1yp_finalize (e: e1xp): (e1xp, int)
fun e1xp_lst_t1yp_finalize (es: e1xplst): (e1xplst, int) = 
  list_scan_accu (es, e1xp_t1yp_finalize)

extern fun e1xpopt_t1yp_finalize (eopt: e1xpopt): (e1xpopt, int)

extern fun v1ar_t1yp_finalize (v: v1ar): (v1ar, int)
fun v1ar_lst_t1yp_finalize (vs: v1arlst): (v1arlst, int) =
  list_scan_accu (vs, v1ar_t1yp_finalize)

extern fun d1ec_t1yp_finalize (dec: d1ec): (d1ec, int)
fun d1eclst_t1yp_finalize (decs: d1eclst): (d1eclst, int) =
  list_scan_accu (decs, d1ec_t1yp_finalize)

extern fun v1aldec_t1yp_finalize (v1aldec: v1aldec): (v1aldec, int)
fun v1aldec_lst_t1yp_finalize (v1aldecs: v1aldeclst): (v1aldeclst, int) =
  list_scan_accu (v1aldecs, v1aldec_t1yp_finalize)

implement e1xp_make (loc, node, t1yp) =
  '{e1xp_loc = loc, e1xp_node = node, e1xp_typ = t1yp}

implement e1xp_t1yp_finalize (e) = let
  val e1_loc  = e.e1xp_loc
  val e1_node = e.e1xp_node
  val e1_typ  = e.e1xp_typ
  val (e1_typ, amb) = t1yp_finalize (e1_typ)
in
  case+ e1_node of
  | E1XPann (e1a, t1a) => let
    val (t1a, amb_t) = t1yp_finalize (t1a)
    val (e1a, amb_e) = e1xp_t1yp_finalize (e1a)
    val e1_node = E1XPann (e1a, t1a)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb_t + amb_e)
  end
  | E1XPapp (e1fun, e1args) => let
    val (e1fun, amb1) = e1xp_t1yp_finalize (e1fun)
    val (e1args, amb2) = e1xp_t1yp_finalize (e1args)
    val e1_node = E1XPapp (e1fun, e1args)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2)
  end
  | E1XPbool (_) => (e1xp_make (e1_loc, e1_node, e1_typ), amb)
  | E1XPfix (f, args, body, esc) => let
    val (f, amb1) = v1ar_t1yp_finalize (f)
    val (args, amb2) = v1ar_lst_t1yp_finalize (args)
    val (body, amb3) = e1xp_t1yp_finalize (body)
    val e1_node = E1XPfix (f, args, body, esc)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2 + amb3)
  end
  | E1XPif (e1_if, e1_then, e1opt_else) => let
    val (e1_if, amb1) = e1xp_t1yp_finalize (e1_if)
    val (e1_then, amb2) = e1xp_t1yp_finalize (e1_then)
    val (e1opt_else, amb3) = e1xpopt_t1yp_finalize (e1opt_else)
    val e1_node = E1XPif (e1_if, e1_then, e1opt_else)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2 + amb3)
  end
  | E1XPint (_) => (e1xp_make (e1_loc, e1_node, e1_typ), amb)
  | E1XPlam (args, body, esc) => let
    val (args, amb1) = v1ar_lst_t1yp_finalize (args)
    val (body, amb2) = e1xp_t1yp_finalize (body)
    val e1_node = E1XPlam (args, body, esc)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2)
  end
  | E1XPlet (decs, body) => let
    val (decs, amb1) = d1eclst_t1yp_finalize (decs)
    val (body, amb2) = e1xp_t1yp_finalize (body)
    val e1_node = E1XPlet (decs, body)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2)
  end
  | E1XPopr (opr, explst) => let
    val (explst, amb1) = e1xp_lst_t1yp_finalize (explst)
    val e1_node = E1XPopr (opr, explst)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1)
  end
  | E1XPproj (e1xp, i) => let
    val (e1xp, amb1) = e1xp_t1yp_finalize (e1xp)
    val e1_node = E1XPproj (e1xp, i)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1)
  end
  | E1XPstr (_) => (e1xp_make (e1_loc, e1_node, e1_typ), amb)
  | E1XPtup (explst) => let
    val (explst, amb1) = e1xp_lst_t1yp_finalize (explst)
    val e1_node = E1XPtup (explst)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1)
  end
  | E1XPvar (v) => let
    val (v, amb1) = v1ar_t1yp_finalize (v)
    val e1_node = E1XPvar (v)
  in
    (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1)
  end
//   | E1XPfixclo (f, args, body, env) => let
//     val (f, amb1) = v1ar_t1yp_finalize (f)
//     val (args, amb2) = v1ar_lst_t1yp_finalize (args)
//     val (body, amb3) = e1xp_t1yp_finalize (body)
//     val e1_node = E1XPfixclo (f, args, body, env)
//   in
//     (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2 + amb3)
//   end
//   | E1XPlamclo (args, body, env) => let
//     val (args, amb1) = v1ar_lst_t1yp_finalize (args)
//     val (body, amb2) = e1xp_t1yp_finalize (body)
//     val e1_node = E1XPlamclo (args, body, env)
//   in
//     (e1xp_make (e1_loc, e1_node, e1_typ), amb + amb1 + amb2)
//   end
end
  
implement e1xpopt_t1yp_finalize (eopt) = 
  case+ eopt of
  | Some0 e => let
    val (e, amb) = e1xp_t1yp_finalize (e)
  in
    (Some0 e, amb)
  end
  | None0 () => (None0, 0)

implement v1ar_t1yp_finalize (v) = let
  val (typ, amb1) = t1yp_finalize (v.v1ar_typ)
  // val (def, amb2) = e1xpopt_t1yp_finalize (!(v.v1ar_def))  // after the closure translation, this could
                                                              // cause circle
in
  ('{v1ar_loc = v.v1ar_loc,
    v1ar_nam = v.v1ar_nam,
    v1ar_typ = typ,
    v1ar_def = v.v1ar_def,
    v1ar_val = v.v1ar_val
  }, amb1(* + amb2*))
end

implement d1ec_t1yp_finalize (dec) = let
  val loc = dec.d1ec_loc
  val node = dec.d1ec_node
  val+ D1ECval (isrec, v1aldecs) = node
  val (v1aldecs, amb) = v1aldec_lst_t1yp_finalize (v1aldecs)
  val node = D1ECval (isrec, v1aldecs)
in
  ('{d1ec_loc = loc, d1ec_node = node}, amb)
end


implement v1aldec_t1yp_finalize (v1aldec) = let
  val (v, amb1) = v1ar_t1yp_finalize (v1aldec.v1aldec_var)
  val (e, amb2) = e1xp_t1yp_finalize (v1aldec.v1aldec_def)
  val v1aldec = '{v1aldec_loc = v1aldec.v1aldec_loc,
                  v1aldec_var = v,
                  v1aldec_def = e}
in
  (v1aldec, amb1 + amb2)
end

(* return value
 0: O.K.
 1: type conflict
 2: type ambiguity
 3: both
*)
implement trans1_exp (e0xp) = let
  val (e1xp, tyerrs) = oftype (ctx_nil, e0xp)
  val () = fprint_tyerr_pool (stderr_ref, tyerrs)
  val sz = tyerr_pool_size (tyerrs)
  val type_conflict = (if sz = 0 then 0 else 1): int
  val (e1xp, amb) = e1xp_t1yp_finalize (e1xp)
  // new e1xp has less information than the old one
  val type_ambiguity = if amb = 0 then 0 else 2
in
  (e1xp, type_conflict + type_ambiguity)
end




