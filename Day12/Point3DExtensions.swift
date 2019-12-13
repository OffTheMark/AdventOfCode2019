//
//  Point3DExtensions.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

// MARK: Initializer

extension Point3D {
    init?(string: String) {
        let effective = string.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        let parts = effective
            .components(separatedBy: ", ")
            .compactMap({ component in
                return component.components(separatedBy: "=").last
            })
        guard parts.count == 3 else {
            return nil
        }

        guard let x = Float(parts[0]) else {
            return nil
        }
        guard let y = Float(parts[1]) else {
            return nil
        }
        guard let z = Float(parts[2]) else {
            return nil
        }

        self.init(x: x, y: y, z: z)
    }

    var potentialEnergy: Float {
        return [x, y, z].reduce(into: 0, { result, coordinate in
            result += abs(coordinate)
        })
    }
}

// MARK: Apply Velocity

extension Point3D {
    static func += (lhs: inout Point3D, rhs: Velocity3D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    static func + (lhs: Point3D, rhs: Velocity3D) -> Point3D {
        return Point3D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y,
            z: lhs.z + rhs.z
        )
    }
}
