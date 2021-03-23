//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser
import Foundation
import Yams

struct ConfigSet: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Add params to assetmate.yml config"
    )

    @Option(name: .shortAndLong, help: "Path to Assets.xcassets folder")
    var asset: Asset

    func run() throws {
        var config: Configuration
        do {
            config = try load(nil)
            config.asset = asset
        } catch {
            config = Configuration(asset: asset)
        }
        let data = try encoder.encode(config)
        let url = URL(fileURLWithPath: ".").appendingPathComponent(configFileName)
        try data.write(to: url, atomically: true, encoding: .utf8)
    }
}

extension ConfigSet: AssetConfigLoader {}
