#include <openssl/x509.h>
#include <openssl/safestack.h>

unsigned long cc_X509_NAME_hash(X509_NAME *name);

#if OPENSSL_VERSION_NUMBER >= 0x30000000L
unsigned long cc_X509_NAME_hash_ex(X509_NAME *name, OSSL_LIB_CTX *libctx);
#endif

STACK_OF(X509) * cc_sk_X509_new(void);

int cc_sk_X509_push(STACK_OF(X509) * stack, X509 *cert);

void cc_sk_X509_free(STACK_OF(X509) * stack);

void cc_sk_X509_pop_free(STACK_OF(X509) * stack);