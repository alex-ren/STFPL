(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans1.sats"
staload "trans2.sats"
staload "error.sats"
staload "symbol.sats"
staload "libfunctions.sats"

staload _(*anon*) = "symbol.dats"

typedef opr = $Absyn.opr
typedef loc = $Posloc.location_t
typedef symbol = $Symbol.symbol_t
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
staload _(*anon*) = "prelude/DATS/reference.dats" 

#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

#define Some0 option0_some
#define None0 option0_none

fun{a:t@ype} list0_locate (
  xs: list0 a, pred: a -<cloref1> bool): option0 int = let
  fun loop (xs: list0 a, pred: a -<cloref1> bool, accu: int): 
  option0 int = 
    case+ xs of
    | cons (x, xs1) => if pred (x) then Some0 accu else loop (xs1, pred, accu + 1)
    | nil () => None0
in
  loop (xs, pred, 0)
end

fun trans2_typlst (t1yplst: t1yplst): t2yplst =
  list0_map_fun (t1yplst, lam x => trans2_typ x)

implement trans2_typ (t1yp) = let
in
  case+ t1yp of
  | T1YPbase sym => (
    case+ 0 of 
    | _ when sym = symbol_BOOL => T2YPbool
    | _ when sym = symbol_INT => T2YPint
    | _ when sym = symbol_STRING => T2YPstr
    | _ => ETRACE_MSG_OPR ("trans2_typ unknown base type\n", 
      ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
    )
  | T1YPfun (nargs_ref, arg, ret) => let
    val t2yp_ret = trans2_typ (ret)
    val t2yp_arg = trans2_typ (arg)    
    val t2yp_args = (if !nargs_ref = 0 then nil
                    else if !nargs_ref = 1 then cons (t2yp_arg, nil)
                    else (case+ t2yp_arg of
                          | T2YPtup (t2yp_args) => t2yp_args
                          | _ => ETRACE_MSG_OPR ("trans2_typ must be tuple\n", 
                          ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
                         ): t2yplst
                    ): t2yplst
 
    val t2yp_args = cons (T2YPenv, t2yp_args)  // add an extra type for first parameter
    // val () = fprint_string (stderr_ref, "\nnargs is " + 
    //   tostring_int !nargs_ref)
  in
    T2YPclo (!nargs_ref + 1, t2yp_args, t2yp_ret)
  end
  | T1YPtup t1yplst => T2YPtup (trans2_typlst (t1yplst))
  | T1YPlist (X) => let
    val t = t1Var_get_typ (X)
    val t2yp = trans2_typ t
  in
    T2YPlist t2yp
  end
  | _ => ETRACE_MSG_OPR ("trans2_typ cannot process such t1yp\n", 
          ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
end

implement make_valprim (node, typ) = '{
  valprim_node = node,
  valprim_typ = typ
}

extern val tmpvar_void: tmpvar;

fun instr_add (
  res: &instrlst, x: instr
) : void = res := list0_cons (x, res)

fun instr_make (loc: loc, ins_node: instr_node): instr = '{
  instr_loc = loc, instr_node = ins_node
}  // end of [instr_make]

(* fully reverse *)
fun instr_reverse (instrs: instrlst): instrlst = let
  fun loop (instrs: instrlst, accu: instrlst): instrlst =
    case+ instrs of
    | cons (instr, instrs1) => let
      val inode = instr.instr_node
      val iloc = instr.instr_loc
    in
      case+ inode of
      | INSTRcond (tmpv, typ, vp, ins_then, ins_else) => let
        val ins_then1 = instr_reverse (ins_then)
        val ins_else1 = instr_reverse (ins_else)
        val inode1 = INSTRcond (tmpv, typ, vp, ins_then1, ins_else1)
        val instr1 = instr_make (iloc, inode1)
        val accu = instr1 :: accu
      in
        loop (instrs1, accu)
      end
      | _ => loop (instrs1, instr :: accu)
    end
    | nil () => accu
in
  loop (instrs, nil)
end

local  // tmpvar
assume tmpvar_t = symbol_t
val tmpvar_count = ref<int> (0)
val tmpvar_prefix = "v_": string
in

implement tmpvar_void = symbol_make_name ("dummy_void")
// must be put here
val valprim_void = make_valprim (VPtup (tmpvar_void, list0_nil), T2YPtup nil)  

implement tmpvar_new_anon () = let
  val i = !tmpvar_count
  val () = !tmpvar_count := i + 1

  val id = tostring_int (i)
  val name = string0_append (tmpvar_prefix, id)
in
  symbol_make_name (name)
end

implement tmpvar_new_v1ar (v) = let
  val nam = symbol_get_name (v.v1ar_nam)
in
  tmpvar_new_string (nam)
end

implement tmpvar_new_string (str) = let
  val i = !tmpvar_count
  val () = !tmpvar_count := i + 1

  val id = tostring_int (i)
  val fullname = string0_append (tmpvar_prefix, string0_append (str, id))
in
  symbol_make_name (fullname)
end

implement tmpvar_new_string_name (str) = let
in
  symbol_make_name (str)
end

implement tmpvar_get_name (v) = let
  val ret = symbol_get_name (v)
in
  ret
end  
end // [end of local]

local
  extern castfn valprim_encode (x: valprim): valprim_t
  extern castfn valprim_decode (x: valprim_t): valprim
in
  fun v1ar_get_val
    (x: v1ar): option0 valprim = let
    val r = x.v1ar_val
  in
    case+ !r of
    | Some0 (vp) => Some0 (valprim_decode (vp))
    | None0 () => None0
  end // end of [v1ar_get_val]
  
  fun v1ar_set_val (
    x: v1ar, vp: valprim
  ) : void = let
    val r = x.v1ar_val
    val vp = valprim_encode (vp)
    val () = !r := Some0 (vp)
  in
    // nothing
  end // [v1ar_set_val]
  
end // end of [local]

typedef funent = '{
  funent_fun = funlab_t
, funent_narg = int
, funent_args = valprimlst
, funent_body = instrlst
, funent_ret = valprim
, funent_env = valprimlst
}

assume funent_t = funent


implement funent_get_lab (ent) = ent.funent_fun
implement funent_get_narg (ent) = ent.funent_narg
implement funent_get_args (ent) = ent.funent_args
implement funent_get_body (ent) = ent.funent_body
implement funent_get_ret (ent) = ent.funent_ret


(* ***** ****** *)

symintr funlab_make

extern fun funlab_make_anon (): funlab
extern fun funlab_make_name (f: v1ar): funlab  // similar v1ar's lead to different names

overload funlab_make with funlab_make_anon
overload funlab_make with funlab_make_name

(* ***** ****** *)

implement funent_make (
  fl, nargs, args, body, ret, env) = '{
  funent_fun = fl,
  funent_narg = nargs,
  funent_args = args,
  funent_body = body,
  funent_ret = ret,
  funent_env = env
  }

(*
There is a global map for this function:
*)
extern fun funent_add (fl: funlab, ent: funent): void
extern fun funent_lookup (fl: funlab): funent
extern fun funent_getall (): list0 funent

local
val funlab_count = ref<int> (0)
assume funlab_t = symbol_t
val fun_table = ref<symenv_t (funent)> (symenv_make ())
val fl_prefix = "f_": string
in

implement funlab_get_name (fl) = symbol_get_name (fl)

implement funlab_make_name (f) = let
  val nam = symbol_get_name (f.v1ar_nam)
  val i = !funlab_count
  val () = !funlab_count := i + 1
  val id = tostring_int (i)
  val fullname = fl_prefix + nam + "_" + id
in
  symbol_make_name (fullname)
end

implement funlab_make_anon () = let
  val nam = "lam"
  val i = !funlab_count
  val () = !funlab_count := i + 1
  val id = tostring_int (i)
  val fullname = fl_prefix + nam + "_" + id
in
  symbol_make_name (fullname)
end

implement funlab_allocate (nam) =  nam

implement funent_add (fl, ent) = let
  val table = !fun_table
  val table = symenv_insert (table, fl, ent)
  val () = !fun_table := table
in
end

implement funent_getall () = let
  fun helper (x: @(symbol_t, funent)): funent = x.1
  val xs = symenv_listize<funent> (!fun_table)
in
  list0_map_fun< @(symbol_t, funent)><funent> (xs, helper)
end

implement mainlab = symbol_make_name ("__main")

end // end of [local]

(* ****** ****** *)
fun instr_add_call (loc: loc, tmpv: tmpvar,
  vpf: valprim, vpargs: valprimlst, typ: t2yp, res: &instrlst): void = let
  val ins_node = INSTRcall (tmpv, vpf, vpargs, typ)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_call]

fun instr_add_cond (loc: loc, tmpv: tmpvar, typ: t2yp, vp_test: valprim, 
  instr1: instrlst, instr2: instrlst, res: &instrlst): void = let
  val ins_node = INSTRcond (tmpv, typ, vp_test, instr1, instr2)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_cond]

fun instr_add_move (loc: loc, tmpv: tmpvar, vp: valprim, res: &instrlst): void = let
  val ins_node = INSTRmove_val (tmpv, vp)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_move]

fun instr_add_opr (loc: loc, tmpv: tmpvar, typ: t2yp, opr: opr, 
  vps: valprimlst, res: &instrlst): void = let
  val ins_node = INSTRopr (tmpv, typ, opr, vps)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_opr]

fun instr_add_tup (loc: loc, tmpv: tmpvar,
  vps: valprimlst, res: &instrlst): void = let
  val ins_node = INSTRtup (tmpv, vps)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_tup]

fun instr_add_proj (loc: loc, tmpv: tmpvar, typ: t2yp,
  vp: valprim, pos: int, res: &instrlst): void = let
  val ins_node = INSTRproj (tmpv, typ, vp, pos)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_proj]

fun instr_add_closure (loc: loc,
  tmpvar: tmpvar, fl: funlab, env: valprimlst, res: &instrlst): void = let
  val ins_node = INSTRclosure (tmpvar, fl, env)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end
(* ****** ****** *)

extern fun aux_exp (e: e1xp, res: &instrlst): valprim

(* ret is supposed to be used in the evaluation *)
extern fun aux_exp_ret (e: e1xp, res: &instrlst, ret: tmpvar): valprim

(* this function only handle E1XPfixclo and E1XPlamclo and E1XPann *)
(* caller guarantees that e is a function *)
extern fun aux_exp_fun (e: e1xp, fl: funlab, 
  res: &instrlst, init_res: instrlst): valprim

fun auxlst_exp (
  es: e1xplst, res: &instrlst
) : valprimlst = case+ es of
  | list0_cons (e, es) => let
      val v = aux_exp (e, res)
      val vs = auxlst_exp (es, res)
    in
      list0_cons (v, vs)
    end
  | list0_nil () => list0_nil ()

fun aux_v1ar_valprim (v: v1ar): valprim = let
  val vp_opt = v1ar_get_val (v)
in
  case+ vp_opt of
  | Some0 (vp) => vp
  | None0 () => ETRACE_MSG_OPR ("aux_v1ar v1ar doesn't have valprim\n", 
      ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
end

fun aux_v1ar_get_fl (v: v1ar): funlab_t = let
  val vp_opt = v1ar_get_val (v)
  // todo: add error
  val- Some0 (vp) = vp_opt
  val vp_node = vp.valprim_node
  val- VPclo (_, fl, _) = vp_node
in
  fl
end

(* get the content from v1ar *)
fun v1arlst_2_valprimlst (cloargs: v1arlst): valprimlst =
  list0_map_cloref<v1ar><valprim> (cloargs, 
                     lam x => aux_v1ar_valprim (x))

fun v1arlst_set_tmpvar (xs: v1arlst, n: int): int =
  case+ xs of
  | cons (x, xs) => let
      val tmpvar = tmpvar_new (x)
      val vp_node = VPtmp (tmpvar)
      val vp_typ = trans2_typ (x.v1ar_typ)
      val vp = make_valprim (vp_node, vp_typ)
      val () = v1ar_set_val (x, vp)
    in
      v1arlst_set_tmpvar (xs, n+1)
    end
  | nil () => n

fun v1arlst_set_env (xs: v1arlst, n: int): int =
  case+ xs of
  | cons (x, xs) => let
      val vp_node = VPenv (n)
      val vp_typ = trans2_typ (x.v1ar_typ)
      val vp = make_valprim (vp_node, vp_typ)
      val () = v1ar_set_val (x, vp)
    in
      v1arlst_set_env (xs, n+1)
    end
  | nil () => n

fun v1arlst_set_valprimlst (xs: v1arlst, vps: valprimlst): void =
  case+ (xs, vps) of
  | (cons (x, xs), cons (vp, vps)) => let
      val () = v1ar_set_val (x, vp)
    in
      v1arlst_set_valprimlst (xs, vps)
    end
  | (nil (), nil ()) => ()
  | (_, _) => ETRACE_MSG_OPR ("v1arlst_set_valprimlst: not of the same length\n", 
      ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))

(* f is not in cloargs *)
fun aux_exp_fix_lab
  (loc: loc, f: v1ar, v_args: v1arlst, e_body: e1xp, 
   fl: funlab, cloargs: v1arlst, res: &instrlst, init_res: instrlst): valprim = let

  // add new instruction to res
  val cloargs_valprims = v1arlst_2_valprimlst (cloargs)
  val fl_nam = funlab_get_name (fl)
  val f_tmpvar = tmpvar_new (fl_nam)
  val () = instr_add_closure (loc, f_tmpvar, fl, cloargs_valprims, res)

  // set parameters
  val nargs = v1arlst_set_tmpvar (v_args, 0)
  val args_valprims = v1arlst_2_valprimlst (v_args)

  // reset cloargs
  val ncloargs = v1arlst_set_env (cloargs, 0)
  val cloargs_valprims2 = v1arlst_2_valprimlst (cloargs)

  // add instructions to init_res
  // treat f specially, build an instruction for it
  var body_res: instrlst = init_res
  val () = instr_add_closure (loc, f_tmpvar, fl, cloargs_valprims2, body_res)

  val f_fun_typ = f.v1ar_typ
  val f_clo_typ = trans2_typ (f_fun_typ)
  val f_clo_node = VPclo (f_tmpvar, fl, cloargs_valprims2)
  val vp_f = make_valprim (f_clo_node, f_clo_typ)
  val () = v1ar_set_val (f, vp_f)

  // handle the body
  val vp_ret = aux_exp (e_body, body_res)
  val body_res = instr_reverse (body_res)

  
  val ncloargs = v1arlst_set_tmpvar (cloargs, 0)
  val cloargs_valprims3 = v1arlst_2_valprimlst (cloargs)
  // add 1 to include the env though it's not in args_valprims
  val ent = funent_make (fl, nargs + 1, args_valprims, body_res, 
                               vp_ret, cloargs_valprims3)
  val () = funent_add (fl, ent)

  // Caution: turn it back
  val () = v1arlst_set_valprimlst (cloargs, cloargs_valprims)

  val f_clo_node = VPclo (f_tmpvar, fl, cloargs_valprims)
  val f_clo = make_valprim (f_clo_node, f_clo_typ)
in
  f_clo
end

fun aux_exp_lam_lab (
  loc: loc, v_args: v1arlst, e_body: e1xp, fl: funlab,
  cloargs: v1arlst, res: &instrlst, init_res: instrlst): valprim = let
  val () = ETRACE_MSG ("aux_exp_lam_lab\n", ETRACE_LEVEL_DEBUG)

  val cloargs_valprims = v1arlst_2_valprimlst (cloargs)
  val fl_nam = funlab_get_name (fl)
  val f_tmpvar = tmpvar_new (fl_nam)
  val () = instr_add_closure (loc, f_tmpvar, fl, cloargs_valprims, res)

  // set parameters
  val nargs = v1arlst_set_tmpvar (v_args, 0)
  val args_valprims = v1arlst_2_valprimlst (v_args)

  // reset cloargs
  val ncloargs = v1arlst_set_env (cloargs, 0)

  // handle the body
  var body_res: instrlst = init_res
  val vp_ret = aux_exp (e_body, body_res)
  val body_res = instr_reverse (body_res)

  val ncloargs = v1arlst_set_tmpvar (cloargs, 0)
  val cloargs_valprims2 = v1arlst_2_valprimlst (cloargs)

  // add 1
  val ent = funent_make (fl, nargs + 1, args_valprims, body_res, vp_ret, cloargs_valprims2)
  val () = funent_add (fl, ent)

  // Caution: turn it back
  val () = v1arlst_set_valprimlst (cloargs, cloargs_valprims)

  val t2yp_args = list0_map_fun<valprim><t2yp> (args_valprims, lam x => x.valprim_typ)
  val t2yp_ret = vp_ret.valprim_typ
  // add extra T2YPenv
  val f_clo_typ = T2YPclo (nargs + 1, cons (T2YPenv, t2yp_args), t2yp_ret)
  val f_clo_node = VPclo (f_tmpvar, fl, cloargs_valprims)
  val f_clo = make_valprim (f_clo_node, f_clo_typ)
in
  f_clo
end

(* extern fun aux_exp (e: e1xp, res: &instrlst): valprim *)
implement aux_exp (e, res) = let
  val () = ETRACE_MSG ("trans2_exp\n", ETRACE_LEVEL_DEBUG)
in (
  case e.e1xp_node of
  | E1XPann (e, _) => aux_exp (e, res)
  | E1XPapp (_, _) => wrapper (e, res)
  | E1XPbool b => make_valprim (VPbool (b), T2YPbool)
  | E1XPfix (_, _, _, _) => let
    val fl = funlab_make_anon ()
  in
    aux_exp_fun (e, fl, res, nil)
  end
  | E1XPif (_, _, _) => wrapper (e, res)
  | E1XPint i => make_valprim (VPint (i), T2YPint)
  | E1XPlam (_, _, _) => let
    val fl = funlab_make_anon ()
  in
    aux_exp_fun (e, fl, res, nil)
  end
  | E1XPlet (_, _) => wrapper (e, res)
  | E1XPopr (_, _) => wrapper (e, res)
  | E1XPproj (_, _) => wrapper (e, res)
  | E1XPstr (str) => make_valprim (VPstr (str), T2YPstr)
  | E1XPtup exps => wrapper (e, res)
  | E1XPvar v => let
    val vp_opt = v1ar_get_val (v)
  in
    case+ vp_opt of
    | Some0 (vp) => vp
    | None0 () => let
      val vp_opt = libFunVPFind (v.v1ar_nam)  // libaray function
    in
      case+ vp_opt of
      | Some0 vp => vp
      | None0 () => ETRACE_MSG_OPR ("aux_exp v1ar doesn't have valprim\n", 
           ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
    end
  end): valprim where {
  fun wrapper (e: e1xp, res: &instrlst): valprim = let
      val tmp_ret = tmpvar_new ()
    in
      aux_exp_ret (e, res, tmp_ret)
  end
  } // end of [where]
end

// end of [aux_exp]

(* ****** ****** *)
fun aux_exp_ret_if (loc: loc, e_test: e1xp, e_then: e1xp, oe_else: e1xpopt, 
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val v_test = aux_exp (e_test, res)

  var res_then: instrlst = list0_nil
  val v_then = aux_exp (e_then, res_then)
  val () = instr_add_move (e_then.e1xp_loc, tmp_ret, v_then, res_then)

  var res_else: instrlst = list0_nil
  val (v_else, loc_else) = (case+ oe_else of
    | Some0 e_else => (aux_exp (e_else, res_else), e_else.e1xp_loc)
    | None0 () => let
      // val () = ETRACE_MSG ("aux_exp_ret_if -- else is none\n", ETRACE_LEVEL_DEBUG)
    in
      (valprim_void, e_then.e1xp_loc)  // use the location of then
    end
    )
  val () = instr_add_move (loc_else, tmp_ret, v_else, res_else)
  
  val () = instr_add_cond (loc, tmp_ret, v_then.valprim_typ, 
                            v_test, res_then, res_else, res)
in
  make_valprim (VPtmp (tmp_ret), v_then.valprim_typ)
end

fun aux_exp_ret_opr (loc: loc, opr: opr, t1yp: t1yp(*return typ*), 
  exps: e1xplst, res: &instrlst, tmp_ret: tmpvar): valprim = let
  val vps = auxlst_exp (exps, res)

  val t2yp = trans2_typ (t1yp)

  val () = instr_add_opr (loc, tmp_ret, t2yp, opr, vps, res)

  val opr_typ_opt = libOprTypFind (opr)
  val opr_typ = (case+ opr_typ_opt of
                | Some0 opt_typ => opt_typ
                | None0 () => ETRACE_MSG_OPR ("aux_exp_ret_opr: opr not found\n", 
                  ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
                ): t1yp
  val ret_typ = (case+ opr_typ of
                | T1YPfun (_, _, ret_typ) => ret_typ
                | _ => ETRACE_MSG_OPR ("aux_exp_ret_opr opr should have function type\n", 
                  ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
                ): t1yp
  val ret_typ = trans2_typ ret_typ // so far, no opr returns closure
in
  make_valprim (VPtmp (tmp_ret), ret_typ)
end

(* generating init instructions for functions *)
(* initilize the recursively defined closures *)
(* r1: round 1 *)
fun aux_exp_v1aldeclst_rec_r1 (v1aldecs: v1aldeclst, 
  init_res: &instrlst): void =
  case+ v1aldecs of
  | cons (v1aldec, v1aldecs1) => let
    val v = v1aldec.v1aldec_var
    val e = v1aldec.v1aldec_def
    val e_node = e.e1xp_node
    val env_opt = e1xp_node_fun_get_env (e_node)
    val () = (case+ env_opt of
      | Some0 env => let
        // save the original content
        val cloargs_valprims_old = v1arlst_2_valprimlst (env)
        // set to new ones
        val ncloargs = v1arlst_set_env (env, 0)
        val cloargs_valprims = v1arlst_2_valprimlst (env)

        // set the old one back
        val () = v1arlst_set_valprimlst (env, cloargs_valprims_old)
        
        val fl = funlab_make (v)
        val fl_nam = funlab_get_name (fl)
        val f_tmpvar = tmpvar_new (fl_nam)
        val () = instr_add_closure (v1aldec.v1aldec_loc, f_tmpvar, fl,
              cloargs_valprims, init_res)

        val f_fun_typ = v.v1ar_typ
        val f_clo_typ = trans2_typ (f_fun_typ)
        val f_clo_node = VPclo (f_tmpvar, fl, cloargs_valprims)
        val vp_f = make_valprim (f_clo_node, f_clo_typ)
        val () = v1ar_set_val (v, vp_f)
      in end
      | None0 () => ()
    ): void
    in 
      aux_exp_v1aldeclst_rec_r1 (v1aldecs1, init_res)
    end
  | nil () => ()

        
(* translating each functions *)
(* r2: round 2 *)
fun aux_exp_v1aldeclst_rec_r2 (v1aldecs: v1aldeclst, 
  res: &instrlst, init_res: instrlst): valprimlst =
  case+ v1aldecs of
  | cons (v1aldec, v1aldecs1) => let
    val v = v1aldec.v1aldec_var
    val e = v1aldec.v1aldec_def
    val e_node = e.e1xp_node
    val fun_env_opt = e1xp_node_fun_get_env (e_node)
    val vp = (case+ fun_env_opt of
        | Some0 env => let
          val fl = aux_v1ar_get_fl (v)

          // process the function
          val vp_fun = aux_exp_fun (e, fl, res, init_res)
        in
          vp_fun
        end 
        | None0 () => aux_exp_ret (e, res, tmpvar_new (v))
    ): valprim
  in
    cons (vp, aux_exp_v1aldeclst_rec_r2 (v1aldecs1, res, init_res))
  end
  | nil () => nil

(* set the recursively defined v1ar by closure value *)
(* r3: round 3 *)
fun aux_exp_v1aldeclst_rec_r3 (v1aldecs: v1aldeclst, 
  valprims: valprimlst): void =
  case+ (v1aldecs, valprims) of
  | (cons (v1aldec, v1aldecs1), cons (vp, vps1)) => let
    val () = v1ar_set_val (v1aldec.v1aldec_var, vp)
  in
    aux_exp_v1aldeclst_rec_r3 (v1aldecs1, vps1)
  end
  | (nil (), nil ()) => ()
  | (_, _) => ETRACE_MSG_OPR ("aux_exp_v1aldeclst_rec_r3 length not match\n", 
           ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))

fun aux_exp_v1aldeclst_rec (v1aldecs: v1aldeclst, res: &instrlst): void = let
  val () = ETRACE_MSG ("aux_exp_v1aldeclst_rec\n", ETRACE_LEVEL_DEBUG)
  var init_res: instrlst = nil
  val () = aux_exp_v1aldeclst_rec_r1 (v1aldecs, init_res)
  val vps = aux_exp_v1aldeclst_rec_r2 (v1aldecs, res, init_res)
  val () = aux_exp_v1aldeclst_rec_r3 (v1aldecs, vps)
in
  ()
end

fun aux_exp_v1aldeclst_norec (v1aldecs: v1aldeclst, res: &instrlst): void = let
  val () = ETRACE_MSG ("aux_exp_v1aldeclst_norec\n", ETRACE_LEVEL_DEBUG)
in
  case+ v1aldecs of
  | cons (v1aldec, v1aldecs1) => let
    val v = v1aldec.v1aldec_var
    val e = v1aldec.v1aldec_def
    val e_node = e.e1xp_node
    val vp = 
      if e1xp_node_is_fun (e_node) = true then let
        val fl = funlab_make_name (v)
        val vp_fun = aux_exp_fun (e, fl, res, nil) // no init instructions
      in vp_fun end
      else let
        val vp = aux_exp_ret (e, res, tmpvar_new (v))
      in vp end
    val () = v1ar_set_val (v, vp)
  in
    aux_exp_v1aldeclst_norec (v1aldecs1, res)
  end
  | nil () => let
  in
    ()
  end
end

fun aux_exp_d1eclst (d1ecs: d1eclst, res: &instrlst): void =
  case+ d1ecs of
  | cons (d1ec, d1ecs1) => let
    val+ D1ECval (isrec, v1aldecs) = d1ec.d1ec_node 

    val () = (if isrec = true then aux_exp_v1aldeclst_rec (v1aldecs, res)
             else aux_exp_v1aldeclst_norec (v1aldecs, res))
  in
    aux_exp_d1eclst (d1ecs1, res)
  end
  | nil () => ()

fun aux_exp_ret_let (loc: loc, d1ecs: d1eclst, e1xp: e1xp, 
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val () = aux_exp_d1eclst (d1ecs, res)
in
  aux_exp_ret (e1xp, res, tmp_ret)
end

fun aux_exp_ret_proj (loc: loc, e1xp: e1xp, pos: int, 
  res: &instrlst, tmp_ret: tmpvar, t1yp: t1yp): valprim = let
  val t2yp = trans2_typ (t1yp)
  val vp = aux_exp (e1xp, res)

  val () = 
    (case+ vp.valprim_node of  // todo seems unnecessary
    | VPenv _ => instr_add_proj (loc, tmp_ret, t2yp, vp, pos, res)
    | VPtmp _ => instr_add_proj (loc, tmp_ret, t2yp, vp, pos, res)
    | VPtup _ => instr_add_proj (loc, tmp_ret, t2yp, vp, pos, res)
    | _ => ETRACE_MSG_OPR ("aux_exp_ret_proj left part is not a tuple\n", 
           ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
    )
in
  make_valprim (VPtmp (tmp_ret), t2yp)
end

fun aux_exp_ret_app (loc: loc, e_fun: e1xp, e_arg: e1xp,
  res: &instrlst, tmp_ret: tmpvar, t1yp: t1yp): valprim = let
  // return type
  val t2yp = trans2_typ (t1yp)

  val vp_clo = aux_exp (e_fun, res)
  val clo_typ = vp_clo.valprim_typ
  // todo I am lazy now
  val- T2YPclo (nargs, _, _) = clo_typ

  val vp_arg = aux_exp (e_arg, res)

  val vp_args = (if nargs = 2 (*env has been counted in*) 
         then cons (vp_arg, nil) else 
           case+ vp_arg.valprim_node of
           | VPtup (_, vp_args) => vp_args
           | _ => ETRACE_MSG_OPR ("aux_exp_ret_app argument is not tuple\n", 
           ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
           ): valprimlst
  val () = instr_add_call (loc, tmp_ret, vp_clo, vp_args, t2yp, res)
in
  make_valprim (VPtmp (tmp_ret), t2yp)
end

fun aux_exp_ret_tuple (loc: loc, e1xps: e1xplst,
  res: &instrlst, tmp_ret: tmpvar, t1yp: t1yp): valprim = let
  val t2yp = trans2_typ (t1yp)
  val vps = auxlst_exp (e1xps, res)
  val () = instr_add_tup (loc, tmp_ret, vps, res)
in
  make_valprim (VPtup (tmp_ret, vps), t2yp)
end

implement
aux_exp_ret (e, res, ret) = let
  val loc = e.e1xp_loc
  val typ = e.e1xp_typ
  // val () = ETRACE_MSG ("aux_exp_ret\n", ETRACE_LEVEL_DEBUG)
in
  case e.e1xp_node of
  | E1XPann (e, _) => aux_exp_ret (e, res, ret)
  | E1XPapp (e_fun, e_arg) => aux_exp_ret_app (loc, e_fun, e_arg, res, ret, typ)
  | E1XPbool _ => aux_exp (e, res)
  | E1XPfix (_, _, _, _) => ETRACE_MSG_OPR ("aux_exp_ret shouldn't handle E1XPfix\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
  | E1XPif (e_test, e_then, oe_else) => 
    aux_exp_ret_if (loc, e_test, e_then, oe_else, res, ret)
  | E1XPint _ => aux_exp (e, res)
  | E1XPlam (_, _, _) => ETRACE_MSG_OPR ("aux_exp_ret shouldn't handle E1XPlam\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
  | E1XPlet (d1ecs, e1xp) => aux_exp_ret_let (loc, d1ecs, e1xp, res, ret)
  | E1XPopr (opr, exps) => let
  in
    aux_exp_ret_opr (loc, opr, typ, exps, res, ret)
  end
  | E1XPproj (e1xp, pos) => let
  in
    aux_exp_ret_proj (loc, e1xp, pos, res, ret, typ)
  end
  | E1XPstr _ => aux_exp (e, res)
  | E1XPtup e1xps => aux_exp_ret_tuple (loc, e1xps, res, ret, typ)
  | E1XPvar _ => aux_exp (e, res)
end

(* extern fun aux_exp_fun (e: e1xp, fl: funlab): valprim *)
(* this function only handle E1XPfix and E1XPlam and E1XPann *)
implement aux_exp_fun (e, fl, res, init_res) = let
  val () = ETRACE_MSG ("aux_exp_lam_fun\n", ETRACE_LEVEL_DEBUG)
in
  case+ e.e1xp_node of
  | E1XPann (e1, _) => aux_exp_fun (e1, fl, res, init_res)
  | E1XPfix (f, args, body, ref_env) => 
    aux_exp_fix_lab (e.e1xp_loc, f, args, body, fl, !ref_env, res, init_res)
  | E1XPlam (args, body, ref_env) => 
    aux_exp_lam_lab (e.e1xp_loc, args, body, fl, !ref_env, res, init_res)
  | _ => ETRACE_MSG_OPR ("aux_exp_fun handle non-function\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
end
(* ****** ****** *)


(*
trans2_exp (e: e1xp): instrlst
*)
implement
trans2_exp (e) = let
  val () = ETRACE_MSG ("trans2_exp\n", ETRACE_LEVEL_DEBUG)

  var res: instrlst = list0_nil ()
  var env: v1arlst = list0_nil ()
  val v = aux_exp (e, res)
  (* reverse the main let *)
  val res = instr_reverse (res)

  val fns = funent_getall ()

in
  (res, fns)
end

(* ****** ****** *)
implement fprint_valprim (out, vp) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case+ vp.valprim_node of
  | VPenv pos => prstr ("env[" + tostring_int (pos) + "]")
  | VPbool b => prstr ("bool(" + tostring_bool b + ")")
  | VPclo (_, fl, _) => let
    val f_name = funlab_get_name (fl)
  in
    prstr ("closure(" + f_name + ")")
  end
  | VPint (i) => prstr ("int(" + (tostring_int i) + ")")
  | VPstr s => prstr ("str(" + s + ")")
  | VPtmp (_) => prstr "any"
  | VPtup (_, _) => prstr "tuple(...)"
end

implement fprint_valprimlst (out, vps) = let
  macdef prstr (s) = fprint_string (out, ,(s))
  fun loop (out: FILEref, vps: valprimlst, i: int):<cloref1> void = let
    macdef prstr (s) = fprint_string (out, ,(s))
  in
    case+ vps of
    | cons (vp, vps1) => (if i > 0 then prstr ", ";
                         fprint_valprim (out, vp);
                         loop (out, vps1, i + 1)
                         )
    | nil () => ()
  end
in
  prstr "(";
  loop (out, vps, 0);
  prstr ")"
end

implement fprint_instr (out, ins) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case+ ins.instr_node of
  | INSTRcall (tmpvar, f, args, _) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\ncall{";
    fprint_valprim (out, f);
    prstr "@";
    fprint_valprimlst (out, args);
    prstr "}"
  end
  | INSTRcond (tmpvar, typ, vp_test, instrlst_then, instrlst_else) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\nif{...}"
  end
  | INSTRmove_val (tmpvar, vp) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\nret <= ";
    fprint_valprim (out, vp)
  end
  | INSTRopr (tmpvar, typ, opr, vps) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\nopr{...}"
  end
  | INSTRtup (tmpvar, vps) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\ntuple{...}"
  end
  | INSTRclosure (tmpvar, fl, vps) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\nclosure{...}"
  end
  | INSTRproj (tmpvar, typ, vp, pos) => let
    val ret = tmpvar_get_name (tmpvar)
  in
    prstr "\nproj{...}"
  end
end
    

implement fprint_instrlst (out, inslst) = let
  macdef prstr (s) = fprint_string (out, ,(s))
  fun loop (out: FILEref, inslst: instrlst, i: int): void = let
    macdef prstr (s) = fprint_string (out, ,(s))
  in
    case+ inslst of
    | cons (ins, inses1) => (if i > 0 then prstr "\n ";
                         fprint_instr (out, ins);
                         loop (out, inses1, i + 1)
                         )
    | nil () => ()
  end
in
  prstr "instrlst{";
  loop (out, inslst, 0);
  prstr "}"
end


(* end of [trans2.dats] *)





