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
    }

    struct FractionRGB: Decodable {
        let r: Double
        let g: Double
        let b: Double
    }

    let name: Name
    let rgb: RGB
}

extension Response.FractionRGB {
    var json: String {
        """
        {
          "info" : {
            "version" : 1,
            "author" : "xcode"
          },
          "colors" : [
            {
              "color" : {
                "color-space" : "srgb",
                "components" : {
                  "green" : "\(g)",
                  "alpha" : "1.000",
                  "blue" : "\(b)",
                  "red" : "\(r)"
                }
              },
              "idiom" : "universal"
            }
          ]
        }
        """
    }
}
