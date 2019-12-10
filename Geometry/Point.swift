//
//  Point.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Point

public struct Point {
    public var x: Float
    public var y: Float

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }

    public func manhattanDistance(to other: Point) -> Float {
        return abs(other.x - self.x) + abs(other.y - self.y)
    }

    public func linearDistance(to other: Point) -> Float {
        return sqrt(pow(other.x - self.x, 2) + pow(other.y - self.y, 2))
    }

    public static var zero: Point {
        return Point(x: 0, y: 0)
    }
}

// MARK: Hashable

extension Point: Hashable {}

// MARK: Equatable

extension Point: Equatable {}

public extension Point {
    static func - (lhs: Point, rhs: Point) -> Point {
        let deltaX = lhs.x - rhs.x
        let deltaY = lhs.y - rhs.y
        return Point(x: deltaX, y: deltaY)
    }
}
