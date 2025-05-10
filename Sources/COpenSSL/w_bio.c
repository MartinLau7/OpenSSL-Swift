#include "w_bio.h"

int c_BIO_get_mem_data(BIO *bp, char **buf) {
    return BIO_get_mem_data(bp, buf);
}
