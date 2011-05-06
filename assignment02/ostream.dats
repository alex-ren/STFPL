
staload "ostream.sats"

local
  assume ostream_t = string
in
  implement ostream_new () = ""

  implement ostream_in (os, s) = let
    val () = os := string0_append(os, s)
  in end

  implement print_ostream (os) = print os
end  // end of [local]


