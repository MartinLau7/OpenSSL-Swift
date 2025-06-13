#pragma once

#ifndef __cplusplus
#include <stdbool.h>
#endif

#ifndef PALEXPORT
#ifdef TARGET_UNIX
#define PALEXPORT __attribute__((__visibility__("default")))
#else
#define PALEXPORT
#endif
#endif // PALEXPORT

#ifndef EXTERN_C
#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C extern
#endif // __cplusplus
#endif // EXTERN_C
