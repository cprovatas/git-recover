//
//  URL+TestHelper.swift
//  GitRecoverTests
//
//  Created by Charlton Provatas on 28/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import Foundation

/// succint helpers just for tests to make reading and writing a little cleaner to test
/// these helpers perform no validation and assume that the paths are valid and writable
extension String {
    /// simulate a normal save from a text editor
    func writeContents(_ string: String) {
        let url = URL(fileURLWithPath: self)
        try! string.write(to: url, atomically: true, encoding: .utf8)
        try! NSFileVersion.addOfItem(at: url, withContentsOf: url, options: [])
    }

    func createDirectory() {
        try! FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: false, attributes: nil)
    }    

    var contents: String {
        return try! String(contentsOfFile: self, encoding: .utf8)
    }

    func createFile() {
        let url = URL(fileURLWithPath: self)
        FileManager.default.createFile(atPath: self, contents: nil, attributes: nil)
        try! NSFileVersion.addOfItem(at: url, withContentsOf: url, options: [])
    }

    var modificationDate: Date {
        let attributes = try! FileManager.default.attributesOfItem(atPath: self)
        return attributes[.modificationDate] as! Date
    }

    func delete() {
        try! FileManager.default.removeItem(atPath: self)
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(fileURLWithPath: value)
    }
}
