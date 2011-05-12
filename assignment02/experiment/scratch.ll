; ModuleID = 'scratch.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-linux-gnu"

@.str = private constant [10 x i8] c"d is %ld\0A\00", align 1 ; <[10 x i8]*> [#uses=1]


define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %argc_addr = alloca i32                         ; <i32*> [#uses=1]
  %argv_addr = alloca i8**                        ; <i8***> [#uses=1]
  %retval = alloca i32                            ; <i32*> [#uses=2]

  %addr_count = alloca i32
  store i32 0, i32* %addr_count

  br label %start

start:
  %count = load i32* %addr_count
  %count1 = add i32 %count, 1
  store i32 %count1, i32* %addr_count

  %len = call i32 @myid (i32 10000000)
  %addr1 = alloca i32, i32 1000000  ;%len  ; replace with %len to see the generated code
  store i32 1, i32* %addr1
  %b1 = load i32* %addr1, align 4
  %z1 = call i32 @myprint (i32 %b1)

  
  %addr2 = alloca i32, i32 250
  store i32 2, i32* %addr2
  %b2 = load i32* %addr2, align 4
  %z2 = call i32 @myprint (i32 %b2)


  %z3 = call i32 @myprint (i32 %count)


  br label %start

  br label %return

return:                                           ; preds = %bb2
  ret i32 2
}

declare i32 @myprint(i32)
declare i32 @myid(i32)
