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

struct Add: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Add given .pdf file to the Asset folder"
    )

    @Argument(help: "Path to the pdf file", completion: .file(extensions: ["pdf"]))
    var file: String

    @Option(name: .shortAndLong, help: "Path to output Assets.xcassets folder", completion: .directory)
    var output: String

    @Option(name: .shortAndLong, help: "Name for a image asset")
    var name: String

    func run() throws {
        guard file.hasSuffix(".pdf") else {
            throw ValidationError("That command support only pdf files")
        }

        let folder = URL(fileURLWithPath: output)
            .appendingPathComponent(name)
            .appendingPathExtension("imageset")
        let manager = FileManager.default
        guard !manager.fileExists(atPath: folder.path) else {
            throw ValidationError("Folder \(name) did exist in Asset catalog")
        }
        try manager.createDirectory(at: folder, withIntermediateDirectories: true)
        let pdf = name + ".pdf"
        let meta = ImageAsset(imageName: pdf)
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(meta)
        try data.write(to: folder.appendingPathComponent("Contents.json"))

        try manager.moveItem(at: URL(fileURLWithPath: file), to: folder.appendingPathComponent(pdf))
    }
}
