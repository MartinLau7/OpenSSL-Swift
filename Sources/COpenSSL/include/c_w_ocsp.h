// Header file `OpenSSLWrapper_ocsp.h`
#pragma once

#ifndef C_W_OCSP_H
#define C_W_OCSP_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/bio.h>
#include <openssl/ocsp.h>

int c_i2d_OCSP_REQUEST_bio(BIO *out, OCSP_REQUEST *req);

OCSP_RESPONSE *c_d2i_OCSP_RESPONSE_bio(BIO *bp, OCSP_RESPONSE **resp);

int c_BIO_get_mem_data(BIO *bp, char **buf);

#ifdef __cplusplus
} // extern C
#endif

#endif