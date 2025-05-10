#include "w_x509.h"
#include <openssl/x509.h>

unsigned long c_X509_NAME_hash(X509_NAME *name) {
    return X509_NAME_hash(name);
}