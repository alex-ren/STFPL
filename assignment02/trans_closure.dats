

staload "trans_closure.sats"
staload "trans1.sats"
staload "symbol.sats"
staload "error.sats"
staload "libfunctions.sats"

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
    // put f into ctx
    val new_gamma = symenv_insert (ctx_nil, f.v1ar_nam, f)
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
    val nam = v.v1ar_nam
    val r = symenv_lookup (Gamma, nam)
  in
    case+ r of
    | Some0 _ => ctx_nil 
    | None0 () => let
      val typ_opt = libSymTypFind (nam)  // check library function
    in
      case+ typ_opt of
      | Some0 _ => ctx_nil
      | None0 () => symenv_insert (ctx_nil, nam, v)
    end
  end
//  | E1XPfixclo _ => ETRACE_MSG_OPR ("trans_clo1_e1xp E1XPfixclo is found\n", ETRACE_LEVEL_ERROR,
//                    abort (ERRORCODE_FORBIDDEN))
//  | E1XPlamclo _ => ETRACE_MSG_OPR ("trans_clo1_e1xp E1XPlamclo is found\n", ETRACE_LEVEL_ERROR,
//                    abort (ERRORCODE_FORBIDDEN))
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
implement trans_clo1_v1aldeclst_rec (valdecs, Gamma) = let
  fun collect_var (valdecs: v1aldeclst, ctx: ctx): ctx = 
    case+ valdecs of
    | cons (valdec, valdecs1) => let
      val v = valdec.v1aldec_var
      val nam = v.v1ar_nam
      val ctx = symenv_insert (ctx, nam, v)
    in
      collect_var (valdecs1, ctx)
    end
    | nil () => ctx

  val vars_ctx = collect_var (valdecs, ctx_nil)
  
  val Gamma1 = symenv_merge (Gamma, vars_ctx)
 
  (* this esc is the env for the list of valdec *)
  (* These two Gamma1's should be same *)
  val (Gamma1, esc) = trans_clo1_v1aldeclst (valdecs, Gamma1)

  fun closure_reset_env (e1xp: e1xp):<cloref1> void =
    case+  e1xp.e1xp_node of
    | E1XPann (e1, _) => closure_reset_env (e1)
    | E1XPfix (_, _, _, env_ref) => let
      val env = !env_ref
      val env = list0_map_fun<v1ar>< @(symbol_t, v1ar)> (
          env, lam x => @(x.v1ar_nam, x))
      val env_ctx = symenv_inserts (ctx_nil, env)
      val env1_ctx = symenv_sub (env_ctx, vars_ctx)
      val env1 = symenv_listize (env1_ctx)
      val env1 = list0_map_fun< @(symbol_t, v1ar)><v1ar> (
           env1, lam x => x.1)
    in
      !env_ref := env1
    end
    | E1XPlam (_, _, env_ref) => let
      val env = !env_ref
      val env = list0_map_fun<v1ar>< @(symbol_t, v1ar)> (
          env, lam x => @(x.v1ar_nam, x))
      val env_ctx = symenv_inserts (ctx_nil, env)
      val env1_ctx = symenv_sub (env_ctx, vars_ctx)
      val env1 = symenv_listize (env1_ctx)
      val env1 = list0_map_fun< @(symbol_t, v1ar)><v1ar> (
           env1, lam x => x.1)
    in
      !env_ref := env1
    end
    | _ => ()

  (* All the v1aldec_rec in the list have the same env. *)
  val _ = list0_map_cloref<v1aldec><int>  // todo use void instead of int
    (valdecs, lam valdec => let 
                  val () = closure_reset_env (valdec.v1aldec_def) 
                in 0 end
    )
in
  (Gamma1, esc)
end

(* extern fun trans_clo1_v1aldec (valdec: v1aldec, Gamma: ctx): (ctx, ctx) *)
implement trans_clo1_v1aldec (valdec, Gamma) = let
  val v = valdec.v1aldec_var
  val e = valdec.v1aldec_def

  val esc = trans_clo1_e1xp (e, Gamma)

  val nam = v.v1ar_nam
  val gamma = symenv_insert (Gamma, nam, v)
in
  (gamma, esc)
end

implement trans_closure (e1xp) = let
  val ctx = trans_clo1_e1xp (e1xp, ctx_nil)
  val ctx = symenv_listize (ctx)
   val () = case+ ctx of
            | cons (_, _) => ()  // fprint (stderr_ref, "000000000000000000000000000000000\n")
            | nil () => ()  // fprint (stderr_ref, "111111111111111111111111111111\n")
  // val e = trans_clo2_e1xp (e1xp, ctx_nil, nil)  // todo remove
in
  e1xp
end












































