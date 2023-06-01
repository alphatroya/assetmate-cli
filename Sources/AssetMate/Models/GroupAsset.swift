import Foundation

struct GroupAsset: Encodable {
    var info: AssetInfo = .xcodeDefault()
    var properties: GroupAssetProperties?

    init(withNamespaces: Bool) {
        if withNamespaces {
            properties = .init(providesNamespaces: withNamespaces)
        }
    }
}

struct GroupAssetProperties: Encodable {
    enum CodingKeys: String, CodingKey {
        case providesNamespace = "provides-namespace"
    }

    var providesNamespaces: Bool

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(providesNamespaces, forKey: .providesNamespace)
    }
}
