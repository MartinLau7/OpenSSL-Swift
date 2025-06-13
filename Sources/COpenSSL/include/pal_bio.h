#include <openssl/bio.h>

int cc_BIO_get_mem_data(BIO *bp, char **buf);

int cc_BIO_should_retry(BIO *bp);

int cc_BIO_flush(BIO *bp);

