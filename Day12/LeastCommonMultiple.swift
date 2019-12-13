//
//  LeastCommonDenominator.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

internal func greatestCommonDenominator(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    
    return b
}

internal func leastCommonMultiple(_ m: Int, _ n: Int) throws -> Int {
    guard (m & n) != 0 else {
        throw LCMError.divisionByZero
    }
    
    return m / greatestCommonDenominator(m, n) * n
}

enum LCMError: Error {
    case divisionByZero
}
