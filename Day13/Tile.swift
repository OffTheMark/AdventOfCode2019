//
//  Tile.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2019-12-13.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

enum Tile: Int {
    case empty = 0
    case wall = 1
    case block = 2
    case horizontalPaddle = 3
    case ball = 4

    var isObstacle: Bool {
        switch self {
        case .block, .wall, .horizontalPaddle:
            return true

        case .empty, .ball:
            return false
        }
    }

    var canBeDestroyed: Bool {
        switch self {
        case .empty, .block:
            return true

        case .wall, .horizontalPaddle, .ball:
            return false
        }
    }
    
    var character: Character {
        switch self {
        case .empty:
            return " "
            
        case .wall:
            return "#"
            
        case .block:
            return "X"
            
        case .horizontalPaddle:
            return "-"
            
        case .ball:
            return "o"
        }
    }
}
