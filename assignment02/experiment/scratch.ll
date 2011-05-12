; ModuleID = 'scratch.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@.str = private constant [10 x i8] c"d is %ld\0A\00", align 1

define i32 @id(i32 %x) nounwind {
entry:
  %x_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x_addr
  %1 = load i32* %x_addr, align 4
  store i32 %1, i32* %0, align 4
  %2 = load i32* %0, align 4
  store i32 %2, i32* %retval, align 4
  br label %return

return:                                           ; preds = %entry
  %retval1 = load i32* %retval
  ret i32 %retval1
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %argc_addr = alloca i32, align 4
  %argv_addr = alloca i8**, align 8
  %retval = alloca i32
  %0 = alloca i32
  %a = alloca i32
  %d = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %argc, i32* %argc_addr
  store i8** %argv, i8*** %argv_addr
  store i32 10, i32* %a, align 4
  br label %bb1

bb:                                               ; preds = %bb1
  ;%1 = load i32* %a, align 4
  ;%2 = sub nsw i32 %1, 2
  ;store i32 %2, i32* %a, align 4

  %x = call i32 @id(i32 7)
  %alc = alloca i32, i32 %x
  store i32 %x, i32* %alc
  %y = load i32* %alc
  %r = call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([10 x i8]* @.str, i64 0, i64 0), i32 %y) nounwind


  %alc2 = alloca i32
  store i32 9, i32* %alc2
  %z = load i32* %alc2
  %r2 = call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([10 x i8]* @.str, i64 0, i64 0), i32 %z) nounwind

  
  %q = load i32* %alc
  %r3 = call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([10 x i8]* @.str, i64 0, i64 0), i32 %q) nounwind
  br label %bb1

bb1:                                              ; preds = %bb, %entry
  ;%3 = load i32* %a, align 4
  %cmpret = icmp sgt i32 1, 0
  br i1 %cmpret, label %bb, label %bb2

bb2:                                              ; preds = %bb1
  ;%5 = load i32* %a, align 4
  ;store i32 %5, i32* %d, align 4
  ;%6 = load i32* %d, align 4
  ;%7 = call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([10 x i8]* @.str, i64 0, i64 0), i32 %6) nounwind
  ;%8 = load i32* %d, align 4
  ;store i32 %8, i32* %0, align 4
  ;%9 = load i32* %0, align 4
  ;store i32 %9, i32* %retval, align 4
  br label %return

return:                                           ; preds = %bb2
  ;%retval3 = load i32* %retval
  ret i32 3
}

declare i32 @printf(i8* noalias, ...) nounwind
