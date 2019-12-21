//
//  Parts.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2019-12-17.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import IntCode
import Geometry

// MARK: Part1

final class Part1: Part {
    let program: [Int]
    private(set) var scaffoldView = [Point2D: Character]()
    
    init(program: [Int]) throws {
        let computer = Computer(program: program, inputs: [])
        let result = try computer.run()
        
        self.program = program
        self.scaffoldView = self.scaffoldView(from: result.outputs)
    }
    
    func solve() throws -> Int {
        draw(scaffoldView)
        
        let directions: [Point2D] = [.up, .down, .left, .right]
        let intersections = scaffoldView.keys.filter({ position in
            guard let character = scaffoldView[position], character == "#" else {
                return false
            }
            
            let isSurroundedByScaffolding = directions.allSatisfy({ direction in
                return scaffoldView[position + direction] == "#"
            })
            
            return isSurroundedByScaffolding
        })
        let alignmentParameters: Int = intersections.reduce(into: 0, { result, position in
            let product = Int(position.x) * Int(position.y)
            result += product
        })
        
        return alignmentParameters
    }
    
    private func scaffoldView(from outputs: [Int]) -> [Point2D: Character] {
        var scaffoldView = [Point2D: Character]()
        
        var x = 0
        var y = 0
        
        for asciiCode in outputs {
            guard let scalar = UnicodeScalar(asciiCode) else {
                continue
            }
            
            let character = Character(scalar)
            if character.isNewline {
                x = 0
                y += 1
                continue
            }
            
            let position = Point2D(x: x, y: y)
            scaffoldView[position] = character
            x += 1
        }
        
        return scaffoldView
    }
    
    private func draw(_ scaffoldView: [Point2D: Character]) {
        let allXCoordinates = scaffoldView.keys.map({ Int($0.x) })
        let minX = allXCoordinates.min()!
        let maxX = allXCoordinates.max()!
        
        let allYCoordinates = scaffoldView.keys.map({ Int($0.y) })
        let minY = allYCoordinates.min()!
        let maxY = allYCoordinates.max()!
        
        var drawnView = ""
        for y in minY ... maxY {
            for x in minX ... maxX {
                let position = Point2D(x: x, y: y)
                let character = scaffoldView[position, default: "."]
                
                drawnView.append(character)
            }
            drawnView.append("\n")
        }
        
        print(drawnView)
    }
}

// MARK: - Part2

final class Part2: Part {
    let program: Program
    let scaffoldView: [Point2D: Character]
    
    init(program: Program, scaffoldView: [Point2D: Character]) {
        self.program = program
        self.scaffoldView = scaffoldView
    }
    
    func solve() throws -> Int {
        let path = pathInScaffold(for: scaffoldView)
        
        print(path)
        
        var inputs = inputsForRobot()
        
        var forcedWakeupProgram = program
        forcedWakeupProgram[0] = 2
        let computer = Computer(program: forcedWakeupProgram, inputs: [])
        
        while true {
            let result = try computer.run()
            
            switch result.endState {
            case .waitingForInput:
                let nextInputs = inputs.removeFirst()
                computer.addInputs(nextInputs)
                
            case .halted:
                return result.outputs.last!
            }
        }
    }
    
    private func pathInScaffold(for scaffoldView: [Point2D: Character]) -> String {
        let robot = scaffoldView.first(where: { element in
            let orientation = Orientation(rawValue: element.value)
            return orientation != nil
        })!
        var unvisited: Set<Point2D> = scaffoldView.reduce(into: [], { result, element in
            let (position, character) = element
            if character == "#" {
                result.insert(position)
            }
        })
        
        var path = [String]()
        var position = robot.key
        var orientation = Orientation(rawValue: robot.value)!
        var steps = 0
        
        while !unvisited.isEmpty {
            if scaffoldView[position + orientation.point] == "#" {
                steps += 1
                
                position += orientation.point
                unvisited.remove(position)
                continue
            }
            
            for direction in Direction.allCases {
                let potentialOrientation = orientation.rotated(to: direction)
                
                if scaffoldView[position + potentialOrientation.point] == "#" {
                    if steps > 0 {
                        path.append(String(steps))
                    }
                    
                    path.append(String(direction.rawValue))
                    orientation = potentialOrientation
                    steps = 0
                }
            }
        }
        
        if steps > 0 {
            path.append(String(steps))
        }
        
        return path.joined(separator: ",")
    }
    
    private func inputsForRobot() -> [[Int]] {
        let mainRoutine = "A,B,B,C,C,A,B,B,C,A"
        let functions = [
            "R,4,R,12,R,10,L,12",
            "L,12,R,4,R,12",
            "L,12,L,8,R,10"
        ]
        let continuousVideoFeed = "n"
        let strings = [mainRoutine] + functions + [continuousVideoFeed]
        let inputs: [[Int]] = strings
            .map({ string in
                let inputs = string.compactMap({ character in
                    return character.asciiValue.map({ Int($0) })
                })
                return inputs + [10]
            })
        
        return inputs
    }
}
