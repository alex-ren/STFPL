(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)
//
// Put your name here
//
(* ****** ****** *)

#include "CS525.hats"

(* ****** ****** *)

staload "symbol.sats"

(* ****** ****** *)

assume symbol_t = '{
  symbol_name= string, symbol_index= int
} // end of [symbol_t]

(* ****** ****** *)

implement fprint_symbol
  (out, s) = fprint_string (out, s.symbol_name)
// end of [fprint_symbol]

implement print_symbol (x) = fprint_symbol (stdout_ref, x)

implement prerr_symbol (x) = fprint_symbol (stderr_ref, x)

(* ****** ****** *)

extern
fun string_get_symbol (name: string): symbol_t

//
// HX: this is a naive implementation, which is to be replace later
//
local

typedef sym = symbol_t
typedef symlst = list0 (sym)
val theCount = ref<int> (0)
val theTable = ref<symlst> (list0_nil)

in

implement
string_get_symbol (name) = let
  val ans = list0_find_cloref<sym> (!theTable, lam (x) => x.symbol_name = name)
in
  case+ ans of
  | option0_some (x) => x
  | option0_none () => let
      val i = !theCount
      val () = !theCount := i+1
      val sym = '{
        symbol_name= name, symbol_index= i
      } // end of [val]
      val () = !theTable := list0_cons (sym, !theTable)
    in
      sym
    end // end of [option0_none]
end // end of [string_get_symbol]

end // end of [local]

(* ****** ****** *)

(*
**
** please implement various operations on a symbol table
**
*)

(* ****** ****** *)

implement symbol_get_name (x) = x.symbol_name
implement symbol_make_name (name) = string_get_symbol (name)

(* ****** ****** *)
(* fun eq_symbol_symbol (x1: symbol_t, x2: symbol_t):<> bool *)
implement eq_symbol_symbol (x1, x2) = (x1.symbol_index = x2.symbol_index)

(* fun neq_symbol_symbol (x1: symbol_t, x2: symbol_t):<> bool *)
implement neq_symbol_symbol (x1, x2) = (x1.symbol_index <> x2.symbol_index)

(* fun compare_symbol_symbol (x1: symbol_t, x2: symbol_t):<> Sgn *)
implement compare_symbol_symbol (x1, x2) = 
  if (x1.symbol_index < x2.symbol_index) then ~1
  else if (x1.symbol_index = x2.symbol_index) then 0
  else 1

implement symbol_BOOL = symbol_make_name "bool"
implement symbol_INT = symbol_make_name "int"
implement symbol_STRING = symbol_make_name "string"
implement symbol_UNIT = symbol_make_name "unit"

(* ****** ****** *)

implement symbol_UMINUS = symbol_make_name "~"

implement symbol_PLUS = symbol_make_name "+"
implement symbol_MINUS = symbol_make_name "-"
implement symbol_TIMES = symbol_make_name "*"
implement symbol_SLASH = symbol_make_name "/"

implement symbol_GT = symbol_make_name ">"
implement symbol_GTE = symbol_make_name ">="
implement symbol_LT = symbol_make_name "<"
implement symbol_LTE = symbol_make_name "<="
implement symbol_EQ = symbol_make_name "="
implement symbol_NEQ = symbol_make_name "<>"

implement symbol_PRINT = symbol_make_name "print"
implement symbol_PRINT_INT = symbol_make_name "print_int"

assume symenv_t (a:t@ype) = list0 @(symbol_t, a)

(* fun{a:t@ype} symenv_make (): symenv_t (a) *)
implement{a} symenv_make () = list0_nil ()

(* fun{a:t@ype}
symenv_lookup (env: symenv_t a, sym: symbol_t): option0 a *)
implement{a} symenv_lookup (env, sym) = let
  val svo = list0_find_cloref< @(symbol_t, a)> (
    env, lam x => x.0 = sym)
in
  case+ svo of
  | option0_some sv => option0_some sv.1
  | option0_none () => option0_none
end

(* fun{a:t@ype}
symenv_insert (env: symenv_t a, sym: symbol_t, x: a): symenv_t a *)
implement{a} symenv_insert (env, sym, x) = 
  case+ env of
  | list0_nil () => list0_cons (@(sym, x), list0_nil ())
  | list0_cons (sv, env1) => 
    if sv.0 = sym then list0_cons (@(sym, x), env1)
    else list0_cons (sv, symenv_insert (env1, sym, x))

(* fun{a:t@ype}
symenv_inserts (newenv: symenv_t a, oldenv: symenv_t a): symenv_t a *)
implement{a} symenv_inserts (newenv, oldenv) = 
  list0_fold_left<symenv_t a>< @(symbol_t, a)> (
    lam (init, x) => symenv_insert (init, x.0, x.1), oldenv, newenv)

(* ****** ****** *)

(* end of [symbol.dats] *)
