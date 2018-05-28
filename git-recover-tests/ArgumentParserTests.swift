//
//  GitRecoverTests.swift
//  GitRecoverTests
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import XCTest

final class ArgumentParserTests: XCTestCase {

    private let _username: String = NSUserName()

    private func _optionalDate(fromArguments arguments: [String]) -> Date? {
        do {
            return try ArgumentParser.date(fromArguments: arguments)
        } catch {}
        return nil
    }

    private func _assertDateNotNilAndEqual(arguments: [String], dateString: String) {
        let date = _optionalDate(fromArguments: arguments)
        let dateTwo = ArgumentParser.formatter.date(from: dateString)
        XCTAssertNotNil(date)
        XCTAssertNotNil(dateTwo)
        XCTAssertEqual(date!, dateTwo!)
    }

    func testDateFunction_Nullability() {
        XCTAssertNil(_optionalDate(fromArguments: []))
        XCTAssertNil(_optionalDate(fromArguments: ["-t"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-"]))
        XCTAssertNil(_optionalDate(fromArguments: ["", "-t"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-t", "foo"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-d", "-t", "1/5/2018", "5:5", "pm", "-d"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "01/5/2018", "5:05", "pm", "-d", "-d", "ok", ""]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "01/5/2018", "05:05", "pm"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "01/5/2018", "5:05", "pm"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-t", "01/05/18", "5:05", "pm"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-t", "01/05/18", "5:05", "", "pm"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "1/05/2018", "5:05", "pm"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-d", "-t", "1/05/2018", "15:05", "pm"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-t", "13/11/2018", "05:05", "AM"]))
        XCTAssertNil(_optionalDate(fromArguments: ["-t", "13/11/2018", "05:05"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "01/05/2018", "05:05", "pm"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "10/05/2018", "05:05", "pm"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "10/05/2018", "05:05", "am"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "10/05/2018", "05:05", "AM"]))
        XCTAssertNotNil(_optionalDate(fromArguments: ["-t", "12/11/2018", "10:05", "AM"]))
    }

    func testDateFunction_Equality() {
        _assertDateNotNilAndEqual(arguments: ["-t", "1/15/2018", "5:5", "pm"], dateString: "01/15/2018 05:05 pm")
        _assertDateNotNilAndEqual(arguments: ["-d", "-t", "10/1/2018", "5:15", "pm"], dateString: "10/01/2018 05:15 PM")
        _assertDateNotNilAndEqual(arguments: ["-t", "12/15/2100", "10:15", "pm"], dateString: "12/15/2100 10:15 pm")
    }

    private func _optionalDirectoryURL(fromArguments arguments: [String]) -> URL? {
        do {
            return try ArgumentParser.directory(fromArguments: arguments)
        } catch  {}
        return nil
    }

    func testDirectoryFunction_Nullability() {
        XCTAssertNotNil(_optionalDirectoryURL(fromArguments: ["-d", "/Users/"]))
        XCTAssertNotNil(_optionalDirectoryURL(fromArguments: ["-d", "/Users"]))
        XCTAssertNil(_optionalDirectoryURL(fromArguments: ["-d", "Users/"]))
        XCTAssertNil(_optionalDirectoryURL(fromArguments: ["-d", "/DirectoryThatShouldn'tExist/"]))
        XCTAssertNotNil(_optionalDirectoryURL(fromArguments: ["-d", "/Users/\(_username)/"]))
        XCTAssertNotNil(_optionalDirectoryURL(fromArguments: ["-d", "/Users/\(_username)"]))
    }

    func testDirectoryFunction() {
        let basePath = "/Users/\(_username)"
        let paths: [String] = ["\(basePath)/test3",
                            "\(basePath)/foo/",
                            "\(basePath)/test2/",
                            "\(basePath)/1235",
                            "\(basePath)/1235/1545",
                            "\(basePath)/1235/1545/1",
                            "\(basePath)/1235/1545/1/15",
                            "\(basePath)/15"]
        paths.forEach {
            _assertTrueCreatedDirectory(atPath: $0)
        }

        paths.reversed().forEach {
            $0.delete()
        }
    }

    private func _assertTrueCreatedDirectory(atPath path: String) {

        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            let directoryURL = try ArgumentParser.directory(fromArguments: ["-d", path])
            XCTAssertEqual(directoryURL, URL(fileURLWithPath: path))
        } catch let error {
            XCTFail("\(path) \(error)")
            if (error as NSError).code == 516 { // file exists
                path.delete()
                _assertTrueCreatedDirectory(atPath: path)
            }
        }
    }
}
