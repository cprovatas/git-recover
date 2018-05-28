//
//  GitRecoverTests.swift
//  GitRecoverTests
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import XCTest

final class FileReverterTests: XCTestCase {

    private let _basePath: String = "/Users/\(NSUserName())"

    func testFileReversion() {
        let directory = "\(_basePath)/test"
        performFileTests(directory: directory)
        directory.createDirectory()
        let subdirectory = "\(directory)/test2"
        performFileTests(directory: subdirectory)
        directory.delete()
    }

    private func performFileTests(directory: String) {
        /// basic example using one file        
        directory.createDirectory()
        let file = "\(directory)/file"
        file.createFile()
        file.writeContents("contents to be reverted")
        let dateOfWrite = Date()
        file.writeContents("contents to be ignored")
        try! FileReverter.revertDirectory(URL(fileURLWithPath: directory), toDate: dateOfWrite)
        XCTAssertEqual(file.contents, "contents to be reverted")
        directory.delete()

        /// test a date when file was created
        directory.createDirectory()
        file.createFile()
        let dateOfWrite2 = Date()
        file.writeContents("contents to be reverted")
        file.writeContents("contents to be ignored")
        try! FileReverter.revertDirectory(URL(fileURLWithPath: directory), toDate: dateOfWrite2)
        XCTAssertEqual(file.contents, "") /// replace to when file was initially created
        directory.delete()


        /// test a date that is too early
        directory.createDirectory()
        let dateOfWrite3 = Date()
        file.createFile()
        file.writeContents("contents to be reverted")
        file.writeContents("contents to be ignored")
        try! FileReverter.revertDirectory(URL(fileURLWithPath: directory), toDate: dateOfWrite3)
        XCTAssertEqual(file.contents, "contents to be ignored") ///  don't replace anything because it's too early
        directory.delete()

        /// test a date that is too early
        directory.createDirectory()

        file.createFile()
        file.writeContents("contents to be reverted")
        file.writeContents("contents to be ignored")
        let dateOfWrite4 = Date()
        try! FileReverter.revertDirectory(URL(fileURLWithPath: directory), toDate: dateOfWrite4)
        XCTAssertEqual(file.contents, "contents to be ignored") ///  don't replace anything because it's too early
        directory.delete()
    }
}
