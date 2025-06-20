//
//  ObjectIdentifier+.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-20.
//

extension ObjectIdentifier: Equatable {
    public static func == (lhs: ObjectIdentifier, rhs: ObjectIdentifier) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
