import Yams

protocol ConfigParamsProvider {
    var encoder: YAMLEncoder { get }
    var decoder: YAMLDecoder { get }
    var configFileName: String { get }
}

extension ConfigParamsProvider {
    var encoder: YAMLEncoder {
        YAMLEncoder()
    }

    var decoder: YAMLDecoder {
        YAMLDecoder()
    }

    var configFileName: String {
        "assetmate.yml"
    }
}
