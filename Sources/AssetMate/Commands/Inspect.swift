//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

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

    @Option(name: .shortAndLong, default: 3, help: "Tolerance for color comparison")
    var tolerance: Int

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder")
    var asset: String

    @Flag(name: .shortAndLong, help: "Enable verbose logging")
    var verbose: Bool

    func run() throws {
        let folderURL = URL(fileURLWithPath: asset)

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
            guard firstAsset.color.components.isHex else {
                if verbose {
                    print("Skip \(directory), isn't hex represented unit")
                }
                continue
            }
            if firstAsset.color.components.compare(with: hex, tolerance: tolerance),
                let name = directory.lastPathComponent.components(separatedBy: ".").first {
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
