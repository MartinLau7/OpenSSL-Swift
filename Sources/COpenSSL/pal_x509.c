#include "pal_x509.h"
#include <openssl/x509.h>
#include <openssl/safestack.h>

unsigned long cc_X509_NAME_hash(X509_NAME *name) {
#if OPENSSL_VERSION_NUMBER >= 0x30000000L
    return X509_NAME_hash_ex(name, NULL, NULL, NULL);
#else
    return X509_NAME_hash(name);
#endif
}

#if OPENSSL_VERSION_NUMBER >= 0x30000000L
unsigned long cc_X509_NAME_hash_ex(X509_NAME *name, OSSL_LIB_CTX *libctx) {
    return X509_NAME_hash_ex(name, libctx, NULL, NULL);
}
#endif

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