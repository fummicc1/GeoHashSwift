//
//  RuntimeWarning.swift
//  GeoHash
//
//  Created by Fumiya Tanaka on 2024/12/17.
//

import Foundation
import OSLog

actor RuntimeWarning {
    var info = Dl_info()

    init() {
#if DEBUG
        dladdr(
            dlsym(
                dlopen(
                    nil,
                    RTLD_LAZY
                ),
                """
                $sxSg7SwiftUI8CommandsA2bCRzlAbCP4body4BodyQzvgTW
                """
            ),
            &info
        )
        #endif
    }

    func log(message: StaticString, args: any CVarArg...) {
        #if DEBUG
        os_log(
            .fault,
            dso: info.dli_fbase,
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