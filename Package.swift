// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Platform {
	#if os(macOS)
		static let current: Platform = .macOS
	#elseif os(iOS)
		static let current: Platform = .iOS
	#elseif os(tvOS)
		static let current: Platform = .tvOS
	#elseif os(watchOS)
		static let current: Platform = .watchOS
	#elseif os(Linux)
		static let current: Platform = .linux
	#elseif os(Windows)
		static let current: Platform = .windows
	#else
		#error("Unsupported platform.")
	#endif
}

private extension Array {
	static func collection<Element>(_ items: [[Element]]) -> [Element] {
		return items.flatMap { $0 }
	}

	static func productItem<Element>(_ item: Element, when platforms: [Platform]? = nil) -> [Element] {
		if let platforms = platforms {
			if !platforms.contains(.current) {
				return []
			}
		}
		return [item]
	}

	static func productItems<Element>(_ items: [Element], when platforms: [Platform]? = nil) -> [Element] {
		if let platforms = platforms {
			if !platforms.contains(.current) {
				return []
			}
		}
		return items
	}
}

let package = Package(
	name: "OpenSSL",
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
			targets: ["openssl"]
		),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
	],
	targets: .collection([
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.productItem(
			.binaryTarget(
				name: "openssl",
				url: "https://github.com/MartinLau7/openssl-apple/releases/download/v1.1.1w/openssl-static.xcframework.zip",
				checksum: "6eb6482ce8d8c35126760859b272e0b9e4a1250f8021ed3546d0eaa39b95492d"
			),
			when: [.macOS, .iOS, .tvOS, .watchOS]
		),
		.productItem(
			.systemLibrary(
				name: "openssl",
				pkgConfig: "openssl",
				providers: [
					.apt(["openssl libssl-dev"]),
				]
			),
			when: [.linux]
		),
	])
)
