//
// Created by Alexey Korolev on 15.10.2020.
//

import Foundation
import Yams
import ArgumentParser

struct Configuration: Decodable {
    var asset: Asset
}

protocol AssetConfigLoader {
    func load(_ asset: Asset?) throws -> Configuration
}

extension AssetConfigLoader {
    private var decoder: YAMLDecoder {
        YAMLDecoder()
    }

    private var fileName: String {
        "assetmate.yml"
    }

    private var configLoaderError: Error {
        ValidationError("you should either set --asset option or specify it in config file (\(self.fileName))")
    }

    func load(_ asset: Asset?) throws -> Configuration {
        if let asset = asset {
            return .init(asset: asset)
        }
        let url = URL(fileURLWithPath: fileName)
        guard let data = try? Data(contentsOf: url),
            let config = try? decoder.decode(Configuration.self, from: data) else {
            throw self.configLoaderError
        }
        return config
    }
}