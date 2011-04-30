



staload Absyn = "absyn.sats"
staload Symbol = "symbol.sats"
staload Trans1 = "trans1.sats"
staload Trans2 = "trans2.sats"

(* ******* ******** *)
val symbol_STRING_ADD: $Symbol.symbol_t

val string_append: $Symbol.symbol_t

(* ******* ******** *)

(* The following are the constructors for stlist
* They look like template.
* But in our language, users cannot define their own template.
*)
val symbol_LIST_NIL : $Symbol.symbol_t // "list_nil"
val symbol_LIST_CONS : $Symbol.symbol_t // "list_cons"
val symbol_LIST_IS_EMPTY : $Symbol.symbol_t // "list_is_empty"
val symbol_LIST_HEAD : $Symbol.symbol_t // "list_head"
val symbol_LIST_TAIL : $Symbol.symbol_t // "list_tail"

val symbol_STRING_ADD : $Symbol.symbol_t // "string_add"

(* This is valid.
======================================
val fn = lam (x: list, y: list) => let
  val h = list_head (x)
in
  list_cons (h, y)
end

val x1 = list_cons (5, list_nil)
val x2 = list_cons (6, list_nil)
val r = fn (x1, x2)
======================================
*)

(* This is invalid. By type inference, the actual
type of fn would be (list int, list int) -> list int.
This is because that fn is applied on the int list
first.
======================================
val fn = lam (x: list, y: list) => let
  val h = list_head (x)
in
  list_cons (h, y)
end

val x1 = list_cons (5, list_nil)
val x2 = list_cons (6, list_nil)
val r = fn (x1, x2)

val x1 = list_cons ("a", list_nil)
val x2 = list_cons ("b", list_nil)
val r = fn (x1, x2)
======================================
*)


fun libSymTypFind (nam: $Symbol.symbol_t): option0 $Trans1.t1yp
fun libOprTypFind (opr: $Absyn.opr): option0 $Trans1.t1yp

fun libFunVPFind (nam: $Symbol.symbol_t): option0 $Trans2.valprim





