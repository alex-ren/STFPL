(*
** Some patch code
*)

(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"
staload _(*anon*) = "prelude/DATS/list0.dats"
staload _(*anon*) = "prelude/DATS/reference.dats"

(* ****** ****** *)

extern
castfn option0_of_option_vt {a:t@ype} (xs: Option_vt a):<> option0 a

extern fun{a:t@ype}
list0_find_fun (xs: list0 a, pred: a -<fun1> bool): option0 a
implement{a}
list0_find_fun (xs, pred) = let
  val ans = list_find_fun (list1_of_list0 (xs), pred)
in
  option0_of_option_vt (ans)
end // end of [list0_find_fun]

extern fun{a:t@ype}
list0_find_cloref (xs: list0 a, pred: a -<cloref1> bool): option0 a
implement{a}
list0_find_cloref (xs, pred) = let
  val ans = list_find_cloref (list1_of_list0 (xs), pred)
in
  option0_of_option_vt (ans)
end // end of [list0_find_cloref]

