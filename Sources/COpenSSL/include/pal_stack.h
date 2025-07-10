#include <openssl/safestack.h>
#include <openssl/x509.h>

// MARK: - OpenSSL

void cc_sk_OPENSSL_STRING_free(STACK_OF(OPENSSL_STRING) * st);

char *cc_sk_OPENSSL_STRING_value(const STACK_OF(OPENSSL_STRING) * st, int idx);

int cc_sk_OPENSSL_STRING_num(const STACK_OF(OPENSSL_STRING) * st);

// MARK: - Certificates

STACK_OF(X509) * cc_sk_X509_new(void);

int cc_sk_X509_push(STACK_OF(X509) * stack, X509 *cert);

void cc_sk_X509_free(STACK_OF(X509) * stack);

void cc_sk_X509_pop_free(STACK_OF(X509) * stack);

int cc_sk_X509_num (STACK_OF(X509) * stack);

X509 * cc_sk_X509_value(STACK_OF(X509) * stack, int idx);
