//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

import Foundation

var stdErr = StandardErrorOutputStream()

struct StandardErrorOutputStream: TextOutputStream {
    let stderr = FileHandle.standardError

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return // encoding failure
        }
        stderr.write(data)
    }
}
