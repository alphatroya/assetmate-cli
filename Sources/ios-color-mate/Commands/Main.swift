//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A CLI helper for working with HEX colors in iOS projects",
        subcommands: [Identify.self, Generate.self]
    )
}
