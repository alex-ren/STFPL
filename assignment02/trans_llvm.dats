

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
  | STATcomp of statements_t

where statements_t = list0 statement_t

typedef statements = statements_t
typedef statement = statement_t

val layout = "target datalayout = \"e-p:64:64:64-": string
val layout = layout +
             "i1:8:8-i8:8:8-i16:16:16-" +
             "i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-" + 
             "v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64\""

val target = "target triple = \"x86_64-unknown-linux-gnu\"": string

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

extern fun statements_to_string (stats: statements, level: int): string

val indent_pad = "  ": string

typedef global_val = '{gv_stat = statement,
                      gv_id = string}


implement statements_to_string (stats, level) = let
  fun level_string (i: int): string =
    if i <= 0 then "" else indent_pad + level_string (i - 1)
  
  val indent_pad = level_string (level)
in
  case+ stats of
  | cons (stat, stats1) => 
    (case+ stat of
    | STATplain str => let
      val cur = indent_pad + str + "\n"
      val rest = statements_to_string (stats1, level)
    in
      cur + rest
    end
    | STATcomp stats' => let
      val cur = statements_to_string (stats', level + 1) + "\n"
      val rest = statements_to_string (stats1, level)
    in
      cur + rest
    end
    )
  | nil () => ""
end  // end of [statements_to_string]

extern fun add_global_val (str: string): string (* identifier *)
extern fun get_global_val (): statements

local

val gv_table = ref<symenv_t (global_val)> (symenv_make ())
val gv_str_counter = ref<int> (0)

in

implement add_global_val (str) = let
  val table = !gv_table
  val sym = symbol_make_name (str)
  val gv_opt = symenv_lookup (table, sym)
in
  case+ gv_opt of
  | Some0 gv => gv.gv_id
  | None0 () => let
    val (len, gv_string) = string_formalize_llvm_gv (str)
    val counter = !gv_str_counter
    val () = !gv_str_counter := counter + 1
    val gv_nam = "@": string
    val gv_nam = gv_nam + gv_str_pre + tostring_int (counter)  // @.str1
    val gv_str = gv_nam + "private constant [" + tostring_int (len) +
                 " x i8] c" + gv_string + ", align 1"
    val gv_id = "noalias getelementptr inbounds ([" + tostring_int (len) +
                " x i8]* " + gv_nam + ", i64 0, i64 0)"

    val gv_stat = STATplain gv_str
  
    val gv = '{gv_stat = gv_stat, gv_id = gv_id}
    val table = symenv_insert (table, sym, gv)
    val () = !gv_table := table
  in
    gv_id
  end
end

implement get_global_val () = let
  val gvs = symenv_listize (!gv_table)
  val stats = list0_map_fun< @(symbol_t, global_val)><statement> (
              gvs, lam x => (x.1).gv_stat)
in
  stats
end
      
end  // [end of local]
                

(* ************* *************** *)
// extern fun trans_llvm_fun_body (
//   narg: int, body: instrlst, ret: valprim): statements
// 
// extern fun trans_llvm_instrlst (body: instrlst): statements
// extern fun trans_llvm_instr (instr: instr): statements
// 
// extern fun trans_llvm_valprim (vp: valprim): string
// extern fun trans_llvm_valprimlst (vps: valprimlst): list0 string
// 
// fun trans_llvm_funlst_def (fns: list0 funent_t, os: &ostream): void = let
//   fun trans (init: string, ent: funent_t):<cloref1> string = let
//     val fl = funent_get_lab (ent)
//     val nargs = funent_get_narg (ent)
//     val body = funent_get_body (ent)
//     val ret = funent_get_ret (ent)
//     val nam = funlab_get_name (fl)
// 
//     val fundef = trans_llvm_fun_decl (ent)
// 
//     val fundef = fundef + "\n" + scope_beg + "\n"
//     val funbody = trans_llvm_fun_body (nargs, body, ret)
//     val fundef = fundef + statements_to_string (funbody, 1)
//     val fundef = fundef + scope_end + "\n\n"
//   in
//     init + fundef
//   end
// 
//   val header = list0_fold_left (trans, "", fns)
//   val () = ostream_in (os, header)
// in
// end
// 
(* ************* *************** *)

fun trans_llvm_typ (t2yp: t2yp): string =
  case+ t2yp of
  | T2YPint ()  => "i64"
  | T2YPbool () => "i32"
  | T2YPstr ()  => "i8*"
  | T2YPenv ()  => "%struct.env_t*"
  | T2YPlist (_) => "%struct.list_t*"
  | T2YPvar ()  => "i8*"
  | T2YPclo (_, _, _)  => "%struct.closure_t"
  | T2YPtup (_)  => "%struct.tuple_t"

implement trans_llvm (instrs, fns) = let
  var os = ostream_new ()
  val () = ostream_in (os, header)

  val main_ent = funent_make (mainlab, 1, nil, instrs, 
    make_valprim (VPint 0, T2YPint) (*just a dummy return value*), nil)
  val fns = list0_append (fns, cons (main_ent, nil))

  val () = ostream_in (os, "\n\n")

  // todo val () = trans_llvm_funlst_def (fns, os)
 
   val main_stats = STATplain ("define i32 @main(i32 %argc, i8* %argv) nounwind {") ::
                    STATplain ("entry:") :: 
                    STATcomp (
                        STATplain ("%argc_addr = alloca i32, align 4") ::
                        STATplain ("%argv_addr = alloca i8*, align 8") ::
                        STATplain ("%retval = alloca i32") ::
                        STATplain ("%0 = alloca i32") ::
                        STATplain ("%\"alloca point\" = bitcast i32 0 to i32") ::
                        STATplain ("store i32 %argc, i32* %argc_addr") ::
                        STATplain ("store i8* %argv, i8** %argv_addr") ::
                        STATplain ("call void (...)* @init_lib() nounwind") ::
                        STATplain ("%1 = call i64 @__main(%struct.env_t* null) nounwind") ::
                        STATplain ("store i32 0, i32* %0, align 4") ::
                        STATplain ("%2 = load i32* %0, align 4") ::
                        STATplain ("store i32 %2, i32* %retval, align 4") ::
                        STATplain ("br label %return") :: nil
                    ) ::
                    STATplain ("return:") :: 
                    STATcomp (
                        STATplain ("%retval1 = load i32* %retval") ::
                        STATplain ("ret i32 %retval1") :: nil
                    ) :: nil
                    


   val mainstr = statements_to_string (main_stats, 0)
 
   val () = ostream_in (os, mainstr)
   val () = ostream_in (os, "\n\n")
in
  os
end

















