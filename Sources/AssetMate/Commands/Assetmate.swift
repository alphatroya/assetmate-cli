//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

struct Assetmate: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A CLI helper for working with Asset.xcassets folder in iOS projects",
        subcommands: [
            AddColor.self,
            AddImage.self,
            ConvertAlpha.self,
            Group.self,
            Identify.self,
            Inspect.self,
        ]
    )

    @Flag(name: .long, help: "Print tool version")
    var version: Bool = false

    func run() throws {
        guard version else {
            throw CleanExit.helpRequest(Assetmate.self)
        }
        print("0.0.23")
    }
}
