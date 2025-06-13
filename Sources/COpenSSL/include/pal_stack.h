#include <openssl/safestack.h>

void cc_sk_OPENSSL_STRING_free(STACK_OF(OPENSSL_STRING) * st);

char *cc_sk_OPENSSL_STRING_value(const STACK_OF(OPENSSL_STRING) * st, int idx);

int cc_sk_OPENSSL_STRING_num(const STACK_OF(OPENSSL_STRING) * st);