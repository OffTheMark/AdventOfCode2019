//
//  Move2D.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2019-12-15.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

struct Move2D {
    var x: Float
    var y: Float
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    static var up: Self {
        return .init(x: 0, y: -1)
    }
    
    static var down: Self {
        return .init(x: 0, y: 1)
    }
    
    static var left: Self {
        return .init(x: -1, y: 0)
    }
    
    static var right: Self {
        return .init(x: 1, y: 0)
    }
}

// MARK: Hashable

extension Move2D: Hashable {}

// MARK: Operations

extension Point2D {
    static func + (lhs: Point2D, rhs: Move2D) -> Point2D {
        return Point2D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    static func += (lhs: inout Point2D, rhs: Move2D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func - (lhs: Point2D, rhs: Move2D) -> Point2D {
        return Point2D(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
    
    static func -= (lhs: inout Point2D, rhs: Move2D) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}
