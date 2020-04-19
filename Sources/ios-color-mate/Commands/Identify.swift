//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser
struct Identify: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Identify given hex color name"
    )

    @Argument(help: "HEX string without # prefix")
    var hex: HEX

    func run() throws {
        try hex.validate()

        let result = requestProvider.sync(Request(hex: hex))

        switch result {
        case let .success(data):
            print(data.name.value)
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
