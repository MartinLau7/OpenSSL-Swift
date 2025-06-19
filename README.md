# OpenSSL

OpenSSL for Swift

> ⚠️ The current `main` branch is in development stage, and APIs may change frequently. Do not use it in production projects to avoid unexpected issues caused by interface changes.
>
> It is recommended to wait for the stable version to be released before using it in production environments.

TODO:

1. 重写整个OpenSSL, 移除 BIO
2. 不再完整添加整个openssl 封装，只根据Swift-Codesign 服务提供需要的函数封装
3. 提升 Swift 版本要求到 6.0， 移除所有  @_implementationOnly 前置声明