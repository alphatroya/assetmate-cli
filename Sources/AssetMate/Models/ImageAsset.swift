struct ImageAsset: Encodable {
    struct Image: Encodable {
        let filename: String
        let idiom: String
    }

    let images: [Image]
    let info: AssetInfo

    init(imageName: String) {
        images = [
            .init(filename: imageName, idiom: "universal"),
        ]
        info = .xcodeDefault()
    }
}
