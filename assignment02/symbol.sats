(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

abstype symbol_t // a boxed abstract type

(* ****** ****** *)

fun symbol_get_name (x: symbol_t): string
fun symbol_make_name (name: string): symbol_t

(* ****** ****** *)

fun fprint_symbol (out: FILEref, x: symbol_t): void
overload fprint with fprint_symbol

fun print_symbol (x: symbol_t): void
overload print with print_symbol

fun prerr_symbol (x: symbol_t): void
overload prerr with prerr_symbol

(* ****** ****** *)

fun eq_symbol_symbol (x1: symbol_t, x2: symbol_t):<> bool
overload = with eq_symbol_symbol

fun neq_symbol_symbol (x1: symbol_t, x2: symbol_t):<> bool
overload <> with neq_symbol_symbol

fun compare_symbol_symbol (x1: symbol_t, x2: symbol_t):<> Sgn
overload compare with compare_symbol_symbol

(* ****** ****** *)

val symbol_BOOL : symbol_t // "bool" for [bool] type
val symbol_INT : symbol_t // "int" for [int] type
val symbol_STRING : symbol_t // "string" for [string] type
val symbol_UNIT : symbol_t // "unit" for [unit] type
val symbol_LIST : symbol_t // "list" for [list] type

(* ****** ****** *)

val symbol_UMINUS : symbol_t // "~"

val symbol_PLUS : symbol_t // "+"
val symbol_MINUS : symbol_t // "-"
val symbol_TIMES : symbol_t // "*"
val symbol_SLASH : symbol_t // "/"

val symbol_GT : symbol_t // ">"
val symbol_GTE : symbol_t // ">="
val symbol_LT : symbol_t // "<"
val symbol_LTE : symbol_t // "<="
val symbol_EQ : symbol_t // "="
val symbol_NEQ : symbol_t // "<>"

val symbol_PRINT : symbol_t // "print"
val symbol_PRINT_INT : symbol_t // "print_int"

val symbol_LIST_NIL : symbol_t // "list_nil"
val symbol_LIST_CONS : symbol_t // "list_cons"
val symbol_LIST_IS_EMPTY : symbol_t // "list_is_empty"
val symbol_LIST_HEAD : symbol_t // "list_head"
val symbol_LIST_TAIL : symbol_t // "list_tail"

(* ****** ****** *)

abstype symenv_t (a: t@ype)

fun{a:t@ype} symenv_make (): symenv_t (a)

fun{a:t@ype}
symenv_lookup (env: symenv_t a, sym: symbol_t): option0 a

fun{a:t@ype}
symenv_insert (env: symenv_t a, sym: symbol_t, x: a): symenv_t a

fun{a:t@ype}
symenv_inserts (env: symenv_t a, ps: list0 @(symbol_t, a)): symenv_t a
(* ****** ****** *)

fun{a:t@ype}
symenv_listize (env: symenv_t a): list0 @(symbol_t, a)


(* end of [symbol.sats] *)
(* vi: set syntax=sml: *)


