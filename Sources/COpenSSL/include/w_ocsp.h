#pragma once

#ifndef W_OCSP_H
#define W_OCSP_H

#ifdef __cplusplus
extern "C" {
#endif

#include <openssl/ocsp.h>

int c_i2d_OCSP_REQUEST_bio(BIO *out, OCSP_REQUEST *req);

OCSP_RESPONSE *c_d2i_OCSP_RESPONSE_bio(BIO *bp, OCSP_RESPONSE **resp);

#ifdef __cplusplus
} // extern C
#endif

#endif