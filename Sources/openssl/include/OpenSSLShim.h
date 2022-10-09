#ifndef OpenSSLShim_h
#define OpenSSLShim_h

// This is for instances when `swift package generate-xcodeproj` is used as CNIOBoringSSL
// is treated as a framework and requires the framework's name as a prefix.
#if __has_include(<openssl/openssl.h>)
#include <openssl/openssl.h>
#else
#include "openssl.h"
#endif

// This is a wrapper function to wrap the call to SSL_CTX_set_alpn_select_cb() which is
// only available from OpenSSL v1.0.2. Calling this function with older version will do
// nothing.
static inline SSL_CTX_set_alpn_select_cb_wrapper(SSL_CTX *ctx,
                                                 int (*cb)(SSL *ssl,
                                                           const unsigned char **out,
                                                           unsigned char *outlen,
                                                           const unsigned char *in,
                                                           unsigned int inlen,
                                                           void *arg),
                                                 void *arg);

// This is a wrapper function to wrap the call to SSL_get0_alpn_selected() which is
// only available from OpenSSL v1.0.2. Calling this function with older version will do
// nothing.
static inline SSL_get0_alpn_selected_wrapper(const SSL *ssl, const unsigned char **data,
                                             unsigned int *len);

// This is a wrapper function that allows the setting of AUTO ECDH mode when running
// on OpenSSL v1.0.2. Calling this function on an older version will have no effect.
static inline SSL_CTX_setAutoECDH(SSL_CTX *ctx);

// This is a wrapper function that allows older versions of OpenSSL, that use mutable
// pointers to work alongside newer versions of it that use an immutable pointer.
static inline int SSL_EVP_digestVerifyFinal_wrapper(EVP_MD_CTX *ctx, const unsigned char *sig, size_t siglen);

// Initialize OpenSSL
static inline void OpenSSL_SSL_init(void);

// This is a wrapper function to get server SSL_METHOD based on OpenSSL version.
static inline const SSL_METHOD *OpenSSL_server_method(void);

// This is a wrapper function to get client SSL_METHOD based on OpenSSL version.
static inline const SSL_METHOD *OpenSSL_client_method(void);

static inline long OpenSSL_SSL_CTX_set_mode(SSL_CTX *context, long mode);

static inline long OpenSSL_SSL_CTX_set_options(SSL_CTX *context);

// This wrapper allows for a common call for both versions of OpenSSL when creating a new HMAC_CTX.
static inline HMAC_CTX *HMAC_CTX_new_wrapper();

// This wrapper allows for a common call for both versions of OpenSSL when freeing a HMAC_CTX.
static inline void HMAC_CTX_free_wrapper(HMAC_CTX *ctx);

// This wrapper avoids getting a deprecation warning with OpenSSL 1.1.x.
static inline int HMAC_Init_wrapper(HMAC_CTX *ctx, const void *key, int len, const EVP_MD *md);

// This wrapper allows for a common call for both versions of OpenSSL when creating a new EVP_MD_CTX.
static inline EVP_MD_CTX *EVP_MD_CTX_new_wrapper(void);

// This wrapper allows for a common call for both versions of OpenSSL when freeing a EVP_MD_CTX.
static inline void EVP_MD_CTX_free_wrapper(EVP_MD_CTX *ctx);

// This wrapper allows for a common call for both versions of OpenSSL when creating a new EVP_CIPHER_CTX.
static inline EVP_CIPHER_CTX *EVP_CIPHER_CTX_new_wrapper(void);

// This wrapper allows for a common call for both versions of OpenSSL when initalizing an EVP_CIPHER_CTX.
static inline void EVP_CIPHER_CTX_init_wrapper(EVP_CIPHER_CTX *ctx);

// This wrapper allows for a common call for both versions of OpenSSL when resetting an EVP_CIPHER_CTX.
static inline int EVP_CIPHER_CTX_reset_wrapper(EVP_CIPHER_CTX *ctx);

// This wrapper allows for a common call for both versions of OpenSSL when freeing a new EVP_CIPHER_CTX.
static inline void EVP_CIPHER_CTX_free_wrapper(EVP_CIPHER_CTX *ctx);

// This wrapper allows for a common call for both versions of OpenSSL when setting other keys for RSA.
static inline void RSA_set_keys(RSA *rsakey, BIGNUM *n, BIGNUM *e, BIGNUM *d, BIGNUM *p, BIGNUM *q, BIGNUM *dmp1, BIGNUM *dmq1, BIGNUM *iqmp);

static inline void EVP_PKEY_assign_wrapper(EVP_PKEY *pkey, RSA *rsakey);

#endif
