struct AssetInfo: Codable {
    let version: Int
    let author: String

    static func xcodeDefault() -> AssetInfo {
        .init(version: 1, author: "xcode")
    }
}
