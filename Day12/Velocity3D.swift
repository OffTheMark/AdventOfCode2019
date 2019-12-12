//
//  Velocity3D.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

struct Velocity3D {
    var x: Float
    var y: Float
    var z: Float

    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    var kineticEnergy: Float {
        return [x, y, z].reduce(into: 0, { result, coordinate in
            result += abs(coordinate)
        })
    }

    static var zero: Self {
        return Velocity3D(x: 0, y: 0, z: 0)
    }
}

extension Velocity3D: Hashable {}

extension Velocity3D {
    static func += (lhs: inout Velocity3D, rhs: Velocity3D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    static func + (lhs: inout Velocity3D, rhs: Velocity3D) -> Velocity3D {
        return Velocity3D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y,
            z: lhs.z + rhs.z
        )
    }
}
