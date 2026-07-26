//
//  RuntimeWarning.swift
//  GeoHash
//
//  Created by Fumiya Tanaka on 2024/12/17.
//

import Foundation
import OSLog

enum RuntimeWarning {
    static func log(message: StaticString, args: any CVarArg...) {
        #if DEBUG
            guard let dso = swiftUIImageHeader() else {
                assertionFailure("Failed to get DSO")
                return
            }
            os_log(
                .fault,
                dso: dso,
                log: OSLog(
                    subsystem: "com.apple.runtime-issues",
                    category: "ReportRuntimeWarningSample"
                ),
                message,
                args
            )
        #endif
    }

    #if DEBUG
        /// Finds the SwiftUI image header so the warning is attributed to the
        /// runtime-issues category in Xcode.
        ///
        /// ref: https://github.com/pointfreeco/swift-issue-reporting/blob/a3f634d1a409c7979cabc0a71b3f26ffa9fc8af1/Sources/IssueReporting/IssueReporters/RuntimeWarningReporter.swift#L39-L55
        private static func swiftUIImageHeader() -> UnsafeRawPointer? {
            for i in 0..<_dyld_image_count() {
                guard let name = _dyld_get_image_name(i) else { continue }
                guard String(cString: name).hasSuffix("/SwiftUI") else { continue }
                if let header = _dyld_get_image_header(i) {
                    return UnsafeRawPointer(header)
                }
            }
            return nil
        }
    #endif
}
