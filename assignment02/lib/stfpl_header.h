
#ifndef STFPL_HEADER_H
#define STFPL_HEADER_H

typedef void * any;
typedef int bool;
#define true 1
#define false 0
typedef char *string;

/* ********** ************ */

typedef struct struct_tuple tuple_t;
typedef tuple_t *tuple;

typedef struct struct_env env_t;
typedef env_t *env;

typedef struct struct_list list_t;
typedef list_t *list;

typedef struct struct_closure closure_t;
typedef closure_t *closure;

/* ********** ************ */

env env_create();
any env_get(env, int);

/* ********** ************ */

closure closure_create();
any closure_get_fun(closure);
env closure_get_env(closure);
void closure_put_fun(closure, any);
void closure_add_env(closure, any);

/* ********** ************ */

tuple tuple_create();
void tuple_add(tuple, any);
any tuple_get(tuple, int);

/* ********** ************ */

extern closure list_cons;
extern closure list_nil;
extern closure list_head;
extern closure list_tail;
extern closure list_is_empty;

void list_print(list);

extern closure string_add;
extern closure tostring_int;
extern closure input_int;

/* ********** ************ */

void init_lib();

/* ********** ************ */

#endif



