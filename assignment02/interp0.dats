(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "interp0.sats"
staload "error.sats"
staload _ = "symbol.dats"

staload _ = "prelude/DATS/list.dats"
staload _ = "prelude/DATS/list0.dats"

(* ****** ****** *)

(*
** please implement as follows the function interfaces declared
** in [interp0.sats]
*)

(* ****** ****** *)

#define nil list0_nil
#define cons list0_cons
#define :: list0_cons


#define Some0 option0_some
#define None0 option0_none

// implement
// interp0_exp (e) = let
//   // val () = println! ("interp0_exp: yet to be implemented!")
//   // val () = assertloc (false)
// in
//   V0ALint (3)
//   // exit (1)
// end // end of [interp0_exp]



implement fprint_v0al (out, v) = let
  macdef prtval (v) = fprint_v0al (out, ,(v))
  macdef prele (e) = fprint (out, ,(e))
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case v of
  | V0ALbool (b) => begin
    prstr "V0ALbool("; prele b; prstr ")"
    end  // end of [V0ALbool]
  | V0ALint (n) => begin
    prstr "V0ALint("; prele n; prstr ")"
    end  // end of [V0ALint]
  | V0ALstr (str) => begin
    prstr "V0ALstr("; prele str; prstr ")"
    end  // end of [V0ALstr]
  | V0ALtup (vs) => begin
    prstr "V0ALtup("; fprint_v0allst (out, vs); prstr ")"
    end  // end of [V0ALtup]
  | V0ALclo (env, e) => begin
    prstr "V0ALclo(...)"
    end  // end of [V0ALclo]
  | V0ALfix (env, e) => begin
    prstr "V0ALfix(...)"
    end  // end of [V0ALfix]
  | V0ALref _ => begin
    prstr "V0ALref(...)"
  end
end  // end of [fprint_v0al]

implement fprint_v0allst (out, vs) = loop (vs, 0) where {
  fun loop (vs: v0allst, i: int)
    :<cloref1> void = case+ vs of
    | cons (v, vs) => loop (vs, i+1) where {
        val () = if i > 0 then fprint_string (out, ", ")
        val () = fprint_v0al (out, v)
      } // end of [cons]
    | nil () => ()
  // end of [loop]  
}  (* end of [fprint_v0allst] *)


implement print_v0al (v) = fprint_v0al (stdout_ref, v)

implement prerr_v0al (v) = fprint_v0al (stderr_ref, v)

extern fun interp0_exp_env (env: env, e: e0xp): v0al

extern fun interp0_explst_env (env: env, explst: e0xplst): v0allst

extern fun fill_args (arglst: $ABS.a0rglst, v: v0al): option0 env

extern fun d0eclst_eval (env: env, decs: $ABS.d0eclst): env

extern fun d0ec_eval (env: env, dec: $ABS.d0ec): env

extern fun v0aldeclst_eval (env: env, valdecs: $ABS.v0aldeclst): env
extern fun v0aldeclst_eval_rec (env: env, valdecs: $ABS.v0aldeclst): env

extern fun v0aldec_eval (env: env, valdec: $ABS.v0aldec): env
extern fun v0aldec_eval_rec (env: env, valdec: $ABS.v0aldec): env

extern fun opr_eval (opr: $ABS.opr, vs: v0allst): v0al

implement interp0_exp (e) = interp0_exp_env ($SYM.symenv_make (), e)
  
(* extern fun interp0_exp_env (env: env, e: e0xp): v0al *)
implement interp0_exp_env (env, e): v0al =
  case+ e.e0xp_node of
  | $ABS.E0XPann (e, t) => interp0_exp_env (env, e)
  | $ABS.E0XPapp (e1, e2) => let
    val () = ETRACE_MSG ("======== interp0_exp_env :: E0XPapp\n", ETRACE_LEVEL_DEBUG)
    val v1 = interp0_exp_env (env, e1)
    val v2 = interp0_exp_env (env, e2)
  in
    case+ v1 of
    | V0ALclo (env1, e1') =>
      (case+ e1'.e0xp_node of
      | $ABS.E0XPlam (arglst, tyret, ebody) => let
        val opt_env1' = fill_args (arglst, v2)
      in
        case+ opt_env1' of
        | Some0 env1' => let
          val env2 = $SYM.symenv_inserts (env1', env1)
        in
          interp0_exp_env (env2, ebody)
        end
        | None0 () => ETRACE_MSG_OPR ("interp0_exp_env wrong args\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      end
      | _ => ETRACE_MSG_OPR ("interp0_exp_env app type clo error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      )
    | V0ALfix (env1, e1') => 
      (case+ e1'.e0xp_node of
      | $ABS.E0XPfix (f, arglst, tyret, ebody) => let
        val opt_env1' = fill_args (arglst, v2)
        val () = ETRACE_MSG ("======== interp0_exp_env $V0ALfix \n", ETRACE_LEVEL_DEBUG)
      in
        case+ opt_env1' of
        | Some0 env1' => let
          val env2 = $SYM.symenv_insert (
            $SYM.symenv_inserts (env1', env1), f, v1)
        in
          interp0_exp_env (env2, ebody)
        end
        | None0 () => ETRACE_MSG_OPR ("interp0_exp_env wrong args\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      end
      | _ => ETRACE_MSG_OPR ("interp0_exp_env app type fix error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      )
    | _ => ETRACE_MSG_OPR ("interp0_exp_env app type error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end
  | $ABS.E0XPbool b => V0ALbool b
  | $ABS.E0XPfix (_) => V0ALfix (env, e)
  | $ABS.E0XPif (e1, et, efo) => let
    val v1 = interp0_exp_env (env, e1)
  in
    case+ v1 of 
    | V0ALbool tf => 
      if tf = true then interp0_exp_env (env, et)
      else (case+ efo of
      | Some0 ef => interp0_exp_env (env, ef)
      | None0 () => V0ALtup (nil)
      )
    | _ => ETRACE_MSG_OPR ("interp0_exp_env if type error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end

  | $ABS.E0XPint (n) => V0ALint (n)
  | $ABS.E0XPlam (_) => V0ALclo (env, e)
  | $ABS.E0XPlet (declst, e1) =>  let
    val () = ETRACE_MSG ("======== interp0_exp_env :: E0XPlet\n", ETRACE_LEVEL_DEBUG)
    val env' = d0eclst_eval (env, declst)
  in
    interp0_exp_env (env', e1)
  end
  | $ABS.E0XPopr (opr, explst) => let
    val vs = interp0_explst_env (env, explst)
  in
    opr_eval (opr, vs)
  end
  | $ABS.E0XPproj (e1, i) => let
    val v1 = interp0_exp_env (env, e1)
  in
    case+ v1 of
    | V0ALtup (vs) => let
      val vo =  list0_nth_opt<v0al> (vs, i)
    in
      case+ vo of
      | Some v2 => v2
      | None () => ETRACE_MSG_OPR ("interp0_exp_env proj out of bound\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
    end
    | _ => ETRACE_MSG_OPR ("interp0_exp_env proj not tuple\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end
  | $ABS.E0XPstr (str) => V0ALstr (str)
  | $ABS.E0XPtup (explst) => let
    val () = ETRACE_MSG ("======== interp0_exp_env tup\n", ETRACE_LEVEL_DEBUG)
  in
    V0ALtup (interp0_explst_env (env, explst))
  end
  | $ABS.E0XPvar sym => let
    val v_opt = $SYM.symenv_lookup (env, sym)
  in
    case+ v_opt of
    | Some0 v => let
      val () = ETRACE_MSG ("======== interp0_explst_env :: E0XPvar :: Some0 found ", 
        ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR ($SYM.print_symbol sym, ETRACE_LEVEL_DEBUG)
      val () = ETRACE_MSG (" -> ", ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR ((print_v0al (v); print_newline ()), ETRACE_LEVEL_DEBUG)
    in
      case+ v of
      | V0ALref valref => !valref
      | _ => v
    end
    | None0 () => let
      val () = ETRACE_MSG ("======== interp0_explst_env :: E0XPvar :: None0 needs ", 
        ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR (($SYM.print_symbol sym; print_newline ()), ETRACE_LEVEL_DEBUG)
    in
      abort (ERRORCODE_TYPE_ERROR)
    end
  end
  (* | _ => abort (ERRORCODE_TYPE_ERROR) *)
  (* end of [interp0_exp_env] *)

(* extern fun interp0_explst_env (env: env, explst: e0xplst): v0allst *)
implement interp0_explst_env (env, explst) = 
  list0_map_cloref (explst, lam e => interp0_exp_env (env, e))

(* extern fun fill_args (arglst: $ABS.a0rglst, v: v0al): option0 env *)
implement fill_args (arglst, v) = let
  val args_len = list0_length (arglst)
  val env = $SYM.symenv_make ()
in
  if args_len = 1 then let
    val- cons (arg, nil ()) = arglst
  in
    Some0 ($SYM.symenv_insert (env, arg.a0rg_nam, v))
  end
  else if args_len = 0 then case+ v of
  | V0ALtup (nil ()) => Some0 (env)
  | _ => None0
  else case+ v of
  | V0ALtup vs => if args_len <> list0_length (vs) then None0 else let
    val syms_vs = list0_map2_fun<$ABS.a0rg, v0al> (
        arglst, vs, lam (arg, v) => @(arg.a0rg_nam, v))
  in
    Some0 (list0_fold_left<env>< @(sym, v0al)> (
             lam (init, x) => $SYM.symenv_insert (init, x.0, x.1), 
             env, syms_vs)
          )
  end
  | _ => None0
end

(* extern fun d0eclst_eval (env: env, decs: $ABS.d0eclst): env *)
implement d0eclst_eval (env, decs) = list0_fold_left (
  lam (x,y) => d0ec_eval (x, y), env, decs)

(* extern fun d0ec_eval (env: env, dec: $ABS.d0ec): env *)
implement d0ec_eval (env, dec) = let
  val+ $ABS.D0ECval (isrec, valdecs) = dec.d0ec_node
in
  if isrec = false then v0aldeclst_eval (env, valdecs)
  else v0aldeclst_eval_rec (env, valdecs)
end

(* extern fun v0aldeclst_eval (env: env, valdecs: $ABS.v0aldeclst): env *)
implement v0aldeclst_eval (env, valdecs) = list0_fold_left (
  lam (x,y) => v0aldec_eval (x, y), env, valdecs)

(* extern fun v0aldeclst_eval_rec (env: env, valdecs: $ABS.v0aldeclst): env *)
implement v0aldeclst_eval_rec (env, valdecs) = let
  fun fillin_env (env: env, valdecs: $ABS.v0aldeclst): env =
    case+ valdecs of
    | cons (valdec, valdecs1) => let
      val env' = $SYM.symenv_insert (
        env, valdec.v0aldec_nam, V0ALref (ref_make_elt<v0al> (V0ALint 825)))
    in
      fillin_env (env', valdecs1)
    end
    | nil () => env

  val env1 = fillin_env (env, valdecs)
in
 list0_fold_left (
   lam (x,y) => v0aldec_eval_rec (x, y), env1, valdecs)
end


(* extern fun v0aldec_eval (env: env, valdec: $ABS.v0aldec): env *)
implement v0aldec_eval (env, valdec) = let
  val () = ETRACE_MSG ("======== v0aldec_eval ", ETRACE_LEVEL_DEBUG)
  val () = ETRACE_OPR (($SYM.print_symbol valdec.v0aldec_nam; print_newline ()), 
    ETRACE_LEVEL_DEBUG)
  val v = interp0_exp_env (env, valdec.v0aldec_def)
in
  $SYM.symenv_insert (env, valdec.v0aldec_nam, v)
end

(* extern fun v0aldec_eval_rec (env: env, valdec: $ABS.v0aldec): env *)
implement v0aldec_eval_rec (env, valdec) = let
  val () = ETRACE_MSG ("======== v0aldec_eval_rec ", ETRACE_LEVEL_DEBUG)
  val () = ETRACE_OPR (($SYM.print_symbol valdec.v0aldec_nam; print_newline ()), 
    ETRACE_LEVEL_DEBUG)
  val v = interp0_exp_env (env, valdec.v0aldec_def)
  val val_opt = $SYM.symenv_lookup (env, valdec.v0aldec_nam)
in
  case+ val_opt of
  | Some0 value => (case+ value of
    | V0ALref (valref) => let
      val () = !valref := v
    in
      env
    end
    | _ => ETRACE_MSG_OPR ("preplaced symbol not of type V0ALref\n", ETRACE_LEVEL_ERROR,
           abort (ERRORCODE_TYPE_ERROR))
    )
  | None0 () => ETRACE_MSG_OPR ("rec symbol is not preplaced\n", ETRACE_LEVEL_ERROR,
           abort (ERRORCODE_TYPE_ERROR))
end

(* extern fun opr_eval (opr: $ABS.opr, vs: v0allst): v0al *)
implement opr_eval (opr, vs) =
  case+ opr of
  | $ABS.OPR sym => 
    if $SYM.eq_symbol_symbol (sym, $SYM.symbol_PLUS) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 + i2)
      | _ => ETRACE_MSG_OPR ("opr_eval + error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_MINUS) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 - i2)
      | _ => ETRACE_MSG_OPR ("opr_eval - error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_TIMES) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 * i2)
      | _ => ETRACE_MSG_OPR ("opr_eval * error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_SLASH) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 / i2)
      | _ => ETRACE_MSG_OPR ("opr_eval / error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_UMINUS) then case+ vs of
      | cons (V0ALint i1, nil ()) => V0ALint (0 - i1)
      | _ => ETRACE_MSG_OPR ("opr_eval ~ error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_GT) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 > i2)
      | _ => ETRACE_MSG_OPR ("opr_eval > error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_GTE) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 >= i2)
      | _ => ETRACE_MSG_OPR ("opr_eval >= error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_LT) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 < i2)
      | _ => ETRACE_MSG_OPR ("opr_eval < error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_LTE) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 <= i2)
      | _ => ETRACE_MSG_OPR ("opr_eval <= error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_EQ) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 = i2)
      | _ => ETRACE_MSG_OPR ("opr_eval = error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_NEQ) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 <> i2)
      | _ => ETRACE_MSG_OPR ("opr_eval <> error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_PRINT_INT) then case+ vs of
      | cons (V0ALint i, nil ()) => let
        val () = print_int (i)
      in
        V0ALtup (nil)
      end
      | _ => ETRACE_MSG_OPR ("opr_eval print_int error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $SYM.eq_symbol_symbol (sym, $SYM.symbol_PRINT) then case+ vs of
      | cons (V0ALstr str, nil ()) => let
        val () = print str
      in
        V0ALtup (nil)
      end
      | _ => ETRACE_MSG_OPR ("opr_eval print error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else ETRACE_MSG_OPR ("opr_eval unsupported opr\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
  (* end of [opr_eval] *)

(* ****** ****** *)

(* end of [interp-1.dats] *)



