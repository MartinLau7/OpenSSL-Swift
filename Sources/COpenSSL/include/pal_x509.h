#include <openssl/x509.h>

unsigned long cc_X509_NAME_hash(X509_NAME *name);

#if OPENSSL_VERSION_NUMBER >= 0x30000000L
unsigned long cc_X509_NAME_hash_ex(X509_NAME *name, OSSL_LIB_CTX *libctx);
#endif

