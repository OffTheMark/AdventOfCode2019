//
//  Point2D.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Point2D

public struct Point2D {
    public var x: Float
    public var y: Float

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public init(x: Int, y: Int) {
        self.x = Float(x)
        self.y = Float(y)
    }

    public func manhattanDistance(to other: Self) -> Float {
        return abs(other.x - self.x) + abs(other.y - self.y)
    }

    public func linearDistance(to other: Self) -> Float {
        return sqrt(pow(other.x - self.x, 2) + pow(other.y - self.y, 2))
    }

    public static var zero: Self {
        return Point2D(x: 0, y: 0)
    }
    
    public func translated(byX x: Float, y: Float) -> Point2D {
        var translated = self
        translated.x += x
        translated.y += y
        return translated
    }
    
    public func translated(byX x: Int, y: Int) -> Point2D {
        return translated(byX: Float(x), y: Float(y))
    }
}

// MARK: Hashable

extension Point2D: Hashable {}

// MARK: Equatable

extension Point2D: Equatable {}

// MARK: Operations

public extension Point2D {
    static func + (lhs: Point2D, rhs: Point2D) -> Point2D {
        return Point2D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    static func += (lhs: inout Point2D, rhs: Point2D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
