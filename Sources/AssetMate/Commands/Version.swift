//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

struct Version: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Print tool version"
    )

    func run() throws {
        print("0.0.12")
    }
}
