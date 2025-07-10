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

