//
//  Status.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2019-12-15.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Status

enum Status: Int {
    case wall = 0
    case empty = 1
    case oxygenSystem = 2
    
    var character: Character {
        switch self {
        case .wall:
            return "▫️"
            
        case .empty:
            return "◼️"
            
        case .oxygenSystem:
            return "⭐️"
        }
    }
}

enum OxygenStatus {
    case wall
    case empty
    case oxygen
    
    var character: Character {
        switch self {
        case .wall:
            return "◻️"
            
        case .empty:
            return "⬛️"
            
        case .oxygen:
            return "🔵"
        }
    }
}

// MARK: - MovementCommand

enum MovementCommand: Int {
    case north = 1
    case south = 2
    case west = 3
    case east = 4
    
    var move: Move2D {
        switch self {
        case .north:
            return .up
            
        case .south:
            return .down
            
        case .west:
            return .left
            
        case .east:
            return .right
        }
    }
}

// MARK: CaseIterable

extension MovementCommand: CaseIterable {}
