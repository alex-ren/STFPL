

staload "trans_closure.sats"
staload "trans1.sats"
staload "symbol.sats"
staload "error.sats"

typedef loc = $Posloc.location_t

staload _(*anon*) = "symbol.dats"

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
staload _(*anon*) = "prelude/DATS/list_vt.dats" 
staload _(*anon*) = "libats/DATS/funmap_avltree.dats" 

staload _(*anon*) = "symbol.dats"

#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

#define Some0 option0_some
#define None0 option0_none

(* ****** ****** *)
typedef ctx = symenv_t (v1ar)
val ctx_nil = symenv_make () // empty context


fun ctx2v1arlst (Gamma: ctx): v1arlst = let
  val s = symenv_listize (Gamma)
  val symlst = list0_map_fun< @(symbol_t, v1ar)><v1ar> (s, lam x => x.1)
in
  symlst
end

extern fun trans_clo1_d1eclst (decs: d1eclst, Gamma: ctx): (ctx(*new gamma*), ctx(*esc*))
extern fun trans_clo1_d1ec (dec: d1ec, Gamma: ctx): (ctx, ctx)

extern fun trans_clo1_v1aldeclst (valdecs: v1aldeclst, Gamma: ctx): (ctx, ctx)
extern fun trans_clo1_v1aldeclst_rec (valdecs: v1aldeclst, Gamma: ctx): (ctx, ctx)

extern fun trans_clo1_v1aldec (valdec: v1aldec, Gamma: ctx): (ctx, ctx)
extern fun trans_clo1_v1aldec_rec (valdec: v1aldec, Gamma: ctx): (ctx, ctx)

extern fun trans_clo1_e1xp (exp: e1xp, Gamma: ctx): ctx
extern fun trans_clo1_e1xplst (exps: e1xplst, Gamma: ctx): ctx

extern fun trans_clo1_valdecs (valdecs: v1aldeclst, Gamma: ctx): (ctx, ctx)
extern fun trans_clo1_e1xplst (exps: e1xplst, Gamma: ctx): ctx

(* the return type is ctx,
  but actually we just need a list of symbols
*)
fun trans_clo1_e1xp (exp: e1xp, Gamma: ctx): ctx = let
  val exp_node = exp.e1xp_node
in
  case+ exp_node of
  | E1XPann (e, t) => trans_clo1_e1xp (e, Gamma)
  | E1XPapp (f, args) => let
    val esc1 = trans_clo1_e1xp (f, Gamma)
    val esc2 = trans_clo1_e1xp (args, Gamma)
  in
    symenv_merge (esc1, esc2)
  end
  | E1XPbool _ => ctx_nil
  | E1XPfix (f, args, body, ref_esc) => let
    // val new_gamma = symenv_insert (ctx_nil, f.v1ar_nam, f)
    // todo: didn't put f into ctx, is this correct?
    val new_gamma = ctx_nil
    val sym_args = list0_map_fun<v1ar>< @(symbol_t, v1ar)> (
      args, lam x => (x.v1ar_nam, x))
    val new_gamma = symenv_inserts (new_gamma, sym_args)
    val esc = trans_clo1_e1xp (body, new_gamma)
    val () = !ref_esc := ctx2v1arlst (esc)
  in
    symenv_sub (esc, Gamma)
  end
  | E1XPif (e_if, e_then, eo_else) => let
    val esc1 = trans_clo1_e1xp (e_if, Gamma)
    val esc2 = trans_clo1_e1xp (e_then, Gamma)
    val esc3 = (case+ eo_else of
                 | Some0 e_else => trans_clo1_e1xp (e_else, Gamma)
                 | None0 () => ctx_nil
                 )
    val esc = symenv_merge (esc1, esc2)
    val esc = symenv_merge (esc, esc3)
  in
    esc
  end
  | E1XPint _ => ctx_nil
  | E1XPlam (args, body, ref_esc) => let
    val sym_args = list0_map_fun<v1ar>< @(symbol_t, v1ar)> (
      args, lam x => (x.v1ar_nam, x))
    val new_gamma = symenv_inserts (ctx_nil, sym_args)
    val esc = trans_clo1_e1xp (body, new_gamma)
    val () = !ref_esc := ctx2v1arlst (esc)
  in
    symenv_sub (esc, Gamma)
  end
  | E1XPlet (decs, e) => let
    val (Gamma1, esc1) = trans_clo1_d1eclst (decs, Gamma)
    val esc2 = trans_clo1_e1xp (e, Gamma1)
  in
    symenv_merge (esc1, esc2)
  end
  | E1XPopr (opr, es) =>
      trans_clo1_e1xplst (es, Gamma)
  | E1XPproj (e, _) => trans_clo1_e1xp (e, Gamma)
  | E1XPstr _ => ctx_nil
  | E1XPtup es => trans_clo1_e1xplst (es, Gamma)
  | E1XPvar v => let
    val r = symenv_lookup (Gamma, v.v1ar_nam)
  in
    case+ r of
    | Some0 _ => ctx_nil 
    | None0 () => symenv_insert (ctx_nil, v.v1ar_nam, v)
  end
  | E1XPfixclo _ => ETRACE_MSG_OPR ("trans_clo1_e1xp E1XPfixclo is found\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
  | E1XPlamclo _ => ETRACE_MSG_OPR ("trans_clo1_e1xp E1XPlamclo is found\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
end

(* extern fun trans_clo1_e1xplst (exps: e1xplst, Gamma: ctx): ctx *)
implement trans_clo1_e1xplst (exps, Gamma) = let
  val gamma1 = list0_fold_left<ctx><e1xp> (
    lam (init, x) => symenv_merge (init, trans_clo1_e1xp (x, Gamma)), ctx_nil, exps)
in
  gamma1
end

(* extern fun trans_clo1_d1eclst (decs: d1eclst, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_d1eclst (decs, Gamma) =
  case+ decs of
  | cons (dec, decs1) => let
    val (gamma1, esc1) = trans_clo1_d1ec (dec, Gamma)
    val (gamma2, esc2) = trans_clo1_d1eclst (decs1, gamma1)
    val esc = symenv_merge (esc1, esc2)
  in
    (gamma2, esc)
  end
  | nil () => (Gamma, ctx_nil)

(* extern fun trans_clo1_d1ec (dec: d1ec, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_d1ec (dec, Gamma) = let
  val loc = dec.d1ec_loc
  val dnode = dec.d1ec_node
  val+ D1ECval (isrec, valdecs) = dnode
in
  if isrec then trans_clo1_v1aldeclst_rec (valdecs, Gamma)
           else trans_clo1_v1aldeclst (valdecs, Gamma)
end

(* extern fun trans_clo1_v1aldeclst (valdecs: v1aldeclst, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_v1aldeclst (valdecs, Gamma) =
  case+ valdecs of
  | cons (valdec, valdecs1) => let
    val (gamma1, esc1) = trans_clo1_v1aldec (valdec, Gamma)
    val (gamma2, esc2) = trans_clo1_v1aldeclst (valdecs1, gamma1)
    val esc = symenv_merge (esc1, esc2)
  in
    (gamma2, esc)
  end
  | nil () => (Gamma, ctx_nil)


(* extern fun trans_clo1_v1aldeclst_rec (valdecs: v1aldeclst, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_v1aldeclst_rec (valdecs, Gamma) =
  trans_clo1_v1aldeclst (valdecs, Gamma)  // todo is this correct?


(* extern fun trans_clo1_v1aldec (valdec: v1aldec, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_v1aldec (valdec, Gamma) = let
  val v = valdec.v1aldec_var
  val e = valdec.v1aldec_def
  val nam = v.v1ar_nam
  val gamma = symenv_insert (Gamma, nam, v)
  val esc = trans_clo1_e1xp (e, gamma)
in
  (gamma, esc)
end

(* extern fun trans_clo1_v1aldec_rec (valdec: v1aldec, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_v1aldec_rec (valdec, Gamma) = 
  trans_clo1_v1aldec (valdec, Gamma) // todo is this correct?


(* *********** ************** *************** *)
extern fun trans_clo2_e1xp_fix (f: v1ar, args: v1arlst, body: e1xp, 
  esc: v1arlst, Gamma: ctx, env: v1arlst): e1xp_node

extern fun trans_clo2_e1xp_lam (args: v1arlst, body: e1xp, 
  esc: v1arlst, Gamma: ctx, env: v1arlst): e1xp_node

extern fun trans_clo2_d1eclst (decs: d1eclst, 
  Gamma: ctx, env: v1arlst): (ctx(*new gamma*), d1eclst)
extern fun trans_clo2_d1ec (dec: d1ec, 
  Gamma: ctx, env: v1arlst): (ctx, d1ec)

extern fun trans_clo2_v1aldeclst (valdecs: v1aldeclst, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldeclst)
extern fun trans_clo2_v1aldeclst_rec (valdecs: v1aldeclst, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldeclst)

extern fun trans_clo2_v1aldec (valdec: v1aldec, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldec)
extern fun trans_clo2_v1aldec_rec (valdec: v1aldec, 
  Gamma: ctx, env: v1arlst): v1aldec

extern fun trans_clo2_e1xplst (exps: e1xplst,
  Gamma: ctx, env: v1arlst): e1xplst

(* var list for the closure environment *)
(* Gamma: from function arguments and var declaration
   env: the closure info
*)
fun trans_clo2_e1xp (exp: e1xp, Gamma: ctx, env: v1arlst): e1xp = let
  val loc = exp.e1xp_loc
  val node = exp.e1xp_node
  val typ = exp.e1xp_typ
in
  case+ node of
  | E1XPann (e, t) => let
    val e = trans_clo2_e1xp (e, Gamma, env)
    val exp_node = E1XPann (e, e.e1xp_typ)
  in
    e1xp_make (loc, exp_node, e.e1xp_typ)
  end
  | E1XPapp (f, args) => let
    val f = trans_clo2_e1xp (f, Gamma, env)
    val args = trans_clo2_e1xp (args, Gamma, env)
    val exp_node = E1XPapp (f, args)
  in
    e1xp_make (loc, exp_node, typ)
  end
  | E1XPbool _ => e1xp_make (loc, node, typ)
  | E1XPfix (f, args, body, ref_esc) => 
    e1xp_make (loc, trans_clo2_e1xp_fix (f, args, body, !ref_esc, Gamma, env), typ)
  | E1XPif (e_if, e_then, eo_else) => let
    val e_if = trans_clo2_e1xp (e_if, Gamma, env)
    val e_then = trans_clo2_e1xp (e_then, Gamma, env)
    val eo_else = (case+ eo_else of
                 | Some0 e_else => Some0 (trans_clo2_e1xp (e_else, Gamma, env))
                 | None0 () => None0 ()
                 ): (option0 e1xp)
    val exp_node = E1XPif (e_if, e_then, eo_else)
  in
    e1xp_make (loc, exp_node, typ)
  end
  | E1XPint _ => e1xp_make (loc, node, typ)
  | E1XPlam (args, body, ref_esc) =>
    e1xp_make (loc, trans_clo2_e1xp_lam (args, body, !ref_esc, Gamma, env), typ)
  | E1XPlet (decs, e) => let
    val (gamma, decs1) = trans_clo2_d1eclst (decs, Gamma, env)
    val e1 = trans_clo2_e1xp (e, gamma, env)
  in
    e1xp_make (loc, E1XPlet (decs1, e1), typ)
  end
  | E1XPopr (opr, es) =>
      e1xp_make (loc, 
                 E1XPopr (opr, trans_clo2_e1xplst (es, Gamma, env)), 
                 typ)
  | E1XPproj (e, i) => let
    val e = trans_clo2_e1xp (e, Gamma, env)
    val exp_node = E1XPproj (e, i)
  in
    e1xp_make (loc, exp_node, typ)
  end
  | E1XPstr _ => e1xp_make (loc, node, typ)
  | E1XPtup es => let
    val es = trans_clo2_e1xplst (es, Gamma, env)
  in
    e1xp_make (loc, E1XPtup es, typ)
  end
  | E1XPvar v => let  // todo is this necessary?
    val vo1 = symenv_lookup (Gamma, v.v1ar_nam)
  in
    case+ vo1 of
    | Some0 v1 => e1xp_make (loc, E1XPvar v1, typ)
    | None0 () => let
      val vo2 = list0_find_cloref<v1ar> (env, lam x => x.v1ar_nam = v.v1ar_nam)
    in
      case+ vo2 of
      | Some0 v2 => e1xp_make (loc, E1XPvar v2, typ)
      | None0 () => ETRACE_MSG_OPR ("trans_clo2_e1xp var not found\n", 
          ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
    end
  end
  | E1XPfixclo _ => ETRACE_MSG_OPR ("trans_clo2_e1xp E1XPfixclo is found\n", 
          ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
  | E1XPlamclo _ => ETRACE_MSG_OPR ("trans_clo2_e1xp E1XPlamclo is found\n", 
          ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
end

(* extern fun trans_clo2_e1xp_fix (f: v1ar, args: v1arlst, body: e1xp, 
  esc: v1arlst, Gamma: ctx, env: v1arlst, loc: loc): e1xp
*)
implement trans_clo2_e1xp_fix (f, args, body, esc, Gamma, env) = let
  // put f into env
  val env' = f :: env
  (* find the v1ar in the Gamma or env based on name *)
  fun helper (v: v1ar):<cloref1> v1ar = let
    val vopt1 = symenv_lookup (Gamma, v.v1ar_nam)
  in
    case+ vopt1 of
    | Some0 v1 => v1
    | None0 () => let
      val vopt2 = list0_find_cloref<v1ar> (env', lam x => x.v1ar_nam = v.v1ar_nam)
    in
      case+ vopt2 of
      | Some0 v2 => v2
      | None0 () => ETRACE_MSG_OPR ("trans_clo1_e1xp_fix var not found\n", ETRACE_LEVEL_ERROR,
                  abort (ERRORCODE_FORBIDDEN))
    end
  end

  val env1 = list0_map_cloref<v1ar><v1ar> (esc, helper)  // f maybe inside env1

  val Gamma1 = symenv_inserts (ctx_nil, 
    list0_map_fun<v1ar><(symbol_t, v1ar)> (args, lam x => (x.v1ar_nam, x)))

  val body_exp = trans_clo2_e1xp (body, Gamma1, env1)

  val exp_node = E1XPfixclo (f, args, body_exp, env1)
in
  exp_node
end

(* extern fun trans_clo2_e1xp_lam (args: v1arlst, body: e1xp, 
  esc: v1arlst, Gamma: ctx, env: v1arlst, loc: loc): e1xp
*)
implement trans_clo2_e1xp_lam (args, body, esc, Gamma, env) = let
  (* find the v1ar in the Gamma or env based on name *)
  fun helper (v: v1ar):<cloref1> v1ar = let
    val vopt1 = symenv_lookup (Gamma, v.v1ar_nam)
  in
    case+ vopt1 of
    | Some0 v1 => v1
    | None0 () => let
      val vopt2 = list0_find_cloref<v1ar> (env, lam x => x.v1ar_nam = v.v1ar_nam)
    in
      case+ vopt2 of
      | Some0 v2 => v2
      | None0 () => ETRACE_MSG_OPR ("trans_clo1_e1xp_fix var not found\n", ETRACE_LEVEL_ERROR,
                  abort (ERRORCODE_FORBIDDEN))
    end
  end

  val env1 = list0_map_cloref<v1ar><v1ar> (esc, helper)

  val Gamma1 = symenv_inserts (ctx_nil, 
    list0_map_fun<v1ar><(symbol_t, v1ar)> (args, lam x => (x.v1ar_nam, x)))

  val body_exp = trans_clo2_e1xp (body, Gamma1, env1)

  val exp_node = E1XPlamclo (args, body_exp, env1)
in
  exp_node
end

  
(* extern fun trans_clo2_e1xplst (exps: e1xplst,
  Gamma: ctx, env: v1arlst): e1xplst *)
implement trans_clo2_e1xplst (exps, Gamma, env) =
  case+ exps of
  | cons (exp, exps1) =>
    cons (trans_clo2_e1xp (exp, Gamma, env), trans_clo2_e1xplst (exps1, Gamma, env))
  | nil () => nil ()

(* extern fun trans_clo2_d1eclst (decs: d1eclst, 
  Gamma: ctx, env: v1arlst): (ctx(*new gamma*), d1eclst) *)
implement trans_clo2_d1eclst (decs, Gamma, env) =
  case+ decs of
  | cons (dec, decs1) => let
    val (gamma1, dec') = trans_clo2_d1ec (dec, Gamma, env)
    val (gamma2, decs1') = trans_clo2_d1eclst (decs1, gamma1, env)
  in
    (gamma2, cons (dec', decs1'))
  end
  | nil () => (Gamma, nil ())


(* extern fun trans_clo2_d1ec (dec: d1ec, 
  Gamma: ctx, env: v1arlst): (ctx, d1ec) *)
implement trans_clo2_d1ec (dec, Gamma, env) = let
  val loc = dec.d1ec_loc
  val dnode = dec.d1ec_node
  val+ D1ECval (isrec, valdecs) = dnode
  val (gamma, valdecs1) = 
    if isrec then trans_clo2_v1aldeclst_rec (valdecs, Gamma, env)
             else trans_clo2_v1aldeclst (valdecs, Gamma, env)
in
  (gamma, d1ec_make_val (loc, isrec, valdecs1))
end

(* extern fun trans_clo2_v1aldeclst (valdecs: v1aldeclst, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldeclst) *)
implement trans_clo2_v1aldeclst (valdecs, Gamma, env) =
  case+ valdecs of
  | cons (valdec, valdecs1) => let
    val (gamma1, valdec') = trans_clo2_v1aldec (valdec, Gamma, env)
    val (gamma2, valdecs1') = trans_clo2_v1aldeclst (valdecs1, gamma1, env)
  in
    (gamma2, cons (valdec', valdecs1'))
  end
  | nil () => (Gamma, nil ())

(* extern fun trans_clo2_v1aldeclst_rec (valdecs: v1aldeclst, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldeclst) *)
implement trans_clo2_v1aldeclst_rec (valdecs, Gamma, env) = let
  val vars = list0_map_fun<v1aldec><(symbol_t, v1ar)> (
    valdecs, lam x => (x.v1aldec_var.v1ar_nam, x.v1aldec_var))

  val gamma = symenv_inserts (Gamma, vars)

  fun trans_clo2_v1aldeclst_rec_impl (valdecs: v1aldeclst, 
    Gamma: ctx, env: v1arlst):<cloref1> v1aldeclst =
    case+ valdecs of
    | cons (valdec, valdecs1) => let
      val valdec' = trans_clo2_v1aldec_rec (valdec, gamma, env)
      val valdecs1' = trans_clo2_v1aldeclst_rec_impl (valdecs1, gamma, env)
    in
      cons (valdec', valdecs1')
    end
    | nil () => nil ()

  val ret = trans_clo2_v1aldeclst_rec_impl (valdecs, gamma, env) 
in
  (gamma, ret)  // todo is this correct?
end

(* extern fun trans_clo2_v1aldec (valdec: v1aldec, 
  Gamma: ctx, env: v1arlst): (ctx, v1aldec) *)
implement trans_clo2_v1aldec (valdec, Gamma, env) = let
  val loc = valdec.v1aldec_loc
  val v = valdec.v1aldec_var
  val def = valdec.v1aldec_def

  val nam = v.v1ar_nam
  val gamma = symenv_insert (Gamma, nam, v)
  val def' = trans_clo2_e1xp (def, gamma, env)

  val () = !(v.v1ar_def) := (Some0 def')
in
  (gamma, v1aldec_make (loc, v, def'))
end

(* extern fun trans_clo2_v1aldec_rec (valdec: v1aldec, 
  Gamma: ctx, env: v1arlst): v1aldec *)
implement trans_clo2_v1aldec_rec (valdec, Gamma, env) = let
  val loc = valdec.v1aldec_loc
  val v = valdec.v1aldec_var
  val def = valdec.v1aldec_def

  val def' = trans_clo2_e1xp (def, Gamma, env)

  val () = !(v.v1ar_def) := (Some0 def')
in
  v1aldec_make (loc, v, def')
end

implement trans_closure (e1xp) = let
  val _ = trans_clo1_e1xp (e1xp, ctx_nil)
  val e = trans_clo2_e1xp (e1xp, ctx_nil, nil)
in
  e
end












































