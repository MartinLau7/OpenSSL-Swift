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


STACK_OF(X509) * cc_sk_X509_new(void) {
    return sk_X509_new_null(); // 实际等价于 sk_X509_new(NULL)
}

int cc_sk_X509_push(STACK_OF(X509) * stack, X509 *cert) {
    return sk_X509_push(stack, cert);
}

void cc_sk_X509_free(STACK_OF(X509) * stack) {
    sk_X509_free(stack);
}

void cc_sk_X509_pop_free(STACK_OF(X509) * stack) {
    sk_X509_pop_free(stack, X509_free);
}

int cc_sk_X509_num (STACK_OF(X509) * stack) {
    return sk_X509_num(stack);
}

X509 * cc_sk_X509_value(STACK_OF(X509) * stack, int idx) {
    X509 *cert = sk_X509_value(stack, idx);
    return cert;
}
