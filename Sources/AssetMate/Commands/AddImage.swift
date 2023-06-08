import ArgumentParser
import Foundation
import Zip

struct AddImage: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Add a PDF or SVG file (optionally zip archived) to the Asset catalog"
    )

    @Argument(help: "Path to the PDF, SVG or ZIP file", completion: .file(extensions: ["pdf", "svg", "zip"]))
    var file: String

    @Option(name: .shortAndLong, help: "A path to the output Assets.xcassets folder", completion: .directory)
    var asset: Asset?

    @Option(name: .shortAndLong, help: "A name for the image asset")
    var name: String

    @Flag(name: .shortAndLong, help: "Should overwrite file if it exists")
    var force = false

    @Flag(name: .shortAndLong, help: "Should origin file not to be removed after success")
    var keep = false

    func run() throws {
        var file = file
        var unzipFolder: URL?
        if file.hasSuffix(".zip") {
            (file, unzipFolder) = try unzipFiles(file)
        }
        defer {
            if let rmFolder = unzipFolder {
                try? FileManager.default.removeItem(at: rmFolder)
            }
        }

        let pdf = ".pdf"
        let svg = ".svg"
        guard file.hasSuffix(pdf) || file.hasSuffix(svg) else {
            throw ValidationError("That command support only pdf or svg files")
        }

        let config = try load(asset)
        let folder = URL(fileURLWithPath: config.asset)
            .appendingPathComponent(name)
            .appendingPathExtension("imageset")
        let manager = FileManager.default
        if manager.fileExists(atPath: folder.path) {
            if !force {
                print("Folder \(name) already exists in Asset catalog", to: &stdErr)
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

        try completeTransaction(
            origin: URL(fileURLWithPath: file),
            destination: folder.appendingPathComponent(imagePath),
            removeOriginZip: unzipFolder != nil
        )
    }

    private func completeTransaction(origin: URL, destination: URL, removeOriginZip: Bool) throws {
        let manager = FileManager.default
        if !keep {
            try manager.moveItem(at: origin, to: destination)
            if removeOriginZip {
                try manager.removeItem(atPath: file)
            }
        } else {
            try manager.copyItem(at: origin, to: destination)
        }
    }

    private func unzipFiles(_ file: String) throws -> (newPath: String, folderToRemove: URL) {
        let url = URL(fileURLWithPath: file)
        let tmpFolder = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(url.lastPathComponent.replacingOccurrences(of: "." + url.pathExtension, with: ""))
        try Zip.unzipFile(url, destination: tmpFolder, overwrite: true, password: nil)
        let enumerator = FileManager.default.enumerator(at: tmpFolder, includingPropertiesForKeys: nil)
        while let element = enumerator?.nextObject() as? URL {
            if element.absoluteString.hasSuffix(".pdf") || element.absoluteString.hasSuffix(".svg") {
                return (element.path, tmpFolder)
            }
        }
        print("Zip file \(file) did not have any svg or pdf files", to: &stdErr)
        throw ExitCode(1)
    }
}

extension AddImage: AssetConfigLoader {}
