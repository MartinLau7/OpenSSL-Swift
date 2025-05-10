#pragma once

#ifndef W_BIO_H
#define W_BIO_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/bio.h>

int c_BIO_get_mem_data(BIO *bp, char **buf);

#ifdef __cplusplus
} // extern C
#endif

#endif
