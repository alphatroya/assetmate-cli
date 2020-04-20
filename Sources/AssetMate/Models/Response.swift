//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import Foundation

struct Response: Decodable {
    struct Name: Decodable {
        let value: String
    }

    struct RGB: Decodable {
        let fraction: FractionRGB
        let r: Int
        let g: Int
        let b: Int
    }

    struct FractionRGB: Decodable {
        let r: Double
        let g: Double
        let b: Double
    }

    struct Hex: Decodable {
        let value: String
        let clean: String
    }

    let name: Name
    let hex: Hex
    let rgb: RGB
}

extension Response {
    var json: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(
            ColorAsset(self)
        )
    }
}
