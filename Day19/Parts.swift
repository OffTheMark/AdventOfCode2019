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
    
    init(program: Program) {
        self.program = program
    }
    
    func solve() throws -> Int {
        let coordinateRange = 0 ..< 50
        
        let statesByPosition: [Point2D: DroneState] = try coordinateRange.reduce(into: [:], { result, y in
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
