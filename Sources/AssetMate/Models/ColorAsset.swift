struct ColorAsset: Codable {
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

        func compare(with hex: HEX, tolerance: Int) -> Bool {
            let oRed: Int
            let oGreen: Int
            let oBlue: Int

            if isHex {
                guard let hRed = Int(red.dropFirst(2), radix: 16),
                      let hGreen = Int(green.dropFirst(2), radix: 16),
                      let hBlue = Int(blue.dropFirst(2), radix: 16)
                else {
                    return false
                }
                oRed = hRed
                oGreen = hGreen
                oBlue = hBlue
            } else if isFloat {
                guard let fRed = Double(red),
                      let fGreen = Double(green),
                      let fBlue = Double(blue)
                else {
                    return false
                }
                oRed = Int(fRed * 255)
                oGreen = Int(fGreen * 255)
                oBlue = Int(fBlue * 255)
            } else {
                guard let iRed = Int(red),
                      let iGreen = Int(green),
                      let iBlue = Int(blue)
                else {
                    return false
                }
                oRed = iRed
                oGreen = iGreen
                oBlue = iBlue
            }

            guard let red = hex.red,
                  let green = hex.green,
                  let blue = hex.blue
            else {
                return false
            }

            return abs(oRed - red) <= tolerance &&
                abs(oGreen - green) <= tolerance &&
                abs(oBlue - blue) <= tolerance
        }

        private var isHex: Bool {
            guard red.hasPrefix("0x"), green.hasPrefix("0x"), blue.hasPrefix("0x") else {
                return false
            }
            return true
        }

        private var isFloat: Bool {
            guard red.hasPrefix("0."), green.hasPrefix("0."), blue.hasPrefix("0.") else {
                return false
            }
            return true
        }
    }

    let info: AssetInfo
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
        info = .xcodeDefault()
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
