#include <openssl/ocsp.h>

int cc_i2d_OCSP_REQUEST_bio(BIO *out, OCSP_REQUEST *req);

OCSP_RESPONSE *cc_d2i_OCSP_RESPONSE_bio(BIO *bp, OCSP_RESPONSE **resp);