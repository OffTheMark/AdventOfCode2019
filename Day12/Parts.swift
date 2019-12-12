//
//  Parts.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import Geometry

final class Part1: Part {
    let positionOfMoons: [Point3D]
    let numberOfSteps: Int

    init(positionOfMoons: [Point3D], numberOfSteps: Int) {
        self.positionOfMoons = positionOfMoons
        self.numberOfSteps = numberOfSteps
    }

    func solve() -> Int {
        let moons: [Moon] = positionOfMoons.map({ position in
            return Moon(position: position, velocity: .zero)
        })
        let permutationsOfMoons = Array(moons.indices).permutationsWithoutRepetition(ofSize: 2)

        for _ in 0..<numberOfSteps {
            var deltaVelocities: [Velocity3D] = .init(repeating: .zero, count: moons.count)

            for permutation in permutationsOfMoons {
                let firstIndex = permutation[0]
                let secondIndex = permutation[1]
                let first = moons[firstIndex]
                let second = moons[secondIndex]

                if first.position.x > second.position.x {
                    deltaVelocities[firstIndex].x += 1
                    deltaVelocities[secondIndex].x -= 1
                }
                if first.position.x < second.position.x {
                    deltaVelocities[firstIndex].x -= 1
                    deltaVelocities[secondIndex].x += 1
                }
                if first.position.y > second.position.y {
                    deltaVelocities[firstIndex].y += 1
                    deltaVelocities[secondIndex].y -= 1
                }
                if first.position.y < second.position.y {
                    deltaVelocities[firstIndex].y -= 1
                    deltaVelocities[secondIndex].y += 1
                }
                if first.position.z > second.position.z {
                    deltaVelocities[firstIndex].z += 1
                    deltaVelocities[secondIndex].z -= 1
                }
                if first.position.z < second.position.z {
                    deltaVelocities[firstIndex].z -= 1
                    deltaVelocities[secondIndex].z += 1
                }
            }

            for index in moons.indices {
                let moon = moons[index]
                let deltaVelocity = deltaVelocities[index]

                moon.position += deltaVelocity
            }
        }

        let totalEnergy = moons.reduce(into: 0, { result, moon in
            result += moon.energy
        })

        return Int(totalEnergy)
    }
}
