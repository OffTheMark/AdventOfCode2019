//
//  Parts.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2019-12-10.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import Geometry

final class Part1: Part {
    let asteroids: Set<Point>

    init(asteroids: Set<Point>) {
        self.asteroids = asteroids
    }

    func solve() -> Int {
        let asteroidsInLineOfSightByAsteroid: [Point: Set<Point>] = asteroids
            .reduce(into: [:], { result, asteroid in
                result[asteroid] = asteroidsInLineOfSight(of: asteroid)
            })

        guard let maximum = asteroidsInLineOfSightByAsteroid.max(by: { return $0.value.count < $1.value.count}) else {
            return 0
        }

        return maximum.value.count
    }

    private func asteroidsInLineOfSight(of asteroid: Point) -> Set<Point> {
        let others: Set<Point> = asteroids.subtracting([asteroid])
        let asteroidsBySlope: [Point: Set<Point>] = others
            .reduce(into: [:], { result, otherAsteroid in
                let slope = otherAsteroid - asteroid
                result[slope, default: []].insert(otherAsteroid)
            })
        let asteroidsInLineOfSign: Set<Point> = asteroidsBySlope.reduce(into: [], { result, element in
            let (_, asteroidsInSlope) = element
            let closestOrNil = asteroidsInSlope.min(by: { first, second in
                return first.linearDistance(to: asteroid) < second.linearDistance(to: asteroid)
            })
            guard let closest = closestOrNil else {
                return
            }
            result.insert(closest)
        })
        return asteroidsInLineOfSign
    }
}
