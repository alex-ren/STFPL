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

implement print_symbol (s) = fprint_symbol (stdout_ref, s)
implement prerr_symbol (s) = fprint_symbol (stderr_ref, s)

(* ****** ****** *)

implement eq_symbol_symbol
  (s1, s2) = s1.symbol_index = s2.symbol_index
// end of [eq_symbol_symbol]

implement compare_symbol_symbol
  (s1, s2) = s1.symbol_index \compare s2.symbol_index
// end of [compare_symbol_symbol]

(* ****** ****** *)

extern
fun string_get_symbol (name: string): symbol_t

//
// HX: this is a naive implementation, which is to be replaced later
//
local

typedef sym = symbol_t
val theCount = ref<int> (0)

(* ****** ****** *)

(*
typedef symlst = list0 (sym)
*)

(*
val theTable = ref<symlst> (list0_nil)
*)

(* ****** ****** *)
//
staload H = "libats/SATS/hashtable_chain.sats"
staload _(*H*) = "libats/DATS/hashtable_chain.dats"
//
abstype HASHTBLref (key: t@ype, itm: viewt@ype)
//
extern
castfn HASHTBLref_encode
  {key:t@ype;itm:viewt@ype}
  {l:agz} (x: $H.HASHTBLptr (key, itm, l)): HASHTBLref (key, itm)
// end of [HASHTBLref_encode]

extern
castfn HASHTBLref_decode
  {key:t@ype;itm:viewt@ype} (x: HASHTBLref (key, itm)):<!ref> [l:agz] (
  $H.HASHTBLptr (key, itm, l) -<lin,prf> void | $H.HASHTBLptr (key, itm, l)
) // end of [HASHTBLref_decode]

val theTable
  : HASHTBLref (string, sym) = let
  val hash = lam (x: string): ulint =<cloref> string_hash_33 (x)
  val eqfn = lam (x1: string, x2: string): bool =<cloref> (x1 = x2)
  val x = $H.hashtbl_make {string,sym} (hash, eqfn)
in
  HASHTBLref_encode (x)
end // end of [val]

in // in of [local]

(*
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
*)

implement
string_get_symbol (name) = // '{symbol_name = "dd", symbol_index = 3}
let
  var res: sym?
  val (fpf_x | x) = HASHTBLref_decode (theTable)
  val ans = $H.hashtbl_search (x, name, res)
  prval () = fpf_x (x)
in
  if ans then let
    prval () = opt_unsome {symbol_t} (res) in res
  end else let
    prval () = opt_unnone {symbol_t} (res)
    val n = !theCount; val () = !theCount := n+1
    val sym = '{
      symbol_name= name, symbol_index= n
    } // end of [val]
    val (fpf_x | x) = HASHTBLref_decode (theTable)
    val () = $H.hashtbl_insert<string,symbol_t> (x, name, sym)
    prval () = fpf_x (x)  
  in
    sym
  end // end of [if]
end // end of [string_get_symbol]

end // end of [local]

(* ****** ****** *)

(*
**
** please implement various operations on a symbol table
**
*)

(* ****** ****** *)

implement symbol_get_name (x) = let
  // val () = printf ("symbol_get_name\n", @())
  val ret = x.symbol_name
  // val () = printf ("symbol_get_name10\n", @())
in
  ret
end

implement symbol_make_name (name) = string_get_symbol (name)

(* ****** ****** *)

implement symbol_BOOL = symbol_make_name "bool"
implement symbol_INT = symbol_make_name "int"
implement symbol_STRING = symbol_make_name "string"
implement symbol_UNIT = symbol_make_name "unit"
implement symbol_LIST = symbol_make_name "list"

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

(* ****** ****** *)

local

staload M = "libats/SATS/funmap_avltree.sats"
staload _(*M*) = "libats/DATS/funmap_avltree.dats"
assume symenv_t (a:t@ype) = $M.map (symbol_t, a)
typedef key = symbol_t
fn{} cmp (k1:key, k2:key):<cloref> Sgn = compare (k1, k2)

in // in of [local]

implement{a}
symenv_make () = $M.funmap_make_nil ()

(*
fun{key,itm:t@ype}
funmap_search (
  m: map (key, itm), k0: key, cmp: cmp key, res: &itm? >> opt (itm, b)
) :<> #[b:bool] bool b
// end of [funmap_search]
*)
implement{a}
symenv_lookup (env, k0) = let
  var res: a?
  val ans =
    $M.funmap_search<key,a> (env, k0, cmp, res)
  // end of [val]
in
  if ans then let
    prval () = opt_unsome {a} (res) in option0_some (res)
  end else let
    prval () = opt_unnone {a} (res) in option0_none ()
  end // end of [if]
end // end of [symenv_lookup]

(*
fun{key,itm:t@ype} funmap_insert (
  m: &map (key, itm), k0: key, x0: itm, cmp: cmp key
) :<> bool(*[k0] alreay exists in [m]*) // end of [funmap_insert]
*)
implement{a}
symenv_insert (env, k, i) = env where {
  var env = env
  val ans(*discarded*) = $M.funmap_insert<key,a> (env, k, i, cmp)
} // end of [symenv_insert]

implement{a}
symenv_inserts (env, ps) = list0_fold_left<symenv_t a>< @(symbol_t, a)> (
  lam (init, x): symenv_t a => symenv_insert (init, x.0, x.1), env, ps)

implement{a}
symenv_listize (env) = let
  val xs_v = $M.funmap_listize (env)
  val xs = list0_of_list_vt (xs_v)
in
  xs
end


end // end of [local]

(* ****** ****** *)

(* end of [symbol.dats] *)

