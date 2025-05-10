#pragma once

#ifndef W_STACK_H
#define W_STACK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/safestack.h>

void c_sk_OPENSSL_STRING_free(STACK_OF(OPENSSL_STRING) * st);

char *c_sk_OPENSSL_STRING_value(const STACK_OF(OPENSSL_STRING) * st, int idx);

int c_sk_OPENSSL_STRING_num(const STACK_OF(OPENSSL_STRING) * st);

#ifdef __cplusplus
} // extern C
#endif

#endif
