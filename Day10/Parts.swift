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

    func solve() throws -> (station: Point, others: Set<Point>) {
        let asteroidsInLineOfSightByAsteroid: [Point: Set<Point>] = asteroids
            .reduce(into: [:], { result, asteroid in
                result[asteroid] = asteroidsInLineOfSight(of: asteroid)
            })

        guard let maximum = asteroidsInLineOfSightByAsteroid.max(by: { return $0.value.count < $1.value.count}) else {
            throw Error.couldNotFindMaximum
        }

        return (maximum.key, maximum.value)
    }

    private func asteroidsInLineOfSight(of asteroid: Point) -> Set<Point> {
        let others: Set<Point> = asteroids.subtracting([asteroid])
        let asteroidsByAngle: [Float: Set<Point>] = others
            .reduce(into: [:], { result, other in
                let angle = other.angle(to: asteroid)
                result[angle, default: []].insert(other)
            })

        let asteroidsInLineOfSign: Set<Point> = asteroidsByAngle.reduce(into: [], { result, element in
            let (_, asteroidsInSlope) = element
            
            guard let closest = asteroidsInSlope.min(by: { return $0.linearDistance(to: asteroid) < $1.linearDistance(to: asteroid) }) else {
                return
            }

            result.insert(closest)
        })

        return asteroidsInLineOfSign
    }

    enum Error: Swift.Error {
        case couldNotFindMaximum
    }
}

final class Part2: Part {
    let asteroids: Set<Point>
    let station: Point

    init(asteroids: Set<Point>, station: Point) {
        self.asteroids = asteroids
        self.station = station
    }

    func solve() -> Int {
        var asteroidsByAngle = self.asteroidsByAngle(around: station)
        

        return 0
    }

    private func asteroidsByAngle(around station: Point) -> [Float: Set<Point>] {
        let others: Set<Point> = asteroids.subtracting([station])

        return others.reduce(into: [:], { result, other in
            let angle = other.angle(to: station)
            result[angle, default: []].insert(other)
        })
    }
}
