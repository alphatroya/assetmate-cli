//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

struct ColorAsset: Codable {
    struct Info: Codable {
        let version: Int
        let author: String
    }

    struct Color: Codable {
        let color: ColorSpec
        let idiom: String
    }

    struct ColorSpec: Codable {
        enum CodingKeys: String, CodingKey {
            case colorSpace = "color-space"
            case components
        }

        let colorSpace: String
        let components: Components

        init(colorSpace: String, components: Components) {
            self.colorSpace = colorSpace
            self.components = components
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            colorSpace = try container.decode(String.self, forKey: .colorSpace)
            components = try container.decode(Components.self, forKey: .components)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(colorSpace, forKey: .colorSpace)
            try container.encode(components, forKey: .components)
        }
    }

    struct Components: Codable {
        let green: String
        let alpha: String
        let blue: String
        let red: String

        var isHex: Bool {
            guard red.hasPrefix("0x"), green.hasPrefix("0x"), blue.hasPrefix("0x") else {
                return false
            }
            return true
        }

        func compare(with hex: HEX, tolerance: Int) -> Bool {
            guard let oRed = Int(red.dropFirst(2), radix: 16),
                let oGreen = Int(green.dropFirst(2), radix: 16),
                let oBlue = Int(blue.dropFirst(2), radix: 16) else {
                return false
            }

            guard let red = hex.red,
                let green = hex.green,
                let blue = hex.blue else {
                return false
            }

            return abs(oRed - red) <= tolerance &&
                abs(oGreen - green) <= tolerance &&
                abs(oBlue - blue) <= tolerance
        }
    }

    let info: Info
    let colors: [Color]
}

extension ColorAsset {
    init(_ response: Response) {
        let components: (r: String, g: String, b: String) = {
            let clean = response.hex.clean
            let start = clean.startIndex
            let rEnd = clean.index(start, offsetBy: 2)
            let gEnd = clean.index(rEnd, offsetBy: 2)
            let bEnd = clean.index(gEnd, offsetBy: 2)
            let r = String(clean[start ..< rEnd])
            let g = String(clean[rEnd ..< gEnd])
            let b = String(clean[gEnd ..< bEnd])
            return (r: r, g: g, b: b)
        }()
        info = .init(version: 1, author: "xcode")
        colors = [
            .init(
                color: .init(
                    colorSpace: "srgb",
                    components: .init(
                        green: "0x" + components.g,
                        alpha: "1.000",
                        blue: "0x" + components.b,
                        red: "0x" + components.r
                    )
                ),
                idiom: "universal"
            ),
        ]
    }
}
