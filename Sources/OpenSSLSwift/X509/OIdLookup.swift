// public actor OIdLookup {
//     private var cache: [String: OId] = [:]

//     public func lookup(oid: String) -> OId? {
//         return cache[oid]
//     }

//     private init(predefinedOids: [OId] = []) {
//         for oid in predefinedOids {
//             cache[oid.oId] = oid
//         }
//     }

//     /// 添加单个 OId
//     private func appendEntry(_ oid: OId) {
//         cache[oid.oId] = oid
//     }

//     /// 批量添加多个 OId
//     private func appendEntry(contentsOf oids: [OId]) {
//         for oid in oids {
//             appendEntry(oid)
//         }
//     }

//     public static let shared = OIdLookup(predefinedOids: [
//         OId(oid: "2.5.4.3", shortName: "CN", longName: "commonName"),
//         OId(oid: "2.5.4.4", shortName: "SN", longName: "surname"),
//         OId(oid: "2.5.4.5", shortName: "serialNumber"),
//         OId(oid: "2.5.4.6", shortName: "C", longName: "countryName"),
//         OId(oid: "2.5.4.7", shortName: "L", longName: "localityName"),
//         OId(oid: "2.5.4.8", shortName: "ST", longName: "stateOrProvinceName"),
//         OId(oid: "2.5.4.9", shortName: "street", longName: "streetAddress"),
//         OId(oid: "2.5.4.10", shortName: "O", longName: "organizationName"),
//         OId(oid: "2.5.4.11", shortName: "OU", longName: "organizationalUnitName"),
//         OId(oid: "2.5.4.12", shortName: "title", longName: "title"),
//         OId(oid: "2.5.4.13", shortName: "description", longName: "description"),
//     ])
// }
