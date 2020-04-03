//
// iOS Color Mate
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

extension String {
    var kebab: String {
        lowercased().replacingOccurrences(of: " ", with: "-")
    }
}
