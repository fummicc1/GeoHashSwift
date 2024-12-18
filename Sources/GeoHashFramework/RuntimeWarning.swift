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
        var dso: UnsafeRawPointer?
        // ref: https://github.com/pointfreeco/swift-issue-reporting/blob/a3f634d1a409c7979cabc0a71b3f26ffa9fc8af1/Sources/IssueReporting/IssueReporters/RuntimeWarningReporter.swift#L39-L55
        let count = _dyld_image_count()
        for i in 0..<count {
          if let name = _dyld_get_image_name(i) {
            let swiftString = String(cString: name)
            if swiftString.hasSuffix("/SwiftUI") {
              if let header = _dyld_get_image_header(i) {
                dso = UnsafeRawPointer(header)
              }
            }
          }
        }
        guard let dso = dso else {
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
}
