; ModuleID = 'scratch.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.closure_t = type opaque
%struct.env_t = type opaque
%struct.tuple_t = type opaque

@.str = private constant [3 x i8] c"%d\00", align 1
@.str1 = private constant [2 x i8] c"=\00", align 1
@tostring_int = external global %struct.closure_t*

define i64 @f_fn_0(%struct.env_t* %v_env_0, i64 %v_x_3) nounwind {
entry:
  %v_env_0_addr = alloca %struct.env_t*, align 8
  %v_x_3_addr = alloca i64, align 8
  %retval = alloca i64
  %0 = alloca i64
  %"alloca point" = bitcast i32 0 to i32
  store %struct.env_t* %v_env_0, %struct.env_t** %v_env_0_addr
  store i64 %v_x_3, i64* %v_x_3_addr
  %1 = load i64* %v_x_3_addr, align 8
  store i64 %1, i64* %0, align 8
  %2 = load i64* %0, align 8
  store i64 %2, i64* %retval, align 8
  br label %return

return:                                           ; preds = %entry
  %retval1 = load i64* %retval
  ret i64 %retval1
}

define i64 @__main(%struct.env_t* %v_env_0) nounwind {
entry:
  %v_env_0_addr = alloca %struct.env_t*, align 8
  %retval = alloca i64
  %0 = alloca i64
  %v_f_fn_0_2 = alloca %struct.closure_t*
  %v_5 = alloca i64
  %v_k_4 = alloca i64
  %v___6 = alloca %struct.tuple_t*
  %v___7 = alloca %struct.tuple_t*
  %v_kk_8 = alloca i8*
  %v_10 = alloca i32
  %v_kk_9 = alloca i64
  %"alloca point" = bitcast i32 0 to i32
  store %struct.env_t* %v_env_0, %struct.env_t** %v_env_0_addr
  %1 = call %struct.closure_t* (...)* @closure_create() nounwind
  store %struct.closure_t* %1, %struct.closure_t** %v_f_fn_0_2, align 8
  %2 = load %struct.closure_t** %v_f_fn_0_2, align 8
  call void @closure_put_fun(%struct.closure_t* %2, i8* bitcast (i64 (%struct.env_t*, i64)* @f_fn_0 to i8*)) nounwind
  %3 = load %struct.closure_t** %v_f_fn_0_2, align 8
  %4 = call i8* @closure_get_fun(%struct.closure_t* %3) nounwind
  %5 = bitcast i8* %4 to i64 (%struct.env_t*, i64)*
  %6 = load %struct.closure_t** %v_f_fn_0_2, align 8
  %7 = call %struct.env_t* @closure_get_env(%struct.closure_t* %6) nounwind
  %8 = call i64 %5(%struct.env_t* %7, i64 3) nounwind
  store i64 %8, i64* %v_5, align 8
  %9 = load i64* %v_5, align 8
  %10 = add nsw i64 %9, 4
  store i64 %10, i64* %v_k_4, align 8
  store %struct.tuple_t* null, %struct.tuple_t** %v___6, align 8
  %11 = load i64* %v_k_4, align 8
  %12 = call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([3 x i8]* @.str, i64 0, i64 0), i64 %11) nounwind
  store %struct.tuple_t* null, %struct.tuple_t** %v___7, align 8
  %13 = call i32 @puts(i8* getelementptr inbounds ([2 x i8]* @.str1, i64 0, i64 0)) nounwind
  %14 = load %struct.closure_t** @tostring_int, align 8
  %15 = call i8* @closure_get_fun(%struct.closure_t* %14) nounwind
  %16 = bitcast i8* %15 to i8* (%struct.env_t*, i64)*
  %17 = load %struct.closure_t** @tostring_int, align 8
  %18 = call %struct.env_t* @closure_get_env(%struct.closure_t* %17) nounwind
  %19 = call i8* %16(%struct.env_t* %18, i64 3) nounwind
  store i8* %19, i8** %v_kk_8, align 8
  %20 = load i64* %v_k_4, align 8
  %21 = icmp sle i64 %20, 0
  %22 = zext i1 %21 to i32
  store i32 %22, i32* %v_10, align 4
  %23 = load i32* %v_10, align 4
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %bb, label %bb1

bb:                                               ; preds = %entry
  store i64 3, i64* %v_kk_9, align 8
  br label %bb2

bb1:                                              ; preds = %entry
  store i64 4, i64* %v_kk_9, align 8
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  store i64 0, i64* %0, align 8
  %25 = load i64* %0, align 8
  store i64 %25, i64* %retval, align 8
  br label %return

return:                                           ; preds = %bb2
  %retval3 = load i64* %retval
  ret i64 %retval3
}

declare %struct.closure_t* @closure_create(...)

declare void @closure_put_fun(%struct.closure_t*, i8*)

declare i8* @closure_get_fun(%struct.closure_t*)

declare %struct.env_t* @closure_get_env(%struct.closure_t*)

declare i32 @printf(i8* noalias, ...) nounwind

declare i32 @puts(i8*)

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

return:                                           ; preds = %entry
  %retval1 = load i32* %retval
  ret i32 %retval1
}

declare void @init_lib(...)
