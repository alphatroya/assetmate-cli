//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

extension String {
    var kebab: String {
        lowercased().replacingOccurrences(of: " ", with: "-")
    }
}
