
#include "stfpl_header.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

/* ********************* ******************** */

typedef struct struct_node node_t;
typedef node_t * node;
struct struct_node {
    any m_item;
    node m_next;
};

typedef struct struct_llist {
    node m_first;
    node m_last;
} llist_t;
typedef llist_t *llist;

/* ********************* ******************** */

llist llist_create()
{
    llist p = malloc(sizeof(llist_t));
    p->m_first = 0;
    p->m_last = 0;
}

void llist_init(llist xs)
{
    xs->m_first = xs->m_last = 0;
}

void llist_print(llist xs)
{
    // printf("llist_print\n");
    assert(0 != xs);
    node node = xs->m_first;

    while (0 != node)
    {
        printf("%d -> ", (long)node->m_item);
        node = node->m_next;
    }
    printf("nil");
}


void llist_push_back(llist xs, any x)
{
    // printf("llist_push_back\n");
    assert(0 != xs);
    node n = malloc(sizeof(node_t));
    assert(0 != n);

    n->m_item = x;
    n->m_next = 0;

    if (0 == xs->m_first)
    {
        xs->m_first = n;
        xs->m_last = n;
    }
    else
    {
        xs->m_last->m_next = n;
        xs->m_last = n;
    }
}

llist llist_add_front(llist xs, any x)
{
    assert(0 != xs);

    llist p = malloc(sizeof(llist_t));
    llist_init (p);

    node n = malloc(sizeof(node_t));
    n->m_item = x;
    n->m_next = xs->m_first;

    p->m_first = n;

    if (0 == xs->m_last)
    {
        p->m_last = n;
    }
    else
    {
        p->m_last = xs->m_last;
    }

    return p;
}


any llist_get_item(llist xs, int pos)
{
    node n = xs->m_first;

    while (pos > 0)
    {
        assert(n != 0);
        n = n->m_next;
        pos--;
    }
    assert(n != 0);
    return n->m_item;
}

llist llist_tail (llist xs)
{
    assert(0 != xs->m_first);
    node first = xs->m_first->m_next;
    node last = 0;

    if (xs->m_first == xs->m_last)
    {
        last = 0;
    }
    else
    {
        last = xs->m_last;
    }

    llist p = malloc(sizeof(llist_t));
    p->m_first = first;
    p->m_last = last;

    return p;
}
        
bool llist_is_empty(llist xs)
{
    if (0 == xs->m_first)
    {
        return true;
    }
    else
    {
        return false;
    }
}

/* ********************* ******************** */

struct struct_tuple {
    llist_t m_list;
};


struct struct_env {
    llist_t m_list;
};

struct struct_list {
    llist_t m_list;
};

struct struct_closure {
    void * m_fun;
    env_t m_env;
};

/* ********************* ******************** */

void env_add(env, any);

env env_create ()
{
    env p = malloc(sizeof(env_t));
    llist_init(&p->m_list);

    return p;
}

void env_init(env env)
{
    llist_init(&env->m_list);
}

void env_add (env env, any item)
{
    llist_push_back(&env->m_list, item);
}
    
any env_get (env env, int pos)
{
    return llist_get_item(&env->m_list, pos);
}

/* ********************* ******************** */

closure closure_create()
{
    closure p = malloc(sizeof(closure_t));
    p->m_fun = 0;
    env_init(&p->m_env);

    return p;
}

any closure_get_fun(closure closure)
{
    // printf("========closure_get_fun\n");
    return closure->m_fun;
}

env closure_get_env(closure closure)
{
    return &closure->m_env;
}

void closure_put_fun(closure closure, any fun)
{
    closure->m_fun = fun;
}

void closure_add_env(closure closure, any item)
{
    env_add(&closure->m_env, item);
}

/* ********************* ******************** */

tuple tuple_create ()
{
    tuple p = malloc(sizeof(tuple_t));
    llist_init(&p->m_list);

    return p;
}

void tuple_add (tuple tuple, any item)
{
    llist_push_back(&tuple->m_list, item);
}
    
any tuple_get (tuple tuple, int pos)
{
    return llist_get_item(&tuple->m_list, pos);
}

/* ********************* ******************** */

list   fun_list_cons(any, list);
list   fun_list_nil();
any    fun_list_head(list);
list   fun_list_tail(list);
bool   fun_list_is_empty(list);

list   closure_list_cons(env, any, list);
list   closure_list_nil(env);
any    closure_list_head(env, list);
list   closure_list_tail(env, list);
bool   closure_list_is_empty(env, list);

list fun_list_cons(any item, list xs)
{
    list p = malloc(sizeof(list_t));

    llist ls = llist_add_front(&xs->m_list, item);
    p->m_list = *ls;
    free (ls);

    return p;
}

list closure_list_cons(env env, any item, list xs)
{
    return fun_list_cons(item, xs);
}

list fun_list_nil()
{
    list p = malloc(sizeof(list_t));
    llist_init(&p->m_list);

    return p;
}

list closure_list_nil(env env)
{
    return fun_list_nil();
}

any fun_list_head(list xs)
{
    return llist_get_item(&xs->m_list, 0);
}

any closure_list_head(env env, list xs)
{
    return fun_list_head(xs);
}

list fun_list_tail(list xs)
{
    llist p = llist_tail(&xs->m_list);
    list ys = malloc(sizeof(list_t));

    ys->m_list = *p;
    free(p);
    return ys;
}

list closure_list_tail(env env, list xs)
{
    return fun_list_tail(xs);
}

bool fun_list_is_empty(list xs)
{
    return llist_is_empty(&xs->m_list);
}

bool closure_list_is_empty(env env, list xs)
{
    return fun_list_is_empty(xs);
}

void list_print(list xs)
{
    llist_print(&xs->m_list);
}

/* ********************* ******************** */

string fun_string_add(string, string);
string closure_string_add(env, string, string);

string fun_string_add(string to, string from)
{
    int nto = strlen(to);
    int nfrom = strlen(from);
    int len = (nto + nfrom + 1);
    char * szBuffer = malloc(len * sizeof(char));
    memset(szBuffer, 0, len);
    strcpy(szBuffer, to);

    return strcat(szBuffer, from);
}

string closure_string_add(env env, string to, string from)
{
    return fun_string_add(to, from);
}

/* ********************* ******************** */

string fun_tostring_int(int);
string closure_tostring_int(env, int);

string fun_tostring_int(int n)
{
    static char szBuffer[100];
    memset(szBuffer, 0, 100);
    sprintf(szBuffer, "%d", n);
    
    int len = strlen(szBuffer) + 1;
    char *str = malloc(len * sizeof(char));
    strcpy(str, szBuffer);

    return str;
}

string closure_tostring_int(env env, int i)
{
    return fun_tostring_int(i);
}

/* ********************* ******************** */

int fun_input_int();
int closure_input_int(env);

int fun_input_int()
{
    int d = 0;
    scanf("%d", &d);
    return d;
}

int closure_input_int(env env)
{
    return fun_input_int();
}

/* ********************* ******************** */

closure list_cons     = 0;
closure list_nil      = 0;
closure list_head     = 0;
closure list_tail     = 0;
closure list_is_empty = 0;

closure string_add    = 0;
closure tostring_int  = 0;
closure input_int  = 0;

/* ********** ************ */

void init_lib()
{
    list_cons     = closure_create();
    list_nil      = closure_create();
    list_head     = closure_create();
    list_tail     = closure_create();
    list_is_empty = closure_create();
    string_add    = closure_create();
    tostring_int  = closure_create();
    input_int     = closure_create();

    closure_put_fun(list_cons,     (void*)closure_list_cons);
    closure_put_fun(list_nil,      (void*)closure_list_nil);
    closure_put_fun(list_head,     (void*)closure_list_head);
    closure_put_fun(list_tail,     (void*)closure_list_tail);
    closure_put_fun(list_is_empty, (void*)closure_list_is_empty);
    closure_put_fun(string_add,    (void*)closure_string_add);
    closure_put_fun(tostring_int,  (void*)closure_tostring_int);
    closure_put_fun(input_int,     (void*)closure_input_int);
}


























