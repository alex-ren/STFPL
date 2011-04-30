
staload "libfunctions.sats"
staload "absyn.sats"
staload "trans1.sats"
staload "symbol.sats"
staload "trans2.sats"

staload _(*anon*) = "prelude/DATS/reference.dats"
staload _(*anon*) = "symbol.dats"

typedef sym = symbol_t

#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

#define Some0 option0_some
#define None0 option0_none

(* ******** *********** *)

implement symbol_LIST_CONS = symbol_make_name "list_cons"
implement symbol_LIST_NIL = symbol_make_name "list_nil"
implement symbol_LIST_IS_EMPTY = symbol_make_name "list_is_empty"
implement symbol_LIST_HEAD = symbol_make_name "list_head"
implement symbol_LIST_TAIL = symbol_make_name "list_tail"

implement symbol_STRING_ADD = symbol_make_name "string_add"

val label_LIST_CONS = funlab_allocate symbol_LIST_CONS
val label_LIST_NIL = funlab_allocate symbol_LIST_NIL
val label_LIST_IS_EMPTY = funlab_allocate symbol_LIST_IS_EMPTY
val label_LIST_HEAD = funlab_allocate symbol_LIST_HEAD
val label_LIST_TAIL = funlab_allocate symbol_LIST_TAIL
val label_STRING_ADD = funlab_allocate symbol_STRING_ADD

val t2yp_list = T2YPlist (T2YPvar)
val t2yp_LIST_CONS = T2YPfun (3, T2YPenv :: T2YPvar :: t2yp_list :: nil, t2yp_list)
val t2yp_LIST_NIL = T2YPfun (1, T2YPenv :: nil, t2yp_list)
val t2yp_LIST_IS_EMPTY = T2YPfun (2, T2YPenv :: t2yp_list :: nil, T2YPbool)
val t2yp_LIST_HEAD = T2YPfun (2, T2YPenv :: t2yp_list :: nil, T2YPvar)
val t2yp_LIST_TAIL = T2YPfun (2, T2YPenv :: t2yp_list :: nil, t2yp_list)

val t2yp_STRING_ADD = T2YPfun (3, T2YPstr :: T2YPstr :: nil, T2YPstr)


abstype theConstTypMap_t

extern fun ConstTypMapFind (nam: sym): option0 t1yp

local

assume theConstTypMap_t = symenv_t (t1yp)

macdef list0_sing (x) = list0_cons (,(x), list0_nil ())

val theConstTypMap =
  res where {
  val t1yp_int1 = T1YPtup (t1yp_int :: nil)
  val t1yp_int2 = T1YPtup (t1yp_int :: t1yp_int :: nil)
  val t1yp_str1 = T1YPtup (t1yp_string :: nil)
  val t1yp_str2 = T1YPtup (t1yp_string :: t1yp_string :: nil)
  val t1yp_aop = T1YPfun (ref_make_elt<int> (2), t1yp_int2, t1yp_int)
  val t1yp_bop = T1YPfun (ref_make_elt<int> (2), t1yp_int2, t1yp_bool)
  typedef T = @(sym, t1yp)
  val cts = (
    (symbol_PLUS, t1yp_aop) ::
    (symbol_MINUS, t1yp_aop) ::
    (symbol_TIMES, t1yp_aop) ::
    (symbol_SLASH, t1yp_aop) ::
    (symbol_UMINUS, T1YPfun (ref_make_elt<int> (1), t1yp_int1, t1yp_int)) ::
    (symbol_GT, t1yp_bop) ::
    (symbol_GTE, t1yp_bop) ::
    (symbol_LT, t1yp_bop) ::
    (symbol_LTE, t1yp_bop) ::
    (symbol_EQ, t1yp_bop) ::
    (symbol_NEQ, t1yp_bop) ::
    (symbol_PRINT_INT, T1YPfun (ref_make_elt<int> (1), t1yp_int1, t1yp_unit)) ::
    (symbol_PRINT, T1YPfun (ref_make_elt<int> (1), t1yp_str1, t1yp_unit)) ::
    (symbol_STRING_ADD, T1YPfun (ref_make_elt<int> (2), t1yp_str2, t1yp_str1)) ::
    nil ()
  ) : list0 (T) // end of [val]
  val res: theConstTypMap_t = symenv_make ()
  fun loop (
    cts: list0 (T), res: theConstTypMap_t
  ) : theConstTypMap_t =
    case+ cts of
    | ct :: cts => let
        val res(*_already*) = symenv_insert (res, ct.0, ct.1) in loop (cts, res)
      end // end of [::]
    | nil () => res
  // end of [loop]  
  val res = loop (cts, res)
} // end of [val]

in // in of [local]

fun ConstTypMapFind (nam: sym): option0 t1yp =
  symenv_lookup<t1yp> (theConstTypMap, nam)
// end of [theConstTypFind]

end // end of [local]

implement
libOprTypFind (opr) = let
  val+ OPR sym = opr
in
  ConstTypMapFind (sym)
end  // end of [libOprTypFind]

fun constructorTypFind (fname: sym): option0 t1yp =
  case+ 0 of
  | _ when fname = symbol_LIST_CONS => let
    // list_cons (x: X, xs: list X): list X
    val t1var = t1Var_new ()
    val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
    val X = T1YPvar (t1var)
    val listX = T1YPlist (t1var)
    val args = X :: listX :: nil
  in
    Some0 (T1YPfun (ref_make_elt<int> (2), T1YPtup (args), listX))
  end
  | _ when fname = symbol_LIST_NIL => let
    // list_nil (): list X
    val t1var = t1Var_new ()
    val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
    val listX = T1YPlist (t1var)
  in
    Some0 (T1YPfun (ref_make_elt<int> (0), t1yp_unit, listX))
  end
  | _ when fname = symbol_LIST_IS_EMPTY => let
    // list_is_empty (xs: list X): bool
    val t1var = t1Var_new ()
    val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
    val listX = T1YPlist (t1var)
  in
    Some0 (T1YPfun (ref_make_elt<int> (1), listX, t1yp_bool))
  end
  | _ when fname = symbol_LIST_HEAD => let
    // list_head (xs: list X): X
    val t1var = t1Var_new ()
    val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
    val X = T1YPvar (t1var)
    val listX = T1YPlist (t1var)
  in
    Some0 (T1YPfun (ref_make_elt<int> (1), listX, X))
  end
  | _ when fname = symbol_LIST_TAIL => let
    // list_tail (xs: list X): list X
    val t1var = t1Var_new ()
    val () = t1Var_set_typ (t1var, T1YPvar (t1Var_new ()))
    val listX = T1YPlist (t1var)
  in
    Some0 (T1YPfun (ref_make_elt<int> (1), listX, listX))
  end
  | _ => None0 ()

(* ****** ****** *)

(* fun libSymTypFind (nam: $Symbol.symbol_t): option0 $Trans1.t1yp *)
implement libSymTypFind (nam) = let
  val t1yp_opt = ConstTypMapFind (nam)
in
  case+ t1yp_opt of
  | Some0 _ => t1yp_opt
  | None0 () => constructorTypFind (nam)
end

implement libFunVPFind (fname) =
todo
  case+ 0 of
  | _ when fname = symbol_LIST_CONS => 
      Some0 (make_valprim (VPfun (label_LIST_CONS), t2yp_LIST_CONS))
  | _ when fname = symbol_LIST_NIL => 
      Some0 (make_valprim (VPfun (label_LIST_NIL), t2yp_LIST_NIL))
  | _ when fname = symbol_LIST_IS_EMPTY =>
      Some0 (make_valprim (VPfun (label_LIST_IS_EMPTY), t2yp_LIST_IS_EMPTY))
  | _ when fname = symbol_LIST_HEAD =>
      Some0 (make_valprim (VPfun (label_LIST_HEAD), t2yp_LIST_HEAD))
  | _ when fname = symbol_LIST_TAIL =>
      Some0 (make_valprim (VPfun (label_LIST_TAIL), t2yp_LIST_TAIL))
  | _ when fname = symbol_STRING_ADD =>
      Some0 (make_valprim (VPfun (label_STRING_ADD), t2yp_STRING_ADD))
  | _ => None0 ()







