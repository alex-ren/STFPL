(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

exception Fatal of int (*errcode*)

fun abort {a:viewt@ype} (err: int):<!exn> a

#define ERRORCODE_TYPE_ERROR 1
#define ERRORCODE_OUT_OF_BOUND 2

#define ETRACE_LEVEL_DEBUG 10
#define ETRACE_LEVEL_INFO 9
#define ETRACE_LEVEL_ERROR 5

#define ETRACE_LEVEL_CUR 9

macdef ETRACE (x) = ,(x)
macdef ETRACE (x) = ()

macdef ETRACE_MSG (obj, level) = let
  val () = if ,(level) <= ETRACE_LEVEL_CUR then
    print ,(obj) 
in 
  ()
end

macdef ETRACE_OPR (opr, level) = 
  if ,(level) <= ETRACE_LEVEL_CUR then ,(opr)

macdef ETRACE_MSG_OPR (obj, level, oper) = let
  val () = if ,(level) <= ETRACE_LEVEL_CUR then
    print ,(obj) 
in 
  ,(oper)
end

(* ****** ****** *)

(* end of [error.sats] *)


