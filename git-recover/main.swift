//
//  main.swift
//  GitRecover
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import Foundation

let arguments = CommandLine.arguments
do {
    let date = try ArgumentParser.date(fromArguments: arguments)
    let directory = try ArgumentParser.directory(fromArguments: arguments)
    print("Reading files...")
    try FileReverter.revertDirectory(directory, toDate: date)
    print("Done 🎉")
} catch let error {
    print("\(error)\n\(ArgumentParser.usageInstructions)")
}

