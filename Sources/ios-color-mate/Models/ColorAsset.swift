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

        var joined: String? {
            guard self.red.hasPrefix("0x"), self.green.hasPrefix("0x"), self.blue.hasPrefix("0x") else {
                return nil
            }
            let red = self.red.dropFirst(2)
            let green = self.green.dropFirst(2)
            let blue = self.blue.dropFirst(2)
            return String(red + green + blue)
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
