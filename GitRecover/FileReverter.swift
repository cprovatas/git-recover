//
//  FileReverter.swift
//  GitRecover
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import Foundation


final class FileReverter {

    private static let _fm: FileManager = .default

    static func revertDirectory(_ directory: URL, toDate date: Date) throws {

        guard let enumerator = _fm.enumerator(at: directory, includingPropertiesForKeys: nil) else {
            throw "Unable to create enumerator at directory '\(directory)' Please try another directory"
        }
        while let fileURL = enumerator.nextObject() as? URL {
            try _revertFileAtURL(fileURL, toDate: date)
        }
    }

    private static func _revertFileAtURL(_ url: URL, toDate date: Date) throws {
        guard let version = NSFileVersion.currentVersionOfItem(at: url),
              let modificationDate = version.modificationDate,
              modificationDate > date, /// no need to revert if the last modification occurred before the revert date
              let otherVersions = NSFileVersion.otherVersionsOfItem(at: url),
              let validVersion = _latestAppropriateVersion(forVersions: otherVersions, toDate: date) else { return }

        try validVersion.replaceItem(at: url, options: [])
        print("Reverted file: \(url.lastPathComponent) to version at date: \(ArgumentParser.formatter.string(from: date))")
    }

    /// gets the latest version of a given file that was modified before at or at the given revert date
    private static func _latestAppropriateVersion(forVersions versions: [NSFileVersion], toDate date: Date) -> NSFileVersion? {
        return versions.filter { $0.modificationDate != nil }
                       .sorted { $0.modificationDate! > $1.modificationDate! }
                       .first(where: { $0.modificationDate! <= date })
    }

    private init() {
        fatalError("Static class shouldn't be initialized")
    }
}
