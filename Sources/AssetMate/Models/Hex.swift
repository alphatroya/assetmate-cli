//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser

private let hexRegexp = #"^([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"#

typealias HEX = String

extension HEX {
    var red: Int? {
        do {
            try validate()
            let red = self[startIndex ..< index(startIndex, offsetBy: 2)]
            return Int(red, radix: 16)
        } catch {
            return nil
        }
    }

    var green: Int? {
        do {
            try validate()
            let green = self[index(startIndex, offsetBy: 2) ..< index(startIndex, offsetBy: 4)]
            return Int(green, radix: 16)
        } catch {
            return nil
        }
    }

    var blue: Int? {
        do {
            try validate()
            let blue = self[index(startIndex, offsetBy: 4) ..< index(startIndex, offsetBy: 6)]
            return Int(blue, radix: 16)
        } catch {
            return nil
        }
    }

    func validate() throws {
        guard range(of: hexRegexp, options: .regularExpression) != nil else {
            throw ValidationError("Argument hex not contain a valid string")
        }
    }
}
