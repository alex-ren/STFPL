

(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload "trans2.sats"
staload "trans_llvm.sats"

staload "error.sats"
staload "absyn.sats"
staload "symbol.sats"

staload "ostream.sats"
staload "string_opr.sats"

(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats" 
staload _(*anon*) = "prelude/DATS/list0.dats" 
staload _(*anon*) = "prelude/DATS/reference.dats" 
staload _(*anon*) = "symbol.dats"

// 
#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

#define Some0 option0_some
#define None0 option0_none

datatype statement_t =
  | STATplain of string
  | STATindent of string

typedef statements_t = list0 statement_t

typedef statements = statements_t
typedef statement = statement_t

(* ********* *********** *)

val env_str = "env": string
val env_tmpvar = tmpvar_new (env_str)
val env_arg = make_valprim (VPtmp (env_tmpvar), T2YPenv)

(* ********* *********** *)

(* 64 bit machine *)
// val layout = "target datalayout = \"e-p:64:64:64-": string
// val layout = layout +
//              "i1:8:8-i8:8:8-i16:16:16-" +
//              "i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-" + 
//              "v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64\""
// 
// val target = "target triple = \"x86_64-unknown-linux-gnu\"": string

(* 32 bit machine *)
val layout = "target datalayout = \"e-p:32:32:32-": string
val layout = layout + 
             "i1:8:8-i8:8:8-i16:16:16-" +
             "i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-" +
             "v128:128:128-a0:0:64-f80:32:32-n8:16:32\""

val target = "target triple = \"i386-linux-gnu\""

(* ********* *********** *)

val header_type = "%struct.env_t = type opaque": string
val header_type = header_type + "\n" + 
                  "%struct.tuple_t = type opaque" + "\n" +
                  "%struct.closure_t = type opaque" + "\n" +
                  "%struct.list_t = type opaque"

val header_global_value = 
    "@tostring_int = external global %struct.closure_t*": string

val header_func_decl = "declare %struct.closure_t* @closure_create(...)": string
val header_func_decl = header_func_decl + "\n" +
           "declare void @closure_put_fun(%struct.closure_t*, i8*)" + "\n" +
           "declare i8* @closure_get_fun(%struct.closure_t*)" + "\n" + 
           "declare %struct.env_t* @closure_get_env(%struct.closure_t*)"

val header_func_decl = header_func_decl + "\n" +
           "declare i8* @env_get(%struct.env_t*, i32)"

val header_func_decl = header_func_decl + "\n" +
           "declare i32 @printf(i8* noalias, ...) nounwind" + "\n" +
           "declare i32 @puts(i8*)"


val header_func_decl = header_func_decl + "\n" +
           "declare void @init_lib(...)"

val header = layout + "\n" + 
             target + "\n\n" +
             header_type + "\n\n" + 
             header_global_value + "\n\n" +
             header_func_decl

val gv_str_pre = ".str"

val type_int: string = "i32"

extern fun statements_to_string (stats: statements): string

val indent_pad = "  ": string
val scope_beg = "{": string
val scope_end = "}": string
val str_entry = "entry": string
val str_return = "return": string
val str_addr_postfix = "_addr": string
val str_retval = "retval": string
val str_ret = "ret": string

typedef global_val = '{gv_stat = statement,
                      gv_typ = string,
                      gv_id = string}


implement statements_to_string (stats) = let
in
  case+ stats of
  | cons (stat, stats1) => 
    (case+ stat of
    | STATplain str => let
      val cur = str + "\n"
      val rest = statements_to_string (stats1)
    in
      cur + rest
    end
    | STATindent str => let
      val cur = indent_pad + str + "\n"
      val rest = statements_to_string (stats1)
    in
      cur + rest
    end
    )
  | nil () => ""
end  // end of [statements_to_string]

extern fun add_global_val (str: string): (string (*type*), string (* identifier *))
extern fun get_global_val (): statements

extern fun get_counter (): string

local

val gv_table = ref<symenv_t (global_val)> (symenv_make ())
val gv_str_counter = ref<int> (0)

val gv_counter = ref<int> (0)
in

implement add_global_val (str) = let
  val table = !gv_table
  val sym = symbol_make_name (str)
  val gv_opt = symenv_lookup (table, sym)
in
  case+ gv_opt of
  | Some0 gv => (gv.gv_typ, gv.gv_id)
  | None0 () => let
    val (len, gv_string) = string_formalize_llvm_gv (str)

    val counter = !gv_str_counter
    val () = !gv_str_counter := counter + 1

    val gv_nam = "@": string
    val gv_nam = gv_nam + gv_str_pre + tostring_int (counter)  // @.str1
    val gv_str = gv_nam + " = private constant [" + tostring_int (len) +
                 " x i8] c" + gv_string + ", align 1"

    val gv_stat = STATplain gv_str
    val gv_typ = "i8*"
    val gv_id = "noalias getelementptr inbounds ([" + 
                tostring_int (len) + " x i8]* " + gv_nam + ", i32 0, i32 0)"

    val gv = '{gv_stat = gv_stat, gv_typ = gv_typ, gv_id = gv_id}
    val table = symenv_insert (table, sym, gv)
    val () = !gv_table := table
  
  in
    (gv_typ, gv_id)
  end
end

implement get_global_val () = let
  val gvs = symenv_listize (!gv_table)
  val stats = list0_map_fun< @(symbol_t, global_val)><statement> (
              gvs, lam x => (x.1).gv_stat)
in
  stats
end
      
implement get_counter () = let
  val counter = !gv_counter
  val () = !gv_counter := counter + 1
in
  tostring_int (counter)
end

end  // [end of local]

(* ************* *************** *)

fun trans_llvm_typ (t2yp: t2yp): string =
  case+ t2yp of
  | T2YPint ()  => type_int
  | T2YPbool () => "i32"
  | T2YPstr ()  => "i8*"
  | T2YPenv ()  => "%struct.env_t*"
  | T2YPlist (_) => "%struct.list_t*"
  | T2YPvar ()  => "i8*"
  | T2YPclo (_, _, _)  => "%struct.closure_t"
  | T2YPtup (ts)  => case+ ts of
          | cons (_, _) => "%struct.tuple_t*"
          | nil () => "i32"

fun trans_llvm_valprimlst_typ (args: valprimlst, i: int): string = 
  loop (args, i) where {
  fun loop (args: valprimlst, i: int): string = 
    case+ args of
    | cons (arg, args1) => let
      val t2yp = arg.valprim_typ

      val arg_typ = trans_llvm_typ (t2yp)
      val arg_str = if (i > 0) then ", " + arg_typ else arg_typ
    in
      arg_str + loop (args1, i + 1)
    end
    | nil () => ""
}

(* ************* *************** *)

fun trans_llvm_args (args: valprimlst): string = loop (args, 0) where {
  fun loop (args: valprimlst, i: int): string = 
    case+ args of
    | cons (arg, args1) => let
      val t2yp = arg.valprim_typ
      val node = arg.valprim_node
      val tmpvar = (case+ node of
          | VPtmp (tmpvar) => tmpvar
          | _ => let
             // val () = fprint_valprim (stderr_ref, arg)
          in
             ETRACE_MSG_OPR ("trans_llvm_args args should be VPtmp\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
          end
          ): tmpvar
      val arg_nam = tmpvar_get_name (tmpvar)
      val arg_typ = trans_llvm_typ (t2yp)
      val arg_str = arg_typ + " %" + arg_nam
      val arg_str = if (i > 0) then ", " + arg_str else arg_str
    in
      arg_str + loop (args1, i + 1)
    end
    | nil () => ""
}

fun valprim_get_name (vp: valprim, def: string): string =
  case+ vp.valprim_node of
  | VPenv _ => def
  | VPbool _ => def
  | VPclo (tmpvar, _, _) => tmpvar_get_name (tmpvar)
  | VPint _ => def
  | VPstr _ => def
  | VPtmp (tmpvar) => tmpvar_get_name (tmpvar)
  | VPtup (tmpvar, _) => tmpvar_get_name (tmpvar)

fun trans_llvm_fun_args_ret_alloc (ent: funent_t): statements = let
  val args = funent_get_args (ent)

  fun loop (args: valprimlst, accu: statements): statements = 
    case+ args of
    | cons (arg, args1) => let
      val t2yp = arg.valprim_typ
      val node = arg.valprim_node
      val tmpvar = (case+ node of
          | VPtmp (tmpvar) => tmpvar
          | _ => let
             // val () = fprint_valprim (stderr_ref, arg)
          in
             ETRACE_MSG_OPR ("trans_llvm_args args should be VPtmp\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
          end
          ): tmpvar
      val arg_nam = tmpvar_get_name (tmpvar)
      val arg_typ = trans_llvm_typ (t2yp)

      val arg_str = "%" + arg_nam + str_addr_postfix + 
                     " = alloca " + arg_typ
      val arg_stat = STATindent (arg_str)
    in
      loop (args1, arg_stat :: accu)
    end
    | nil () => accu

  val args_stats = loop (args, nil)

  val ret_vp = funent_get_ret (ent)
  val ret_typ = trans_llvm_typ (ret_vp.valprim_typ)
  val ret_nam = valprim_get_name (ret_vp, str_retval)

  val ret_str = "%" + ret_nam + " = alloca " + ret_typ
  val ret_stat = STATindent (ret_str)

  val stats = list0_reverse (ret_stat :: args_stats)
in
  stats
end

(* add env as the first parameter *)
fun trans_llvm_fun_decl (ent: funent_t):<cloref1> string = let
  val fl = funent_get_lab (ent)
  val nam = funlab_get_name (fl)
  val args = funent_get_args (ent)

  val ret_vp = funent_get_ret (ent)
  val ret_typ = trans_llvm_typ (ret_vp.valprim_typ)

  val stat = "define " + ret_typ + " @" + nam + "("
  val stat = stat + trans_llvm_args (cons (env_arg, args)) + ") nounwind"
in
  stat
end

extern fun trans_llvm_instrlst (body: instrlst): statements
extern fun trans_llvm_instr (instr: instr): statements

(* 
ret:
  nam: string including the preceding %
*)
fun trans_llvm_valprim (vp: valprim): 
  (statements, string (*type*), string (*name*)) = let
  val node = vp.valprim_node
  val typ = vp.valprim_typ
  val typ_str = trans_llvm_typ (typ)
in
  case+ node of
  | VPenv (pos) => let
    val nam = "%" + env_str + "_" + tostring_int (pos) + "_" +
             get_counter ()
    val nam1 = nam + "b"

    val env_nam = tmpvar_get_name (env_tmpvar)
    val stat_str1 = nam1 + " = call i8* @env_get(%struct.env_t* %" + 
              env_nam + ", i32 " + tostring_int (pos) + ") nounwind"
    val stat_str2 = nam + " = bitcast i8* " + nam1 + " to " + typ_str
    val stats = STATindent (stat_str1) :: STATindent (stat_str2) :: nil
  in
    (stats, typ_str, nam)
  end
  | VPbool (b) => if b then (nil, typ_str, "1")
                  else (nil, typ_str, "0")
  | VPclo (tmpvar, fl, vps) => (nil, typ_str, 
                                 "%" + tmpvar_get_name (tmpvar))
  | VPint (i) => (nil, typ_str, tostring_int (i))
  | VPstr (str) => let
    val (_, nam) = add_global_val (str)
  in
    (nil, typ_str, nam)
  end
  | VPtmp (tmpvar) => (nil, typ_str, "%" + tmpvar_get_name (tmpvar))
  | VPtup (tmpvar, vps) => let
    val ret = (if list0_length (vps) = 0 then 
          (nil, typ_str, "null")
          else (nil, typ_str, "%" + tmpvar_get_name (tmpvar))
          ): (statements, string, string)
  in
    ret
  end
end

fun trans_llvm_valprimlst (vps: valprimlst): 
  (statements, list0 string(*type*), list0 string (*nam*)) =
  case+ vps of
  | cons (vp, vps1) => let
    val (stats, typ, name) = trans_llvm_valprim (vp)
    val (stats1, typs, names) = trans_llvm_valprimlst (vps1)
  in
    (list0_append (stats, stats1), typ :: typs, name :: names)
  end
  | nil () => (nil, nil, nil)

implement trans_llvm_instrlst (body) = let
  fun loop (body: instrlst, accu: statements): statements =
    case+ body of
    | cons (instr, body1) => let
      val stats = trans_llvm_instr (instr)
      val accu = list0_append (accu, stats)
    in
      loop (body1, accu)
    end
    | nil () => accu
in
  loop (body, nil)
end

(* ******** *********** *)

fun trans_llvm_instr_call (ret: tmpvar, f: valprim, 
  args: valprimlst, ret_typ: t2yp): statements = let

  // name of the closure
  val (stats0, _, f_nam) = trans_llvm_valprim (f)
  val f_fun_nam =  f_nam + "_f_" + get_counter ()
  val f_fun_nam1 =  f_fun_nam + "b"

  // get function pointer
  val stat1 = STATindent (f_fun_nam1 + " = call i8* " + 
                    "@closure_get_fun(%struct.closure_t* " + 
                    f_nam + ") nounwind")
  
  // build the function type
  val f_typ = f.valprim_typ
  val- T2YPclo (_, _, ret_typ1) = f_typ
  val args_typ_str = trans_llvm_valprimlst_typ (args, 1)

  val ret_typ_str = trans_llvm_typ (ret_typ)
  // this one maybe any (due to list operation such as list_head)
  val ret_typ_str1 = trans_llvm_typ (ret_typ1)

  // convert function pointer
  val stat2 = STATindent (f_fun_nam + " = bitcast i8* " + f_fun_nam1 +
              " to " + ret_typ_str1 + " (%struct.env_t*" + 
              args_typ_str + ")*")

  // get function env
  val f_env_nam =  f_nam + "_env_" + get_counter ()
  val stat3 = STATindent (f_env_nam + " = call %struct.env_t*" + 
                 " @closure_get_env(%struct.closure_t* " + f_nam +
                 ") nounwind")

  val ret_str = "%" + tmpvar_get_name (ret) 
  val ret_str1 = ret_str + "b"

  val (stats4, typ_lst, nam_lst) = trans_llvm_valprimlst (args)

  fun loop_args (typs: list0 string, nams: list0 string, 
    init: string, i: int): string =
    case+ (typs, nams) of
    | (cons (typ, typs1), cons (nam, nams1)) =>
        if i > 0 then loop_args (
             typs1, nams1, init + ", " + typ + " " + nam, i + 1)
        else loop_args (typs1, nams1, init + typ + " " + nam, i + 1)
    | (nil (), nil ()) => init
    | (_, _) => ETRACE_MSG_OPR ("loop_args lists not of the same length\n", 
                    ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))

  // call the function and convert the ret if necessary
  val stats4 = (if ret_typ_str = ret_typ_str1 then
      STATindent (ret_str + " = call " + ret_typ_str1 + " " + f_fun_nam +
                "(%struct.env_t* " + f_env_nam + 
                loop_args (typ_lst, nam_lst, "", 1) + ")") :: nil
      else 
      STATindent (ret_str1 + " = call " + ret_typ_str1 + " " + f_fun_nam +
                "(%struct.env_t* " + f_env_nam + 
                loop_args (typ_lst, nam_lst, "", 1) + ")") ::
      STATindent (ret_str + " = bitcast " + ret_typ_str1 + " " +
                 ret_str1 + " to " + ret_typ_str) :: nil
               ): statements
   
  val stats = stat1 :: stat2 :: stat3 :: stats4
  val stats = list0_append (stats0, stats)
in
  stats
end

fun trans_llvm_instr_cond (ret: tmpvar, typ: t2yp, vp: valprim, 
  brthen: instrlst, brelse: instrlst): statements = nil  // let
//   val ret_str = tmpvar_get_name (ret)
//   val ret_typ = trans_cpp_typ (typ)
//   val stat_dec = STATindent (ret_typ + " " + ret_str + ";")
// 

  
fun trans_llvm_instr_opr (ret: tmpvar, typ: t2yp, opr: opr, 
  args: valprimlst): statements  = let
  val+ OPR sym = opr
  // statements for handling arguments
  val (stats0, typlst, namlst) = trans_llvm_valprimlst (args)

  val ret_typ = trans_llvm_typ (typ)
  val ret_nam = "%" + tmpvar_get_name (ret)
  val ret_nam1 = ret_nam + "b"

  val (stats1, needret) = 
    (case+ 0 of
    | _ when sym = symbol_PLUS => let
        val- s1 :: s2 :: _ = namlst
        val stat_str = ret_nam + " = add i32 " + s1 + ", " + s2
      in
        (STATindent (stat_str) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_MINUS => let
        val- s1 :: s2 :: _ = namlst
        val stat_str = ret_nam + " = sub i32 " + s1 + ", " + s2
      in
        (STATindent (stat_str) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_TIMES => let
        val- s1 :: s2 :: _ = namlst
        val stat_str = ret_nam + " = mul i32 " + s1 + ", " + s2
      in
        (STATindent (stat_str) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_SLASH => let
        val- s1 :: s2 :: _ = namlst
        val stat_str = ret_nam + " = sdiv i32 " + s1 + ", " + s2
      in
        (STATindent (stat_str) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_UMINUS => let
        val- s :: _ = namlst
        val stat_str = ret_nam + " = sub i32 0, " + s
      in
        (STATindent (stat_str) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GT => let
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp sgt i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_GTE => let
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp sge i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end // end of [_ when ...]
    | _ when sym = symbol_LT => let
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp slt i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end
    | _ when sym = symbol_LTE => let
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp sle i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end
    | _ when sym = symbol_EQ => let      
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp eq i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end
    | _ when sym = symbol_NEQ => let
        val- s1 :: s2 :: _ = namlst
        val stat_str1 = ret_nam1 + " = icmp ne i32 " + s1 + ", " + s2
        val stat_str2 = ret_nam + " = zext i1 " + ret_nam1 + " to i32"
      in
        (STATindent (stat_str1) :: STATindent (stat_str2) :: nil, true)
      end
    | _ when sym = symbol_PRINT => let
        val- s :: _ = namlst
        val- t  :: _ = typlst
        val stat_str = ret_nam + " = call i32 (i8*, ...)* @printf(" +
                t + " " + s + ") nounwind"
      in
        (STATindent (stat_str) :: nil, false)
      end // end of [_ when ...]
    | _ when sym = symbol_PRINT_INT => let
        val- i  :: _ = namlst
        val- t  :: _ = typlst
        val (typ, id) = add_global_val ("%i")
        val stat_str = ret_nam + " = call i32 (i8*, ...)* @printf(" +
                typ + " " + id + ", " + t + " " + i + ") nounwind"
      in
        (STATindent (stat_str) :: nil, false)
      end // end of [_ when ...]
    | _ => ETRACE_MSG_OPR ("trans_cpp_instr_opr unsupported operator\n", 
                      ETRACE_LEVEL_ERROR, abort (ERRORCODE_FORBIDDEN))
      // end of [_]
    ): (statements, bool)
in
  list0_append (stats0, stats1)
end  // end of [trans_cpp_instr_opr]

fun trans_llvm_instr_tup (ret: tmpvar, vps: valprimlst): statements
= nil  // todo

fun trans_llvm_instr_closure (
  ret: tmpvar, fl: funlab_t, vps: valprimlst): statements
= nil  // todo

fun trans_llvm_instr_proj (ret: tmpvar, typ: t2yp, vp: valprim, 
  pos: int): statements = nil  // todo


implement trans_llvm_instr (instr) =
  case+ instr.instr_node of
  | INSTRcall (ret, f, args, ret_typ) =>
    trans_llvm_instr_call (ret, f, args, ret_typ)
  | INSTRcond (ret, typ, v, brthen, brelse) =>
    trans_llvm_instr_cond (ret, typ, v, brthen, brelse)
  | INSTRmove_val (tmpv, vp) => let
    val nam: string = "%" + tmpvar_get_name (tmpv)
    val (stats, vptyp, vpnam) = trans_llvm_valprim (vp)
    val stats1 = STATindent (nam + " = " + vptyp + " " + vpnam ) :: nil
  in
    list0_append (stats, stats1)
  end
  | INSTRopr (ret, t2yp, opr, vps) => let
    // val () = printf ("opr\n", @())
  in
    trans_llvm_instr_opr (ret, t2yp, opr, vps)
  end
  | INSTRtup (ret, vps) =>
    trans_llvm_instr_tup (ret, vps)
  | INSTRclosure (ret, fl, vps) =>
    trans_llvm_instr_closure (ret, fl, vps)
  | INSTRproj (ret, typ, v, pos) => let
    // val () = printf ("proj\n", @())
  in
    trans_llvm_instr_proj (ret, typ, v, pos)
  end

(* ************* ************ *)

fun trans_llvm_fun_body (
  narg: int, body: instrlst, ret: valprim): statements = let
  val stats_body = trans_llvm_instrlst (body)

  // val ret_typ = trans_llvm_typ (ret.valprim_typ)

  val (stats_ret0, ret_typ, ret_id) = trans_llvm_valprim (ret)
  // val ret_nam = valprim_get_name (ret, str_retval)

  val ret_stat0 = STATindent ("br label %" + str_return)
  val ret_stat1 = STATplain ("\n" + str_return + ":")
  val ret_stat2 = STATindent (str_ret + " " + ret_typ + " " + ret_id)
  val stats_ret1 = ret_stat0 :: ret_stat1 :: ret_stat2 :: nil

  val stats_ret = list0_append (stats_ret0, stats_ret1)
in
  list0_append (stats_body, stats_ret)
end

(* ************* ************ *)

fun trans_llvm_funlst_def (fns: list0 funent_t, os: &ostream): void = let
  fun trans (init: string, ent: funent_t):<cloref1> string = let
    val fl = funent_get_lab (ent)
    val nargs = funent_get_narg (ent)
    val body = funent_get_body (ent)
    val ret = funent_get_ret (ent)
    val nam = funlab_get_name (fl)

    val fundef = trans_llvm_fun_decl (ent)

    val fundef = fundef + " " + scope_beg + "\n" + str_entry + ":\n"

    val fun_args_ret_alloc = trans_llvm_fun_args_ret_alloc (ent)
    val fundef = fundef + statements_to_string (fun_args_ret_alloc)

    val funbody = trans_llvm_fun_body (nargs, body, ret)
    val fundef = fundef + statements_to_string (funbody)
    val fundef = fundef + scope_end + "\n\n"
  in
    init + fundef
  end

  val header = list0_fold_left (trans, "", fns)
  val () = ostream_in (os, header)
in
end

(* ************* *************** *)

implement trans_llvm (instrs, fns) = let
  var os = ostream_new ()
  val () = ostream_in (os, header)
  val () = ostream_in (os, "\n\n")

  val main_ent = funent_make (mainlab, 1, nil, instrs, 
    make_valprim (VPint 0, T2YPint) (*just a dummy return value*), nil)
  val fns = list0_append (fns, cons (main_ent, nil))
  var os2 = ostream_new ()
  val () = trans_llvm_funlst_def (fns, os2)

  val global_stats = get_global_val ()
  val () = ostream_in (os, statements_to_string (global_stats))

  val () = ostream_in (os, "\n" + ostream_to_string (os2))
  val () = ostream_in (os, "\n\n")
 
   val main_stats = STATplain ("define i32 @main(i32 %argc, i8** %argv) nounwind {") ::
                    STATplain ("entry:") :: 
                        STATindent ("%argc_addr = alloca i32") ::
                        STATindent ("%argv_addr = alloca i8**") ::
                        STATindent ("%retval = alloca i32") ::
                        STATindent ("%0 = alloca i32") ::
                        STATindent ("%\"alloca point\" = bitcast i32 0 to i32") ::
                        STATindent ("store i32 %argc, i32* %argc_addr") ::
                        STATindent ("store i8** %argv, i8*** %argv_addr") ::
                        STATindent ("call void (...)* @init_lib() nounwind") ::
                        STATindent ("%1 = call i32 @__main(%struct.env_t* null) nounwind") ::
                        STATindent ("store i32 0, i32* %0, align 4") ::
                        STATindent ("%2 = load i32* %0, align 4") ::
                        STATindent ("store i32 %2, i32* %retval, align 4") ::
                        STATindent ("br label %return") ::
                    STATplain ("return:") :: 
                        STATindent ("%retval1 = load i32* %retval") ::
                        STATindent ("ret i32 %retval1") :: 
                    STATplain ("}") :: nil
   val mainstr = statements_to_string (main_stats)
   val () = ostream_in (os, mainstr)
   val () = ostream_in (os, "\n\n")
in
  os
end

















