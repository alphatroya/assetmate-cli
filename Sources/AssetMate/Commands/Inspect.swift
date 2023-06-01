import ArgumentParser
import Foundation

struct Inspect: ParsableCommand {
    enum InspectError: Error {
        case empty
    }

    static var configuration = CommandConfiguration(
        abstract: "Check Assets.xcassets file for a given color"
    )

    @Argument(help: "HEX string without # prefix")
    var hex: HEX

    @Option(name: .shortAndLong, help: "Tolerance for color comparison")
    var tolerance: Int = 3

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder", completion: .directory)
    var asset: Asset?

    @Flag(name: .shortAndLong, help: "Enable verbose logging")
    var verbose: Bool = false

    func run() throws {
        let config = try load(asset)
        let folderURL = URL(fileURLWithPath: config.asset)

        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(
            at: folderURL,
            includingPropertiesForKeys: nil
        ) else {
            return
        }
        for file in enumerator {
            guard let directory = file as? URL else {
                continue
            }
            guard directory.absoluteString.hasSuffix(".colorset/") else {
                continue
            }
            let file = directory.appendingPathComponent("Contents.json")
            let data = try Data(contentsOf: file)
            let jsonDecoder = JSONDecoder()
            let colorAsset = try jsonDecoder.decode(ColorAsset.self, from: data)
            guard let firstAsset = colorAsset.colors.first else {
                continue
            }
            if firstAsset.color.components.compare(with: hex, tolerance: tolerance),
               let name = directory.lastPathComponent.components(separatedBy: ".").first
            {
                if verbose {
                    print("Found directory: \(directory)")
                } else {
                    print(name)
                }
                return
            }
        }
        throw ExitCode(1)
    }
}

extension Inspect: AssetConfigLoader {}
