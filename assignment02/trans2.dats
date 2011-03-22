(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans1.sats"
staload "trans2.sats"
staload "error.sats"
staload "symbol.sats"

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
      | INSTRcond (tmpv, vp, ins_then, ins_else) => let
        val ins_then1 = instr_reverse (ins_then)
        val ins_else1 = instr_reverse (ins_else)
        val inode1 = INSTRcond (tmpv, vp, ins_then1, ins_else1)
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

symintr tmpvar_new
extern fun tmpvar_new_anon (): tmpvar_t
extern fun tmpvar_new_name (v: v1ar): tmpvar_t
overload tmpvar_new with tmpvar_new_anon
overload tmpvar_new with tmpvar_new_name

local
assume tmpvar_t = symbol_t
val tmpvar_count = ref<int> (0)
val tmpvar_prefix = "__v_": string
in

implement tmpvar_void = symbol_make_name ("dummy_void")
val valprim_void = VPtup (tmpvar_void, list0_nil)  // todo must be put here

implement tmpvar_new_anon () = let
  val i = !tmpvar_count
  val () = !tmpvar_count := i + 1

  val id = tostring_int (i)
  val name = string0_append (tmpvar_prefix, id)
in
  symbol_make_name (name)
end

implement tmpvar_new_name (v) = let
  val nam = symbol_get_name (v.v1ar_nam)

  val i = !tmpvar_count
  val () = !tmpvar_count := i + 1

  val id = tostring_int (i)
  val fullname = string0_append (tmpvar_prefix, string0_append (nam, id))
in
  symbol_make_name (fullname)
end

implement tmpvar_get_name (v) = let
  // val () = printf ("tmpvar_get_name\n", @())
  val ret = symbol_get_name (v)
  // val () = printf ("tmpvar_get_name10\n", @())
in
  ret
end

end

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
  
  fun v1ar_initset_val (
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
  funent_fun= funlab_t
, funent_narg= int
, funent_body= instrlst
, funent_ret= valprim
}

assume funent_t = funent


implement funent_get_lab (ent) = ent.funent_fun
implement funent_get_narg (ent) = ent.funent_narg
implement funent_get_body (ent) = ent.funent_body
implement funent_get_ret (ent) = ent.funent_ret


implement funent_make_label (fl, nargs, body, ret) = 
  '{funent_fun = fl,
    funent_narg = nargs,
    funent_body = body,
    funent_ret = ret
    }

(* ***** ****** *)

symintr funlab_make

extern fun funlab_make_anon (): funlab
extern fun funlab_make_name (f: v1ar): funlab  // simiar v1ar's lead to different names

overload funlab_make with funlab_make_anon
overload funlab_make with funlab_make_name

(* ***** ****** *)

fun funent_make (
  label: funlab, narg: int, body: instrlst, ret: valprim): funent = '{
  funent_fun= label,
  funent_narg= narg,
  funent_body= body,
  funent_ret= ret
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
val fl_prefix = "__f_": string
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

end

(* ****** ****** *)

extern fun aux_exp (e: e1xp, res: &instrlst): valprim

(* ret is supposed to be used in the evaluation *)
extern fun aux_exp_ret (e: e1xp, res: &instrlst, ret: tmpvar): valprim

(* this function only handle E1XPfix and E1XPlam and E1XPann *)
extern fun aux_exp_fun (e: e1xp, fl: funlab): valprim

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

fun aux_exp_fix_lab
  (f: v1ar, v_args: v1arlst, e_body: e1xp, fl: funlab): valprim = let
  val vp_fun = VPfun (fl)
  val () = v1ar_initset_val (f, vp_fun)
  val narg = loop (v_args, 0) where {
    fun loop (xs: v1arlst, n: int): int =
      case+ xs of
      | cons (x, xs) => let
          val vp = VParg (n)
          val () = v1ar_initset_val (x, vp)
        in
          loop (xs, n+1)
        end
      | nil () => n
  }
  var res: instrlst = nil
  val vp_ret = aux_exp (e_body, res)
  val res = instr_reverse (res)
  val ent = funent_make (fl, narg, res, vp_ret)
  val () = funent_add (fl, ent)
in
  VPfun (fl)
end

fun aux_exp_lam_lab (v_args: v1arlst, e_body: e1xp, fl: funlab): valprim = let
  (* handle the arguments *)
  val narg = loop (v_args, 0) where {
    fun loop (xs: v1arlst, n: int): int =
      case+ xs of
      | cons (x, xs) => let
          val vp = VParg (n)
          val () = v1ar_initset_val (x, vp)
        in
          loop (xs, n+1)
        end
      | nil () => n
  }
  var res: instrlst = nil
  val vp_ret = aux_exp (e_body, res)
  val res = instr_reverse (res)

  val ent = funent_make (fl, narg, res, vp_ret)
  val () = funent_add (fl, ent)
in
  VPfun (fl)
end

implement aux_exp (e, res) = (
  case e.e1xp_node of
  | E1XPann (e, _) => aux_exp (e, res)
  | E1XPapp (_, _) => wrapper (e, res)
  | E1XPbool b => VPbool (b)
  | E1XPfix (_, _, _) => let
    val fl = funlab_make_anon ()
  in
    aux_exp_fun (e, fl)
  end
  | E1XPif (_, _, _) => wrapper (e, res)
  | E1XPint i => VPint (i)
  | E1XPlam (_, _) => let
    val fl = funlab_make_anon ()
  in
    aux_exp_fun (e, fl)
  end
  | E1XPlet (_, _) => wrapper (e, res)
  | E1XPopr (_, _) => wrapper (e, res)
  | E1XPproj (_, _) => wrapper (e, res)
  | E1XPstr (str) => VPstr (str)
  | E1XPtup exps => wrapper (e, res)
  | E1XPvar v => let
    val vp_opt = v1ar_get_val (v)
  in
    case+ vp_opt of
    | Some0 (vp) => vp
    | None0 () =>
      ETRACE_MSG_OPR ("aux_exp v1ar doesn't have valprim\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
  end) where {
  fun wrapper (e: e1xp, res: &instrlst): valprim = let
      val tmp_ret = tmpvar_new ()
    in
      aux_exp_ret (e, res, tmp_ret)
  end
  } // end of [where]

// end of [aux_exp]
(* ****** ****** *)
fun instr_add_call (loc: loc, tmpv: tmpvar,
  vpf: valprim, vpargs: valprimlst, iswrapper: bool, res: &instrlst): void = let
  val ins_node = INSTRcall (tmpv, vpf, vpargs, iswrapper)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_call]

fun instr_add_cond (loc: loc, tmpv: tmpvar, vp_test: valprim, 
  instr1: instrlst, instr2: instrlst, res: &instrlst): void = let
  val ins_node = INSTRcond (tmpv, vp_test, instr1, instr2)
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

fun instr_add_opr (loc: loc, tmpv: tmpvar, opr: opr, 
  vps: valprimlst, res: &instrlst): void = let
  val ins_node = INSTRopr (tmpv, opr, vps)
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

fun instr_add_proj (loc: loc, tmpv: tmpvar,
  vp: valprim, pos: int, res: &instrlst): void = let
  val ins_node = INSTRproj (tmpv, vp, pos)
  val ins = instr_make (loc, ins_node)
  val () = instr_add (res, ins)
in
end  // end of [instr_add_proj]

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
      // val () = printf ("aux_exp_ret_if -- else is none\n", @())
    in
      (valprim_void, e_then.e1xp_loc)  // use the location of then
    end
    )
  val () = instr_add_move (loc_else, tmp_ret, v_else, res_else)
  
  val () = instr_add_cond (loc, tmp_ret, v_test, res_then, res_else, res)
in
  VPtmp (tmp_ret)
end

fun aux_exp_ret_opr (loc: loc, opr: opr, exps: e1xplst, 
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val vps = auxlst_exp (exps, res)
  val () = instr_add_opr (loc, tmp_ret, opr, vps, res)
in
  VPtmp (tmp_ret)
end

fun aux_exp_v1aldeclst (v1aldecs: v1aldeclst, res: &instrlst): void =
  case+ v1aldecs of
  | cons (v1aldec, v1aldecs1) => let
    val v1ar = v1aldec.v1aldec_var
    val vpopt = v1ar_get_val (v1ar)
    val vp = 
      case+ vpopt of
      | Some0 vp => 
        (case+ vp of
        // if exists sth. then must be funlab
        | VPfun fl => aux_exp_fun (v1aldec.v1aldec_def, fl)
        | _ => ETRACE_MSG_OPR (
          "aux_exp_v1aldeclst var has a valprim which is not VPfun\n",
          ETRACE_LEVEL_ERROR,
          abort (ERRORCODE_FORBIDDEN))
        )
      | None0 () => aux_exp_ret (v1aldec.v1aldec_def, res, tmpvar_new (v1ar))
    val () = v1ar_initset_val (v1ar, vp)  // vp may be equal to VPfun fl, just let it be
  in
    aux_exp_v1aldeclst (v1aldecs1, res)
  end
  | nil () => ()

(* generating labels for all the functions *)
(* r1: round 1 *)
fun aux_exp_v1aldeclst_rec_r1 (v1aldecs: v1aldeclst): void =
  case+ v1aldecs of
  | cons (v1aldec, v1aldecs1) => let
    val v = v1aldec.v1aldec_var
    val e = v1aldec.v1aldec_def
    val e_node = e.e1xp_node
    val () = 
      if e1xp_node_is_fun (e_node) = true then let
        val fl = funlab_make_name (v)
        val vp_fun = VPfun (fl)
        val () = v1ar_initset_val (v, vp_fun)
      in end
  in
    aux_exp_v1aldeclst_rec_r1 (v1aldecs1)
  end  // end of [cons]
  | nil () => ()

fun aux_exp_v1aldeclst_rec (v1aldecs: v1aldeclst, res: &instrlst): void = let
  // scan for the first round
  // val () = printf ("aux_exp_v1aldeclst_rec\n", @())
  val () = aux_exp_v1aldeclst_rec_r1 (v1aldecs)
in
  aux_exp_v1aldeclst (v1aldecs, res)
end

fun aux_exp_d1eclst (d1ecs: d1eclst, res: &instrlst): void =
  case+ d1ecs of
  | cons (d1ec, d1ecs1) => let
    // val () = printf ("aux_exp_d1eclst\n", @())
    val+ D1ECval (isrec, v1aldecs) = d1ec.d1ec_node 
    (* no matter it is recursive or not, I decide to treat them as the same *)
    val () = (if isrec = true then aux_exp_v1aldeclst_rec (v1aldecs, res)
             else aux_exp_v1aldeclst_rec (v1aldecs, res))
  in
    aux_exp_d1eclst (d1ecs1, res)
  end
  | nil () => ()

fun aux_exp_ret_let (loc: loc, d1ecs: d1eclst, e1xp: e1xp, 
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  // val () = printf ("aux_exp_ret_let\n", @())
  val () = aux_exp_d1eclst (d1ecs, res)
in
  aux_exp_ret (e1xp, res, tmp_ret)
end

fun aux_exp_ret_proj (loc: loc, e1xp: e1xp, pos: int, 
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val vp = aux_exp (e1xp, res)

  val () = 
    (case+ vp of 
    | VParg _ => instr_add_proj (loc, tmp_ret, vp, pos, res)
    | VPtmp _ => instr_add_proj (loc, tmp_ret, vp, pos, res)
    | VPtup _ => instr_add_proj (loc, tmp_ret, vp, pos, res)
    | _ => ETRACE_MSG_OPR ("aux_exp_ret_proj left part is not a tuple\n", ETRACE_LEVEL_ERROR,
                      abort (ERRORCODE_FORBIDDEN))
    )
in
  VPtmp (tmp_ret)
(*  // obsolete code
  case+ vp of
  | VPtup (_, vps) => let
    val vp_opt = list0_nth_opt (vps, pos)
  in
    case+ vp_opt of
    | Some0 vp => let
      val () = instr_add_move (loc, tmp_ret, vp, res)
    in
      VPtmp (tmp_ret)
    end
    | None0 () => ETRACE_MSG_OPR ("aux_exp_ret_proj proj out of bound\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))
  end
*)
end

fun aux_exp_ret_app (loc: loc, e_fun: e1xp, e_arg: e1xp,
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val vp_f = aux_exp (e_fun, res)
  val vp_arg = aux_exp (e_arg, res)

  (* treat all functioins as unary functions *)
  val (vp_args, iswrapper) = (case+ vp_arg of
              | VPtup (_, vps) => (vps, false)
              | _ => (cons (vp_arg, nil), true)
              ): (valprimlst, bool)
  val () = instr_add_call (loc, tmp_ret, vp_f, vp_args, iswrapper, res)
in
  VPtmp (tmp_ret)
end

fun aux_exp_ret_tuple (loc: loc, e1xps: e1xplst,
  res: &instrlst, tmp_ret: tmpvar): valprim = let
  val vps = auxlst_exp (e1xps, res)
  val () = instr_add_tup (loc, tmp_ret, vps, res)
in
  VPtup (tmp_ret, vps)
end

implement
aux_exp_ret (e, res, ret) = let
  val loc = e.e1xp_loc
  // val () = ETRACE_MSG ("aux_exp_ret\n", ETRACE_LEVEL_DEBUG)
in
  case e.e1xp_node of
  | E1XPann (e, _) => aux_exp_ret (e, res, ret)
  | E1XPapp (e_fun, e_arg) => aux_exp_ret_app (loc, e_fun, e_arg, res, ret)
  | E1XPbool _ => aux_exp (e, res)
  | E1XPfix (_, _, _) => ETRACE_MSG_OPR ("aux_exp_ret shouldn't handle E1XPfix\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
  | E1XPif (e_test, e_then, oe_else) => 
    aux_exp_ret_if (loc, e_test, e_then, oe_else, res, ret)
  | E1XPint _ => aux_exp (e, res)
  | E1XPlam (_, _) => ETRACE_MSG_OPR ("aux_exp_ret shouldn't handle E1XPlam\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
  | E1XPlet (d1ecs, e1xp) => aux_exp_ret_let (loc, d1ecs, e1xp, res, ret)
  | E1XPopr (opr, exps) => let
    // val () = printf ("aux_opr\n", @())
  in
    aux_exp_ret_opr (loc, opr, exps, res, ret)
  end
  | E1XPproj (e1xp, pos) => let
    // val () = printf ("aux_proj\n", @())
  in
    aux_exp_ret_proj (loc, e1xp, pos, res, ret)
  end
  | E1XPstr _ => aux_exp (e, res)
  | E1XPtup e1xps => aux_exp_ret_tuple (loc, e1xps, res, ret)
  | E1XPvar _ => aux_exp (e, res)
end

(* extern fun aux_exp_fun (e: e1xp, fl: funlab): valprim *)
(* this function only handle E1XPfix and E1XPlam and E1XPann *)
implement aux_exp_fun (e, fl) = 
  case+ e.e1xp_node of
  | E1XPann (e1, _) => aux_exp_fun (e1, fl)
  | E1XPfix (f, args, body) => aux_exp_fix_lab (f, args, body, fl)
  | E1XPlam (args, body) => aux_exp_lam_lab (args, body, fl)
  | _ => ETRACE_MSG_OPR ("aux_exp_fun handle non-function\n", ETRACE_LEVEL_ERROR,
                    abort (ERRORCODE_FORBIDDEN))

(* ****** ****** *)


(*
trans2_exp (e: e1xp): instrlst
*)
implement
trans2_exp (e) = let
  // val () = ETRACE_MSG ("trans2_exp\n", ETRACE_LEVEL_DEBUG)

  var res: instrlst = list0_nil ()
  val v = aux_exp (e, res)
  (* reverse the main let *)
  val res = instr_reverse (res)

  val fns = funent_getall ()
in
  (res, fns)
end

(* ****** ****** *)

(* end of [trans2.dats] *)


