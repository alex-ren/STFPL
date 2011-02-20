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

typedef e0xp    = $Absyn.e0xp
typedef e0xplst = $Absyn.e0xplst
typedef e0xpopt = $Absyn.e0xpopt
typedef e0xpopt = $Absyn.e0xpopt
typedef a0rglst = $Absyn.a0rglst
typedef d0ec = $Absyn.d0ec
typedef d0eclst = $Absyn.d0eclst
typedef v0aldeclst = $Absyn.v0aldeclst
typedef v0aldec = $Absyn.v0aldec

typedef opr = $Absyn.opr


typedef sym = $Symbol.symbol_t
val symenv_make = $Symbol.symenv_make

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

extern fun eval (env: env, e: e0xp): v0al

fun evallst (env: env, explst: e0xplst): v0allst = 
  list0_map_cloref (explst, lam e => eval (env, e))

val v0al_void = V0ALtup (nil)

fun evalopt (env: env, eo: e0xpopt): v0al =
  case+ eo of
  | Some0 e => eval (env, e)
  | None0 () => v0al_void

fun eval_if (env: env, e_test: e0xp, e_then: e0xp, e_else: e0xpopt): v0al = let
    val v_test = eval (env, e_test)
  in
    case+ v_test of 
    | V0ALbool tf => 
      if tf = true then eval (env, e_then)
      else evalopt (env, e_else)
    | _ => ETRACE_MSG_OPR ("eval if type error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end


extern fun fill_args (arglst: a0rglst, v: v0al): option0 env

extern fun eval_d0eclst (env: env, decs: d0eclst): env

extern fun eval_d0ec (env: env, dec: d0ec): env

extern fun eval_v0aldeclst (env: env, valdecs: v0aldeclst): env
extern fun eval_v0aldeclst_rec (env: env, valdecs: v0aldeclst): env

extern fun eval_v0aldec (env: env, valdec: v0aldec): env
extern fun eval_v0aldec_rec (env: env, valdec: v0aldec): env

extern fun eval_opr (opr: opr, vs: v0allst): v0al

implement interp0_exp (e) = eval (symenv_make (), e)
  
(* extern fun eval (env: env, e: e0xp): v0al *)
implement eval (env, e): v0al =
  case+ e.e0xp_node of
  | $Absyn.E0XPann (e, t) => eval (env, e)
  | $Absyn.E0XPapp (e1, e2) => let
    val () = ETRACE_MSG ("======== eval :: E0XPapp\n", ETRACE_LEVEL_DEBUG)
    val v1 = eval (env, e1)
    val v2 = eval (env, e2)
  in
    case+ v1 of
    | V0ALclo (env1, e1') =>
      (case+ e1'.e0xp_node of
      | $Absyn.E0XPlam (arglst, tyret, ebody) => let
        val opt_env1' = fill_args (arglst, v2)
      in
        case+ opt_env1' of
        | Some0 env1' => let
          val env2 = $Symbol.symenv_inserts (env1', env1)
        in
          eval (env2, ebody)
        end
        | None0 () => ETRACE_MSG_OPR ("eval wrong args\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      end
      | _ => ETRACE_MSG_OPR ("eval app type clo error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      )
    | V0ALfix (env1, e1') => 
      (case+ e1'.e0xp_node of
      | $Absyn.E0XPfix (f, arglst, tyret, ebody) => let
        val opt_env1' = fill_args (arglst, v2)
        val () = ETRACE_MSG ("======== eval $V0ALfix \n", ETRACE_LEVEL_DEBUG)
      in
        case+ opt_env1' of
        | Some0 env1' => let
          val env2 = $Symbol.symenv_insert (
            $Symbol.symenv_inserts (env1', env1), f, v1)
        in
          eval (env2, ebody)
        end
        | None0 () => ETRACE_MSG_OPR ("eval wrong args\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      end
      | _ => ETRACE_MSG_OPR ("eval app type fix error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
      )
    | _ => ETRACE_MSG_OPR ("eval app type error\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end
  | $Absyn.E0XPbool b => V0ALbool b
  | $Absyn.E0XPfix (_) => V0ALfix (env, e)
  | $Absyn.E0XPif (e1, et, efo) => eval_if (env, e1, et, efo)

  | $Absyn.E0XPint (n) => V0ALint (n)
  | $Absyn.E0XPlam (_) => V0ALclo (env, e)
  | $Absyn.E0XPlet (declst, e1) =>  let
    val () = ETRACE_MSG ("======== eval :: E0XPlet\n", ETRACE_LEVEL_DEBUG)
    val env' = eval_d0eclst (env, declst)
  in
    eval (env', e1)
  end
  | $Absyn.E0XPopr (opr, explst) => let
    val vs = evallst (env, explst)
  in
    eval_opr (opr, vs)
  end
  | $Absyn.E0XPproj (e1, i) => let
    val v1 = eval (env, e1)
  in
    case+ v1 of
    | V0ALtup (vs) => let
      val vo =  list0_nth_opt<v0al> (vs, i)
    in
      case+ vo of
      | Some v2 => v2
      | None () => ETRACE_MSG_OPR ("eval proj out of bound\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
    end
    | _ => ETRACE_MSG_OPR ("eval proj not tuple\n", ETRACE_LEVEL_INFO, 
                      abort (ERRORCODE_TYPE_ERROR))
  end
  | $Absyn.E0XPstr (str) => V0ALstr (str)
  | $Absyn.E0XPtup (explst) => let
    val () = ETRACE_MSG ("======== eval tup\n", ETRACE_LEVEL_DEBUG)
  in
    V0ALtup (evallst (env, explst))
  end
  | $Absyn.E0XPvar sym => let
    val v_opt = $Symbol.symenv_lookup (env, sym)
  in
    case+ v_opt of
    | Some0 v => let
      val () = ETRACE_MSG ("======== evallst :: E0XPvar :: Some0 found ", 
        ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR ($Symbol.print_symbol sym, ETRACE_LEVEL_DEBUG)
      val () = ETRACE_MSG (" -> ", ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR ((print_v0al (v); print_newline ()), ETRACE_LEVEL_DEBUG)
    in
      case+ v of
      | V0ALref valref => !valref
      | _ => v
    end
    | None0 () => let
      val () = ETRACE_MSG ("======== evallst :: E0XPvar :: None0 needs ", 
        ETRACE_LEVEL_DEBUG)
      val () = ETRACE_OPR (($Symbol.print_symbol sym; print_newline ()), ETRACE_LEVEL_DEBUG)
    in
      abort (ERRORCODE_TYPE_ERROR)
    end
  end
  (* | _ => abort (ERRORCODE_TYPE_ERROR) *)
  (* end of [eval] *)

(* extern fun fill_args (arglst: $Absyn.a0rglst, v: v0al): option0 env *)
implement fill_args (arglst, v) = let
  val args_len = list0_length (arglst)
  val env = symenv_make ()
in
  if args_len = 1 then let
    val- cons (arg, nil ()) = arglst
  in
    Some0 ($Symbol.symenv_insert (env, arg.a0rg_nam, v))
  end
  else if args_len = 0 then case+ v of
  | V0ALtup (nil ()) => Some0 (env)
  | _ => None0
  else case+ v of
  | V0ALtup vs => if args_len <> list0_length (vs) then None0 else let
    val syms_vs = list0_map2_fun<$Absyn.a0rg, v0al> (
        arglst, vs, lam (arg, v) => @(arg.a0rg_nam, v))
  in
    Some0 (list0_fold_left<env>< @(sym, v0al)> (
             lam (init, x) => $Symbol.symenv_insert (init, x.0, x.1), 
             env, syms_vs)
          )
  end
  | _ => None0
end

(* extern fun eval_d0eclst (env: env, decs: $Absyn.d0eclst): env *)
implement eval_d0eclst (env, decs) = list0_fold_left (
  lam (x,y) => eval_d0ec (x, y), env, decs)

(* extern fun eval_d0ec (env: env, dec: $Absyn.d0ec): env *)
implement eval_d0ec (env, dec) = let
  val+ $Absyn.D0ECval (isrec, valdecs) = dec.d0ec_node
in
  if isrec = false then eval_v0aldeclst (env, valdecs)
  else eval_v0aldeclst_rec (env, valdecs)
end

(* extern fun eval_v0aldeclst (env: env, valdecs: $Absyn.v0aldeclst): env *)
implement eval_v0aldeclst (env, valdecs) = list0_fold_left (
  lam (x,y) => eval_v0aldec (x, y), env, valdecs)

(* extern fun eval_v0aldeclst_rec (env: env, valdecs: $Absyn.v0aldeclst): env *)
implement eval_v0aldeclst_rec (env, valdecs) = let
  fun fillin_env (env: env, valdecs: $Absyn.v0aldeclst): env =
    case+ valdecs of
    | cons (valdec, valdecs1) => let
      val env' = $Symbol.symenv_insert (
        env, valdec.v0aldec_nam, V0ALref (ref_make_elt<v0al> (V0ALint 825)))
    in
      fillin_env (env', valdecs1)
    end
    | nil () => env

  val env1 = fillin_env (env, valdecs)
in
 list0_fold_left (
   lam (x,y) => eval_v0aldec_rec (x, y), env1, valdecs)
end


(* extern fun eval_v0aldec (env: env, valdec: $Absyn.v0aldec): env *)
implement eval_v0aldec (env, valdec) = let
  val () = ETRACE_MSG ("======== eval_v0aldec ", ETRACE_LEVEL_DEBUG)
  val () = ETRACE_OPR (($Symbol.print_symbol valdec.v0aldec_nam; print_newline ()), 
    ETRACE_LEVEL_DEBUG)
  val v = eval (env, valdec.v0aldec_def)
in
  $Symbol.symenv_insert (env, valdec.v0aldec_nam, v)
end

(* extern fun eval_v0aldec_rec (env: env, valdec: $Absyn.v0aldec): env *)
implement eval_v0aldec_rec (env, valdec) = let
  val () = ETRACE_MSG ("======== eval_v0aldec_rec ", ETRACE_LEVEL_DEBUG)
  val () = ETRACE_OPR (($Symbol.print_symbol valdec.v0aldec_nam; print_newline ()), 
    ETRACE_LEVEL_DEBUG)
  val v = eval (env, valdec.v0aldec_def)
  val val_opt = $Symbol.symenv_lookup (env, valdec.v0aldec_nam)
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

(* extern fun eval_opr (opr: $Absyn.opr, vs: v0allst): v0al *)
implement eval_opr (opr, vs) =
  case+ opr of
  | $Absyn.OPR sym => 
    if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_PLUS) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 + i2)
      | _ => ETRACE_MSG_OPR ("eval_opr + error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_MINUS) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 - i2)
      | _ => ETRACE_MSG_OPR ("eval_opr - error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_TIMES) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 * i2)
      | _ => ETRACE_MSG_OPR ("eval_opr * error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_SLASH) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALint (i1 / i2)
      | _ => ETRACE_MSG_OPR ("eval_opr / error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_UMINUS) then case+ vs of
      | cons (V0ALint i1, nil ()) => V0ALint (0 - i1)
      | _ => ETRACE_MSG_OPR ("eval_opr ~ error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_GT) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 > i2)
      | _ => ETRACE_MSG_OPR ("eval_opr > error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_GTE) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 >= i2)
      | _ => ETRACE_MSG_OPR ("eval_opr >= error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_LT) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 < i2)
      | _ => ETRACE_MSG_OPR ("eval_opr < error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_LTE) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 <= i2)
      | _ => ETRACE_MSG_OPR ("eval_opr <= error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_EQ) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 = i2)
      | _ => ETRACE_MSG_OPR ("eval_opr = error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_NEQ) then case+ vs of
      | cons (V0ALint i1, cons (V0ALint i2, nil ())) => V0ALbool (i1 <> i2)
      | _ => ETRACE_MSG_OPR ("eval_opr <> error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_PRINT_INT) then case+ vs of
      | cons (V0ALint i, nil ()) => let
        val () = print_int (i)
      in
        V0ALtup (nil)
      end
      | _ => ETRACE_MSG_OPR ("eval_opr print_int error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
    else if $Symbol.eq_symbol_symbol (sym, $Symbol.symbol_PRINT) then case+ vs of
      | cons (V0ALstr str, nil ()) => let
        val () = print str
      in
        V0ALtup (nil)
      end
      | _ => ETRACE_MSG_OPR ("eval_opr print error\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))

    else ETRACE_MSG_OPR ("eval_opr unsupported opr\n", ETRACE_LEVEL_ERROR, 
             abort (ERRORCODE_TYPE_ERROR))
  (* end of [eval_opr] *)

(* ****** ****** *)

(* end of [interp-1.dats] *)



