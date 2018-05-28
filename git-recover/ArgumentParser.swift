//
//  ArgumentParser.swift
//  GitRecover
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import Foundation

final class ArgumentParser {

    private static let _dateFormat: String = "MM/dd/yyyy hh:mm a"
    static let formatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = _dateFormat
        return d
    }()

    static let usageInstructions: String = "**GitRecover**\nRevert directory to it's local versionp.\nUSAGE:\nDirectory: '-d [directory] <DIRECTORY>'\n'-t [time that directory should be reverted to] \(_dateFormat)' ie: '1/15/2018 5:05 pm'\nRevert directory to it's local directory at the given time"

    private static let _directoryErrorString: String = "No directory argument specified.\nUSAGE:\n'-d <DIRECTORY>'"

    static func directory(fromArguments arguments: [String]) throws -> URL {
        guard let idxOfDirectoryArgument = arguments.indices.first(where: { arguments[$0] == "-d"}),
              let directoryArgument = arguments[safe: idxOfDirectoryArgument + 1] else {
            throw _directoryErrorString
        }
        return try _validatedDirectory(URL(fileURLWithPath: directoryArgument))
    }

    private static func _validatedDirectory(_ url: URL) throws -> URL {
        var archaicBoolean: ObjCBool = true
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &archaicBoolean) else {
            throw _directoryErrorString
        }
        return url
    }

    static func date(fromArguments arguments: [String]) throws -> Date {

        guard let idxOfDateArgument = arguments.indices.first(where: { arguments[$0] == "-t" }) else {
            throw "No time argument specified.\nUSAGE: '-t \(_dateFormat)' ie: '11/15/2018 5:05 pm'"
        }

        guard let dayDateString = arguments[safe: idxOfDateArgument + 1], let years = dayDateString.components(separatedBy: "/").last, years.count == 4 else {
            throw "Calendar date invalid.\nUSAGE: '-t \(_dateFormat)' ie: '11/15/2018 5:05 pm'"
        }

        guard let hourDateString = arguments[safe: idxOfDateArgument + 2] else {
            throw "Hour and minutes not specified.\nUSAGE: '-t \(_dateFormat)' ie: '11/15/2018 5:05 pm'"
        }

        guard let amPmSymbolString = arguments[safe: idxOfDateArgument + 3] else {
            throw "am/pm not specified.\nUSAGE: '-t \(_dateFormat)' ie: '11/15/2018 5:05 pm'"
        }

        let concatenatedDateString = "\(dayDateString) \(hourDateString) \(amPmSymbolString)"
        guard let date = formatter.date(from: concatenatedDateString) else {
            throw "Unable to parse date.\nUSAGE: '-t \(_dateFormat)' ie: '11/15/2018 5:05 pm'"
        }
        return date
    }

    private init() {
        fatalError("Static class shouldn't be initialized")
    }
}
