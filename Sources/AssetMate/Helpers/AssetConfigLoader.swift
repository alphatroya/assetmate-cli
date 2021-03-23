//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

import ArgumentParser
import Foundation
import Yams

struct Configuration: Codable {
    var asset: Asset
}

protocol AssetConfigLoader: ConfigParamsProvider {
    func load(_ asset: Asset?) throws -> Configuration
}

extension AssetConfigLoader {
    private var configLoaderError: Error {
        ValidationError("you should either set --asset option or specify it in config file (\(configFileName))")
    }

    func load(_ asset: Asset?) throws -> Configuration {
        if let asset = asset {
            return .init(asset: asset)
        }
        let url = URL(fileURLWithPath: configFileName)
        guard let data = try? Data(contentsOf: url),
            let config = try? decoder.decode(Configuration.self, from: data) else {
            throw configLoaderError
        }
        return config
    }
}
