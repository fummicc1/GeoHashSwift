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
        os_log(
            .fault,
            dso: #dsohandle,
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
