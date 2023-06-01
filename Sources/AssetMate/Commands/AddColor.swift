import ArgumentParser
import Foundation

enum AddColorError: Error {
    case wrongDataGeneration
}

struct AddColor: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Request color name for the given hex description and add it to the Asset catalog"
    )

    @Argument(help: "HEX string without # prefix")
    var hex: HEX

    @Option(help: "Name for color asset")
    var name: String?

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder", completion: .directory)
    var asset: Asset?

    @Flag(name: .shortAndLong, help: "Enable verbose logging")
    var verbose: Bool = false

    func run() throws {
        try hex.validate()

        let response = try requestProvider.sync(Request(hex: hex)).get()
        if verbose {
            print("New color asset name: \(response.name.value)")
        }

        guard let data = response.json else {
            throw AddColorError.wrongDataGeneration
        }

        let config = try load(asset)
        let folderURL = URL(fileURLWithPath: config.asset)
        let name = self.name ?? response.name.value.kebab
        let assetFolder = folderURL.appendingPathComponent(name + ".colorset")

        let fileManager = FileManager.default
        try fileManager.createDirectory(at: assetFolder, withIntermediateDirectories: false)
        try data.write(to: assetFolder.appendingPathComponent("Contents.json"))
        if verbose {
            print("File have written to the directory: \(assetFolder)")
        } else {
            print(name)
        }
    }
}

extension AddColor: AssetConfigLoader {}
