//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

struct Assetmate: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A CLI helper for working with Asset.xcassets folder in iOS projects",
        version: "0.0.25",
        subcommands: [
            AddColor.self,
            AddImage.self,
            ConvertAlpha.self,
            Group.self,
            Identify.self,
            Inspect.self,
        ]
    )
}
