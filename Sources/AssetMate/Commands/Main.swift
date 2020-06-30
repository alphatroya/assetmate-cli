//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A CLI helper for working with Asset.xcassets folder in iOS projects",
        subcommands: [
            Add.self,
            ConvertAlpha.self,
            Generate.self,
            Group.self,
            Identify.self,
            Inspect.self,
            Version.self,
        ]
    )
}
