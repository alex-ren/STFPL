
#include "stfpl_header.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>

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

void llist_push_back(llist xs, any x)
{
    node n = malloc(sizeof(node_t));
    n->m_item = x;
    n->m_next = 0;

    if (0 == xs->m_first)
    {
        xs->m_first = xs->m_last = n;
    }
    else
    {
        xs->m_last->m_next = n;
        xs->m_last = n;
    }
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
list list_create ()
{
    list p = malloc(sizeof(list_t));
    llist_init(&p->m_list);

    return p;
}

void list_add (list list, any item)
{
    llist_push_back(&list->m_list, item);
}
    
any list_get (list list, int pos)
{
    return llist_get_item(&list->m_list, pos);
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

char * string_add(char *to, char *from)
{
    return strcat(to, from);
}
    





