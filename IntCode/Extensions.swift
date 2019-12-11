//
//  Extensions.swift
//  IntCode
//
//  Created by Marc-Antoine Malépart on 2019-12-11.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Int

extension Int {
    func digit(at decimalPlace: Int) -> Int {
        let power = pow(10, decimalPlace).integer
        return (self / power) % 10
    }
}

// MARK: - Decimal

extension Decimal {
    var integer: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
