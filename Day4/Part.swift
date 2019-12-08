//
//  Solver.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2019-12-04.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part1

final class Part1: Part {
    let validRange: ClosedRange<Int>

    init(validRange: ClosedRange<Int>) {
        self.validRange = validRange
    }

    func solve() -> Int {
        return validRange.reduce(into: 0, { result, element in
            if Password(rawValue: String(element)) != nil {
                result += 1
            }
        })
    }
}

// MARK: - Part2

final class Part2: Part {
    let validRange: ClosedRange<Int>

    init(validRange: ClosedRange<Int>) {
        self.validRange = validRange
    }

    func solve() -> Int {
        return validRange.reduce(into: 0, { result, element in
            if StricterPassword(rawValue: String(element)) != nil {
                result += 1
            }
        })
    }
}
