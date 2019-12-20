//
//  Parts.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2019-12-19.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry
import IntCode
import Common

// MARK: Part1

final class Part1: Part {
    let program: Program
    private(set) var statesByPosition = [Point2D: DroneState]()
    
    init(program: Program) {
        self.program = program
    }
    
    func solve() throws -> Int {
        let coordinateRange = 0 ..< 50
        
        statesByPosition = try coordinateRange.reduce(into: [:], { result, y in
            for x in coordinateRange {
                let computer = Computer(program: program, inputs: [x, y])
                let position = Point2D(x: x, y: y)
                let computerResult = try computer.run()
                
                guard computerResult.outputs.count == 1, let state = DroneState(rawValue: computerResult.outputs[0]) else {
                    continue
                }
                
                result[position] = state
            }
        })

        draw(statesByPosition)
        
        let countOfPulled = statesByPosition
            .filter({ element in
                return element.value == .pulled
            })
            .count
        
        return countOfPulled
    }
    
    private func draw(_ statesByPosition: [Point2D: DroneState]) {
        let allXCoordinates = statesByPosition.keys.map({ Int($0.x) })
        let minX = allXCoordinates.min()!
        let maxX = allXCoordinates.max()!
        
        let allYCoordinates = statesByPosition.keys.map({ Int($0.y) })
        let minY = allYCoordinates.min()!
        let maxY = allYCoordinates.max()!
        
        var drawnMaze = ""
        for y in minY ... maxY {
            for x in minX ... maxX {
                let position = Point2D(x: x, y: y)
                let status = statesByPosition[position, default: .stationary]
                
                drawnMaze.append(status.character)
            }
            drawnMaze.append("\n")
        }
        
        print(drawnMaze)
    }
}

final class Part2: Part {
    let program: Program
    let apex: Point2D
    
    init(program: Program, statesByPosition: [Point2D: DroneState]) {
        let apex: Point2D = statesByPosition
            .filter({ $0.value == .pulled })
            .keys
            .sorted(by: { $0.x < $1.x })[1]
        
        
        self.program = program
        self.apex = apex
    }
    
    func solve() throws -> Int {
        var bottomLeft = apex
        
        while true {
            if bottomLeft.y >= 99 {
                let topRight = bottomLeft.translated(byX: 99, y: -99)
                let stateForBottomLeft = try state(for: bottomLeft)
                let stateForTopRight = try state(for: topRight)
                
                if stateForBottomLeft == .pulled, stateForTopRight == .pulled {
                    break
                }
            }
            
            let underneathBottomLeft = bottomLeft.translated(byX: 0, y: 1)
            let stateOfBottom = try state(for: underneathBottomLeft)
            
            if stateOfBottom == .pulled {
                bottomLeft.y += 1
            }
            else {
                bottomLeft.x += 1
            }
        }
        
        let topLeft = bottomLeft.translated(byX: 0, y: -99)
        
        return Int(topLeft.x * 10_000 + topLeft.y)
    }
    
    private func state(for position: Point2D) throws -> DroneState {
        let inputs = [position.x, position.y].map({ Int($0) })
        let computer = Computer(program: program, inputs: inputs)
        let result = try computer.run()
        
        return DroneState(rawValue: result.outputs[0])!
    }
}

// MARK: - DroneState

enum DroneState: Int {
    case stationary = 0
    case pulled = 1
    
    var character: Character {
        switch self {
        case .stationary:
            return "⬛️"
            
        case .pulled:
            return "◻️"
        }
    }
}
