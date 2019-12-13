//
//  ComparableExtensions.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        var copy = self
        copy.clamp(to: range)
        return copy
    }

    mutating func clamp(to range: ClosedRange<Self>) {
        if self < range.lowerBound {
            self = range.lowerBound
        }

        if self > range.upperBound {
            self = range.upperBound
        }
    }
}
