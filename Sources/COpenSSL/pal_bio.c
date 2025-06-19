#include "pal_bio.h"

int cc_BIO_get_mem_data(BIO *bp, char **buf) {
    return BIO_get_mem_data(bp, buf);
}

int cc_BIO_should_retry(BIO *bp) {
    return BIO_should_retry(bp);
}

int cc_BIO_flush(BIO *bp) {
    return BIO_flush(bp);
}