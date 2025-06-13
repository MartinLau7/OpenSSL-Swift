#include "pal_stack.h"
#include <openssl/safestack.h>
#include <openssl/stack.h>

void cc_sk_OPENSSL_STRING_free(STACK_OF(OPENSSL_STRING) * st) {
    sk_OPENSSL_STRING_free(st);
}

char *cc_sk_OPENSSL_STRING_value(const STACK_OF(OPENSSL_STRING) * st, int idx) {
    return sk_OPENSSL_STRING_value(st, idx);
}

int cc_sk_OPENSSL_STRING_num(const STACK_OF(OPENSSL_STRING) * st) {
    return sk_OPENSSL_STRING_num(st);
}