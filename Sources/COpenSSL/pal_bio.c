#include "pal_bio.h"
#include <openssl/err.h>

int cc_BIO_get_mem_data(BIO *bp, char **buf) {
    ERR_clear_error();
    return BIO_get_mem_data(bp, buf);
}

int cc_BIO_should_retry(BIO *bp) {
    ERR_clear_error();
    return BIO_should_retry(bp);
}

int cc_BIO_flush(BIO *bp) {
    ERR_clear_error();
    return BIO_flush(bp);
}