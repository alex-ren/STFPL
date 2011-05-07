
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.env_t = type opaque
%struct.tuple_t = type opaque



define i32 @main(i32 %argc, i8* %argv) nounwind {
entry:
  %argc_addr = alloca i32, align 4
  %argv_addr = alloca i8*, align 8
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %argc, i32* %argc_addr
  store i8* %argv, i8** %argv_addr
  call void (...)* @init_lib() nounwind
  %1 = call i64 @__main(%struct.env_t* null) nounwind
  store i32 0, i32* %0, align 4
  %2 = load i32* %0, align 4
  store i32 %2, i32* %retval, align 4
  br label %return

return:
  %retval1 = load i32* %retval
  ret i32 %retval1



declare void @init_lib(...)
declare i32 @printf(i8* noalias, ...) nounwind
declare i32 @puts(i8*)
