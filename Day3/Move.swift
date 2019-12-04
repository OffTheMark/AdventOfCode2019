//
//  MoveExtensions.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Point

extension Point {
    func applying(_ move: Move) -> Point {
        var copy = self
        copy.apply(move)
        return copy
    }

    mutating func apply(_ move: Move) {
        move.apply(to: &self)
    }
}

// MARK: - Move

struct Move {
    let direction: Direction
    let distance: Float

    init(direction: Direction, distance: Float) {
        self.direction = direction
        self.distance = distance
    }

    init?(rawValue: String) {
        guard let firstCharacter = rawValue.first, let direction = Direction(rawValue: firstCharacter) else {
            return nil
        }

        guard let distance = Float(rawValue.dropFirst()) else {
            return nil
        }

        self.init(direction: direction, distance: distance)
    }

    func apply(to point: inout Point) {
        switch direction {
        case .up:
            point.y -= distance

        case .down:
            point.y += distance

        case .left:
            point.x -= distance

        case .right:
            point.x += distance
        }
    }

    enum Direction: Character {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }
}
