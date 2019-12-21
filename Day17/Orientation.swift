//
//  Orientation.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2019-12-20.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

enum Orientation: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
    
    var point: Point2D {
        switch self {
        case .up:
            return .up
            
        case .down:
            return .down
            
        case .left:
            return .left
            
        case .right:
            return .right
        }
    }
    
    func rotated(to turn: Direction) -> Orientation {
        switch (self, turn) {
        case (.up, .right):
            return .right
            
        case (.right, .right):
            return .down
            
        case (.down, .right):
            return .left
            
        case (.left, .right):
            return .up
            
        case (.up, .left):
            return .left
            
        case (.left, .left):
            return .down
            
        case (.down, .left):
            return .right
            
        case (.right, .left):
            return .up
        }
    }
}

enum Direction: Character, CaseIterable {
    case left = "L"
    case right = "R"
}
