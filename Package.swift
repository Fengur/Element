import PackageDescription

let package = Package(
    name: "Element",
	dependencies: [
		.Package(url: "https://github.com/eonist/swift-utils.git", Version(0, 0, 0, prereleaseIdentifiers: ["alpha", "6"]))
    ],
	exclude: ["README.md"]
) 
