#include "c_w_ocsp.h"

#include <openssl/ossl_typ.h>
#include <openssl/ocsp.h>

int c_i2d_OCSP_REQUEST_bio(BIO *out, OCSP_REQUEST *req) {
    return i2d_OCSP_REQUEST_bio(out, req);
}

OCSP_RESPONSE *c_d2i_OCSP_RESPONSE_bio(BIO *bp, OCSP_RESPONSE **resp) {
    return d2i_OCSP_RESPONSE_bio(bp, resp);
}

int c_BIO_get_mem_data(BIO *bp, char **buf) {
    return BIO_get_mem_data(bp, buf);
}
