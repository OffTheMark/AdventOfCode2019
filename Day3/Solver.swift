//
//  Solver.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part1Solver

final class Part1Solver: Solver {
    let firstWire: Wire
    let secondWire: Wire

    init(firstWireMoves: [Move], secondWireMoves: [Move]) {
        self.firstWire = Wire(origin: .zero, moves: firstWireMoves)
        self.secondWire = Wire(origin: .zero, moves: secondWireMoves)
    }

    func solve() throws -> Float {
        let intersections = Set(firstWire.points)
            .intersection(secondWire.points)
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

// MARK: - Part2Solver

final class Part2Solver: Solver {
    let firstWire: Wire
    let secondWire: Wire
    
    init(firstWireMoves: [Move], secondWireMoves: [Move]) {
        self.firstWire = Wire(origin: .zero, moves: firstWireMoves)
        self.secondWire = Wire(origin: .zero, moves: secondWireMoves)
    }

    func solve() throws -> Float {
        let pointsInFirstWire = firstWire.points
        let pointsInSecondWire = secondWire.points
        
        let intersections = Set(pointsInFirstWire)
            .intersection(pointsInSecondWire)
            .subtracting([.zero])
        
        if intersections.isEmpty {
            throw CouldNotFindClosestPointError()
        }
        
        let sortedSteps: [(point: Point, steps: Float)] = intersections
            .map({ point in
                let stepsInFirstWire = pointsInFirstWire.firstIndex(of: point)!
                let stepsInSecondWire = pointsInSecondWire.firstIndex(of: point)!
                let combinedSteps = stepsInFirstWire + stepsInSecondWire
                
                return (point, Float(combinedSteps))
            })
            .sorted(by: {
                return $0.steps < $1.steps
            })

        return sortedSteps.first!.steps
    }
}

struct CouldNotFindClosestPointError: Error {}
