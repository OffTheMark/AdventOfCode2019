//
//  Coordinate.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2019-12-11.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: - Coordinate

struct Coordinate {
    var x: Int
    var y: Int

    static var zero: Coordinate {
        return .init(x: 0, y: 0)
    }
}

// MARK: Hashable

extension Coordinate: Hashable {}

// MARK: Addition

extension Coordinate {
    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func += (lhs: inout Coordinate, rhs: Coordinate) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

// MARK: - Direction

enum Direction {
    case up
    case down
    case left
    case right

    var coordinate: Coordinate {
        switch self {
        case .up:
            return Coordinate(x: 0, y: -1)

        case .down:
            return Coordinate(x: 0, y: 1)

        case .left:
            return Coordinate(x: -1, y: 0)

        case .right:
            return Coordinate(x: 1, y: 0)
        }
    }

    mutating func makeTurn(_ turn: Turn) {
        switch turn {
        case .left:
            turnLeft()

        case .right:
            turnRight()
        }
    }

    private mutating func turnLeft() {
        switch self {
        case .up:
            self = .left

        case .left:
            self = .down

        case .down:
            self = .right

        case .right:
            self = .up
        }
    }

    private mutating func turnRight() {
        switch self {
        case .up:
            self = .right

        case .right:
            self = .down

        case .down:
            self = .left

        case .left:
            self = .up
        }
    }
}

// MARK: - Turn

enum Turn: Int {
    case left = 0
    case right = 1
}

//MARK: - Color

enum Color: Int {
    case black = 0
    case white = 1

    var emoji: Character {
        switch self {
        case .black:
            return "⬛️"

        case .white:
            return "◻️"
        }
    }
}
