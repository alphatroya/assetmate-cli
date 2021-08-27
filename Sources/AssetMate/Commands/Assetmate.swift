//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

@main
struct Assetmate: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A CLI helper for working with Assets.xcassets folder in iOS projects",
        version: "0.0.32",
        subcommands: [
            AddColor.self,
            AddImage.self,
            ConfigSet.self,
            ConvertAlpha.self,
            Group.self,
            Identify.self,
            Inspect.self,
        ]
    )
}
