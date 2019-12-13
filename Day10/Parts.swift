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
    let asteroids: Set<Point2D>

    init(asteroids: Set<Point2D>) {
        self.asteroids = asteroids
    }

    func solve() -> (station: Point2D, others: Set<Point2D>) {
        let asteroidsInLineOfSightByAsteroid: [Point2D: Set<Point2D>] = asteroids
            .reduce(into: [:], { result, asteroid in
                result[asteroid] = asteroidsInLineOfSight(of: asteroid)
            })

        let asteroidsForStation = asteroidsInLineOfSightByAsteroid.max(by: { return $0.value.count < $1.value.count})!

        return (asteroidsForStation.key, asteroidsForStation.value)
    }

    private func asteroidsInLineOfSight(of asteroid: Point2D) -> Set<Point2D> {
        let others: Set<Point2D> = asteroids.subtracting([asteroid])
        let asteroidsByAngle: [Float: Set<Point2D>] = others
            .reduce(into: [:], { result, other in
                let angle = asteroid.angleRelativeToYAxis(to: other)
                
                result[angle, default: []].insert(other)
            })

        let asteroidsInLineOfSight: Set<Point2D> = asteroidsByAngle.reduce(into: [], { result, element in
            let (_, asteroidsInSlope) = element
            
            guard let closest = asteroidsInSlope.min(by: { $0.linearDistance(to: asteroid) < $1.linearDistance(to: asteroid) }) else {
                return
            }

            result.insert(closest)
        })

        return asteroidsInLineOfSight
    }
}

final class Part2: Part {
    let asteroids: Set<Point2D>
    let station: Point2D

    init(asteroids: Set<Point2D>, station: Point2D) {
        self.asteroids = asteroids
        self.station = station
    }

    func solve() -> Int {
        var asteroidsByAngle = self.asteroidsByAngle(around: station)
        var remainingToRemove = 200
        
        while remainingToRemove > asteroidsByAngle.count {
            let removedCount = asteroidsByAngle.count
            
            asteroidsByAngle = asteroidsByAngle.reduce(into: [:], { result, element in
                guard let closest = element.value.min(by: { $0.linearDistance(to: station) < $1.linearDistance(to: station) }) else {
                    return
                }
                
                result[element.key] = element.value.subtracting([closest])
            })
            
            remainingToRemove -= removedCount
        }
        
        let asteroidsBySortedAngle = asteroidsByAngle.sorted(by: { $0.key < $1.key })
        let twoHundredthDestroyed = asteroidsBySortedAngle[remainingToRemove - 1].value
            .min(by: { first, second in
                return first.linearDistance(to: station) < second.linearDistance(to: station)
            })!

        return Int(twoHundredthDestroyed.x) * 100 + Int(twoHundredthDestroyed.y)
    }

    private func asteroidsByAngle(around station: Point2D) -> [Float: Set<Point2D>] {
        let others: Set<Point2D> = asteroids.subtracting([station])

        let asteroidsByAngle: [Float: Set<Point2D>] = others
            .reduce(into: [:], { result, other in
                let angle = station.angleRelativeToYAxis(to: other)
                
                result[angle, default: []].insert(other)
            })
        
        return asteroidsByAngle
    }
}

extension Point2D {
    func angleRelativeToYAxis(to other: Point2D) -> Float {
        let deltaX = other.x - self.x
        let deltaY = other.y - self.y
        
        var angle = atan2(deltaX, -deltaY)
        if angle < 0 {
            angle += 2 * .pi
        }
        return angle
    }
}
