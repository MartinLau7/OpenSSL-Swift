#pragma once
#ifndef W_X509_H
#define W_X509_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/x509.h>

unsigned long c_X509_NAME_hash(X509_NAME *name);

#ifdef __cplusplus
} // extern C
#endif

#endif