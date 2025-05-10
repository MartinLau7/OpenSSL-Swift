#include "w_x509.h"
#include <openssl/x509.h>
#include <openssl/safestack.h>

unsigned long c_X509_NAME_hash(X509_NAME *name) {
    return X509_NAME_hash(name);
}

STACK_OF(X509) * c_sk_X509_new(void) {
    return sk_X509_new_null(); // 实际等价于 sk_X509_new(NULL)
}

int c_sk_X509_push(STACK_OF(X509) * stack, X509 *cert) {
    return sk_X509_push(stack, cert);
}

void c_sk_X509_free(STACK_OF(X509) * stack) {
    sk_X509_free(stack);
}

void c_sk_X509_pop_free(STACK_OF(X509) * stack) {
    sk_X509_pop_free(stack, X509_free);
}