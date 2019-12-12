//
//  Moon.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

final class Moon: NSObject {
    var position: Point3D
    var velocity: Velocity3D

    init(position: Point3D, velocity: Velocity3D) {
        self.position = position
        self.velocity = velocity
    }

    var energy: Float {
        return position.potentialEnergy * velocity.kineticEnergy
    }
}
