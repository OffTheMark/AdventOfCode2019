//
//  Solver.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import Geometry

// MARK: Part1

final class Part1: Part {
    let firstWire: Wire
    let secondWire: Wire

    init(firstWireMoves: [Move], secondWireMoves: [Move]) {
        self.firstWire = Wire(origin: .zero, moves: firstWireMoves)
        self.secondWire = Wire(origin: .zero, moves: secondWireMoves)
    }

    func solve() throws -> Float {
        var segmentPairs = [(first: Line, second: Line)]()
        for firstSegment in firstWire.segments {
            for secondSegment in secondWire.segments {
                segmentPairs.append((firstSegment, secondSegment))
            }
        }

        let points = segmentPairs
            .compactMap({ first, second in
                return first.intersection(with: second)
            })
        let intersections = Set(points)
            .subtracting([.zero])
        
        if intersections.isEmpty {
            throw CouldNotFindClosestPointError()
        }

        let sortedDistances: [(point: Point, distance: Float)] = intersections
            .map({ point in
                let distance = point.manhattanDistance(to: .zero)
                return (point, distance)
            })
            .sorted(by: {
                return $0.distance < $1.distance
            })

        return sortedDistances.first!.distance
    }
}

// MARK: - Part2

final class Part2: Part {
    let firstWire: Wire
    let secondWire: Wire
    
    init(firstWireMoves: [Move], secondWireMoves: [Move]) {
        self.firstWire = Wire(origin: .zero, moves: firstWireMoves)
        self.secondWire = Wire(origin: .zero, moves: secondWireMoves)
    }

    func solve() throws -> Float {
        var segmentPairs = [(first: Line, second: Line)]()
        for firstSegment in firstWire.segments {
            for secondSegment in secondWire.segments {
                segmentPairs.append((firstSegment, secondSegment))
            }
        }

        let intersectionsWithSegments: [(intersection: Point, first: Line, second: Line)] = segmentPairs
            .compactMap({ first, second in
                guard let intersection = first.intersection(with: second), intersection != .zero else {
                    return nil
                }

                return (intersection, first, second)
            })
        
        if intersectionsWithSegments.isEmpty {
            throw CouldNotFindClosestPointError()
        }

        let intersectionsWithSteps: [(intersection: Point, steps: Float)] = intersectionsWithSegments
            .compactMap({ point, first, second in
                guard let firstSteps = firstWire.steps(to: point) else {
                    return nil
                }

                guard let secondSteps = secondWire.steps(to: point) else {
                    return nil
                }

                return (point, firstSteps + secondSteps)
            })
            .sorted(by: { first, second in
                return first.steps < second.steps
            })

        return intersectionsWithSteps.first!.steps
    }
}

struct CouldNotFindClosestPointError: Error {}
