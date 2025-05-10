#pragma once
#ifndef W_X509_H
#define W_X509_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/x509.h>
#include <openssl/safestack.h>

unsigned long c_X509_NAME_hash(X509_NAME *name);

STACK_OF(X509) * c_sk_X509_new(void);

int c_sk_X509_push(STACK_OF(X509) * stack, X509 *cert);

void c_sk_X509_free(STACK_OF(X509) * stack);

void c_sk_X509_pop_free(STACK_OF(X509) * stack);

#ifdef __cplusplus
} // extern C
#endif

#endif