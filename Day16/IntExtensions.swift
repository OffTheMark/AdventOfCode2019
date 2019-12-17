//
//  IntExtensions.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2019-12-16.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: - Decimal

extension Decimal {
    var integer: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
