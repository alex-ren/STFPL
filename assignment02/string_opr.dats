
staload "string_opr.sats"
staload "libats/smlbas/SATS/string.sats"

staload "prelude/DATS/list.dats"
staload "prelude/DATS/list0.dats"

dynload "libats/smlbas/DATS/string.dats"

#define :: list0_cons
#define cons list0_cons
#define nil list0_nil

implement string_formalize (str) = let
  val cs = explode (str)
  fun loop (cs: list0 char, accu: list0 char): list0 char =
    case+ cs of
    | cons (c, cs1) => if c = '\n' then loop (cs1, 'n' :: '\\' :: accu)
                       else loop (cs1, c :: accu)
    | nil () => accu

  val cs = loop (cs, nil)
  val cs = list0_reverse (cs)
  val cs = implode (cs)
  val cs = "\"" + cs + "\""
in
  cs
end

