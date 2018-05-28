//
//  Array+Utilities.swift
//  GitRecover
//
//  Created by Charlton Provatas on 27/5/18.
//  Copyright © 2018 CharltonProvatas. All rights reserved.
//

import Foundation

extension Array {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    /// O(1)
    subscript (safe index: Index) -> Element? {
        get {
            guard index > -1, index < count else { return nil }
            return self[index]
        } set {
            guard let newValue = newValue, index > -1, index < count else { return }
            self[index] = newValue
        }
    }
}
