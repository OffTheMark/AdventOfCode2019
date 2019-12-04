//
//  Solver.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1Solver: Solver {
    let firstWire: Wire
    let secondWire: Wire

    init(firstWireMoves: [Move], secondWireMoves: [Move]) {
        self.firstWire = Wire(origin: .zero, moves: firstWireMoves)
        self.secondWire = Wire(origin: .zero, moves: secondWireMoves)
    }

    func solve() throws -> Int {
        let intersections = firstWire.points
            .intersection(secondWire.points)
            .subtracting([.zero])

        let distances = intersections.map({ $0.manhattanDistance(to: .zero) })

        guard let closestDistance = distances.sorted().first else {
            throw CouldNotFindClosestPointError()
        }

        return closestDistance
    }
}

struct CouldNotFindClosestPointError: Error {}
