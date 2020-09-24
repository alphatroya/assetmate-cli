//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser
import Foundation

struct ImageAsset: Encodable {
    struct Image: Encodable {
        let filename: String
        let idiom: String
    }

    let images: [Image]
    let info: ColorAsset.Info

    init(imageName: String) {
        images = [
            .init(filename: imageName, idiom: "universal"),
        ]
        info = .init(version: 1, author: "xcode")
    }
}

struct AddImage: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Add given pdf or svg file to the Asset catalog"
    )

    @Argument(help: "Path to the pdf or svg file", completion: .file(extensions: ["pdf", "svg"]))
    var file: String

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder", completion: .directory)
    var output: String

    @Option(name: .shortAndLong, help: "Name for a image asset")
    var name: String

    @Flag(name: .shortAndLong, help: "Should overwrite file if it is exists")
    var force = false

    func run() throws {
        let pdf = ".pdf"
        let svg = ".svg"
        guard file.hasSuffix(pdf) || file.hasSuffix(svg) else {
            throw ValidationError("That command support only pdf or svg files")
        }

        let folder = URL(fileURLWithPath: output)
            .appendingPathComponent(name)
            .appendingPathExtension("imageset")
        let manager = FileManager.default
        if manager.fileExists(atPath: folder.path) {
            if !force {
                print("Folder \(name) already exists in Asset catalog")
                throw ExitCode(1)
            } else {
                try manager.removeItem(at: folder)
            }
        }
        try manager.createDirectory(at: folder, withIntermediateDirectories: true)
        let fileExtension = file.hasSuffix(pdf) ? pdf : svg
        let imagePath = name + fileExtension
        let meta = ImageAsset(imageName: imagePath)
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(meta)
        try data.write(to: folder.appendingPathComponent("Contents.json"))

        try manager.moveItem(at: URL(fileURLWithPath: file), to: folder.appendingPathComponent(imagePath))
    }
}
