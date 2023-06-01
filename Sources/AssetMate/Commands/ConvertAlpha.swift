import ArgumentParser

struct ConvertAlpha: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Convert foreground color mixed with background with given alpha using linear interpolation"
    )

    @Option(name: .shortAndLong, help: "Foreground color")
    var foreground: HEX = "000000"

    @Option(name: .shortAndLong, help: "Background color")
    var background: HEX = "FFFFFF"

    @Option(name: .shortAndLong, help: "Alpha value")
    var alpha: Float

    func run() throws {
        try foreground.validate()
        try background.validate()
        guard case 0 ... 1 = alpha else {
            throw ValidationError("Given alpha value not in the 0 ... 1 bounds")
        }
        guard let fRed = foreground.red,
              let fGreen = foreground.green,
              let fBlue = foreground.blue
        else {
            throw ValidationError("Failed to convert foreground color to int value")
        }
        guard let bRed = background.red,
              let bGreen = background.green,
              let bBlue = background.blue
        else {
            throw ValidationError("Failed to convert background color to int value")
        }

        let rRed = bRed + Int(Float(fRed - bRed) * alpha)
        let rGreen = bGreen + Int(Float(fGreen - bGreen) * alpha)
        let rBlue = bBlue + Int(Float(fBlue - bBlue) * alpha)

        print(String(format: "%02X", rRed) + String(format: "%02X", rGreen) + String(format: "%02X", rBlue))
    }
}
