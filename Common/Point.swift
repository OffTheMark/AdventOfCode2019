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
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func manhattanDistance(to other: Point) -> Int {
        return abs(other.x - self.x) + abs(other.y - self.y)
    }

    public static var zero: Point {
        return Point(x: 0, y: 0)
    }
}

// MARK: Hashable

extension Point: Hashable {}

// MARK: Equatable

extension Point: Equatable {}
