//
//  Point3D.swift
//  Geometry
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public struct Point3D {
    public var x: Float
    public var y: Float
    public var z: Float

    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    public func linearDistance(to other: Self) -> Float {
        let sumOfSquares = pow(other.x - self.x, 2) + pow(other.y - self.y, 2) + pow(other.z - self.z, 2)
        return sqrt(sumOfSquares)
    }

    public static var zero: Self {
        return Point3D(x: 0, y: 0, z: 0)
    }
}

// MARK: Hashable

extension Point3D: Hashable {}
