
abstype ostream_t
typedef ostream = ostream_t

fun ostream_new (): ostream

fun ostream_in (os: &ostream, s: string): void

fun print_ostream (os: ostream): void
