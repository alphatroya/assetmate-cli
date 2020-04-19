//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser
import Foundation

enum GenerateError: Error {
    case wrongDataGeneration
}

struct Generate: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Generate color asset from the given hex string"
    )

    @Argument(help: "HEX string without # prefix")
    var hex: HEX

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder")
    var output: String

    @Flag(name: .shortAndLong, help: "Enable verbose logging")
    var verbose: Bool

    func run() throws {
        try hex.validate()

        let response = try requestProvider.sync(Request(hex: hex)).get()
        if verbose {
            print("New color asset name: \(response.name.value)")
        }

        guard let data = response.json else {
            throw GenerateError.wrongDataGeneration
        }

        let folderURL = URL(fileURLWithPath: output)
        let name = response.name.value.kebab
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
