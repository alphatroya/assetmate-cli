//
// AssetMate
// 2021 Alexey Korolev <alphatroya@gmail.com>
//

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(ios_color_mateTests.allTests),
        ]
    }
#endif
