// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Linux)
	#if arch(aarch64)
		let targetTriple = "aarch64-linux-gnu"
	#else
		let targetTriple = "x86_64-linux-gnu"
	#endif
#endif

let package = Package(
	name: "OpenSSL-Swift",
	platforms: [
		.iOS(.v12),
		.macOS(.v10_14),
		.watchOS(.v7),
		.tvOS(.v14),
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "OpenSSL",
			targets: ["OpenSSL"]
		),
		.library(
			name: "COpenSSL",
			targets: ["COpenSSL"]
		),
	],
	targets: .collection([
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.productItem(
			.binaryTarget(
				name: "OpenSSL",
				url: "https://github.com/krzyzanowskim/OpenSSL/releases/download/3.3.3001/OpenSSL.xcframework.zip",
				checksum: "bd02bfeb7a01b63a5b210e3327b7eac3887badb73137f3ddc37de504e6555cfb"
			),
			when: [.macOS, .iOS, .tvOS, .watchOS]
		),
		.productItems(
			[
				.target(
					name: "OpenSSL",
					path: "Sources/OpenSSL",
					publicHeadersPath: ".",
					cSettings: [
						.unsafeFlags(["-I/usr/include/openssl"]),
					],
					linkerSettings: [
						.unsafeFlags([
							"-Xlinker", "--whole-archive",
							"-Xlinker", "/usr/lib/\(targetTriple)/libcrypto.a",
							"-Xlinker", "/usr/lib/\(targetTriple)/libssl.a",
							"-Xlinker", "--no-whole-archive",
						]),
					]
				),
				.target(
					name: "COpenSSL",
					dependencies: [
						"OpenSSL",
					],
					path: "Sources/COpenSSL",
				),
			],
			when: [.linux]
		),
	])
)

extension Platform {
	#if os(macOS)
		static let current: Platform = .macOS
	#elseif os(iOS)
		static let current: Platform = .iOS
	#elseif os(tvOS)
		static let current: Platform = .tvOS
	#elseif os(watchOS)
		static let current: Platform = .watchOS
	#elseif os(Android)
		static let current: Platform = .android
	#elseif os(Linux)
		static let current: Platform = .linux
	#elseif os(Windows)
		static let current: Platform = .windows
	#else
		#error("Unsupported platform.")
	#endif
}

private extension Array {
	static func collection(_ items: [[Element]]) -> [Element] {
		items.flatMap { $0 }
	}

	static func productItems(_ items: [Element], when platforms: [Platform]? = nil) -> [Element] {
		guard let platforms = platforms else { return items }
		return platforms.contains(.current) ? items : []
	}

	static func productItem(_ item: Element, when platforms: [Platform]? = nil) -> [Element] {
		productItems([item], when: platforms)
	}
}
