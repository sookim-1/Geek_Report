//
//  CustomLog.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import OSLog

enum LogTag {

    case error
    case warning
    case success
    case debug
    case network
    case simOnly

    var label: String {
        switch self {
        case .error   : return "[APP ERROR 🔴]"
        case .warning : return "[APP WARNING 🟠]"
        case .success : return "[APP SUCCESS 🟢]"
        case .debug   : return "[APP DEBUG 🔵]"
        case .network : return "[APP NETWORK 🌍]"
        case .simOnly : return "[APP SIMULATOR ONLY 🤖]"
        }
    }

}

struct AppLogger {

    static func log(tag: LogTag = .debug, _ items: Any...,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line ,
                    separator: String = " ") {

        let shortFileName = URL(string: file)?.lastPathComponent ?? "---"

        let output = items.map {
            if let itm = $0 as? CustomStringConvertible {
                return "\(itm.description)"
            } else {
                return "\($0)"
            }
        }
            .joined(separator: separator)

        var msg = "\(tag.label) "
        let category = "\(shortFileName) - \(function) - line \(line)"
        if !output.isEmpty { msg += "\n\(output)" }

         let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "--", category: category)

        switch tag {
        case .error   : logger.error("\(msg)")
        case .warning : logger.warning("\(msg)")
        case .success : logger.info("\(msg)")
        case .debug   : logger.debug("\(msg)")
        case .network : logger.info("\(msg)")
        case .simOnly : logger.info("\(msg)")
        }
    }
}
