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


final class Part2: Part {
    let positionOfMoons: [Point3D]
    
    init(positionOfMoons: [Point3D]) {
        self.positionOfMoons = positionOfMoons
    }
    
    func solve() throws -> Int {
        var moons: [Moon] = positionOfMoons.map({ position in
            return Moon(position: position, velocity: .zero)
        })
        let combinationsOfMoons = Array(moons.indices).combinations(ofSize: 2)
        var stepsRequiredToLoopByAxis = [Int: Int]()
        var index = 0
        
        while true {
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
            
            index += 1
            
            if stepsRequiredToLoopByAxis[0] == nil, moons.allSatisfy({ $0.velocity.x == 0 }) {
                stepsRequiredToLoopByAxis[0] = index
            }
            if stepsRequiredToLoopByAxis[1] == nil, moons.allSatisfy({ $0.velocity.y == 0 }) {
                stepsRequiredToLoopByAxis[1] = index
            }
            if stepsRequiredToLoopByAxis[2] == nil, moons.allSatisfy({ $0.velocity.z == 0 }) {
                stepsRequiredToLoopByAxis[2] = index
            }
            if stepsRequiredToLoopByAxis.count == 3 {
                break
            }
        }
        
        let stepsForX = stepsRequiredToLoopByAxis[0]!
        let stepsForY = stepsRequiredToLoopByAxis[1]!
        let stepsForZ = stepsRequiredToLoopByAxis[2]!
        
        // C'est de la mathémagie!
        return try leastCommonMultiple(stepsForX, leastCommonMultiple(stepsForY, stepsForZ)) * 2
    }
}
