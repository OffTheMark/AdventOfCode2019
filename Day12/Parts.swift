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
        var moons: [Moon] = positionOfMoons.map({ position in
            return Moon(position: position, velocity: .zero)
        })
        let combinationsOfMoons = Array(moons.indices).combinations(ofSize: 2)

        for _ in 0..<numberOfSteps {
            for combination in combinationsOfMoons {
                let firstIndex = combination[0]
                let secondIndex = combination[1]
                let first = moons[firstIndex]
                let second = moons[secondIndex]

                if first.position.x > second.position.x {
                    moons[firstIndex].velocity.x -= 1
                    moons[secondIndex].velocity.x += 1
                }
                if first.position.x < second.position.x {
                    moons[firstIndex].velocity.x += 1
                    moons[secondIndex].velocity.x -= 1
                }
                if first.position.y > second.position.y {
                    moons[firstIndex].velocity.y -= 1
                    moons[secondIndex].velocity.y += 1
                }
                if first.position.y < second.position.y {
                    moons[firstIndex].velocity.y += 1
                    moons[secondIndex].velocity.y -= 1
                }
                if first.position.z > second.position.z {
                    moons[firstIndex].velocity.z -= 1
                    moons[secondIndex].velocity.z += 1
                }
                if first.position.z < second.position.z {
                    moons[firstIndex].velocity.z += 1
                    moons[secondIndex].velocity.z -= 1
                }
            }

            for index in moons.indices {
                moons[index].position += moons[index].velocity
            }
        }

        let totalEnergy = moons.reduce(into: 0, { result, moon in
            result += moon.energy
        })

        return Int(totalEnergy)
    }
}
