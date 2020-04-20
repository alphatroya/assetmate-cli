//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

private let hexRegexp = #"^([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"#

typealias HEX = String

extension HEX {
    func validate() throws {
        guard range(of: hexRegexp, options: .regularExpression) != nil else {
            throw ValidationError("Argument hex not contain a valid string")
        }
    }
}
