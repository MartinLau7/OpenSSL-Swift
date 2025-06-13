#include "pal_ocsp.h"

#include <openssl/err.h>
#include <openssl/ossl_typ.h>
#include <openssl/ocsp.h>

int c_i2d_OCSP_REQUEST_bio(BIO *out, OCSP_REQUEST *req) {
    ERR_clear_error();
    return i2d_OCSP_REQUEST_bio(out, req);
}

OCSP_RESPONSE *c_d2i_OCSP_RESPONSE_bio(BIO *bp, OCSP_RESPONSE **resp) {
    ERR_clear_error();
    return d2i_OCSP_RESPONSE_bio(bp, resp);
}
