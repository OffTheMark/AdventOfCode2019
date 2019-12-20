//
//  Parts.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2019-12-13.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import Geometry
import IntCode

typealias Point2D = SIMD2<Int>

// MARK: Part1

final class Part1: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> Int {
        let computer = Computer(program: program, inputs: [])
        let result = try computer.run()
        var tilesByPosition = [Point2D: Tile]()

        for startIndex in stride(from: 0, to: result.outputs.count - 2, by: 3) {
            let x = result.outputs[startIndex]
            let y =  result.outputs[startIndex + 1]
            let tile = Tile(rawValue: result.outputs[startIndex + 2])!

            let point = Point2D(x: x, y: y)
            tilesByPosition[point] = tile
        }

        return tilesByPosition.count(where: { $0.value == .block })
    }
}

final class Part2: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> Int {
        var program = self.program
        program[0] = 2
        
        let player = try Player(program: program)
        return try player.beatGame()
    }
}

final class Player {
    let computer: Computer
    var currentScore = 0
    var currentBoard: [Point2D: Tile]
    
    init(program: [Int]) throws {
        let computer = Computer(program: program, inputs: [])
        let result = try computer.run()
        var tilesByPosition = [Point2D: Tile]()

        for startIndex in stride(from: 0, to: result.outputs.count - 2, by: 3) {
            let x = result.outputs[startIndex]
            let y =  result.outputs[startIndex + 1]
            let tile = Tile(rawValue: result.outputs[startIndex + 2])!

            let point = Point2D(x: x, y: y)
            tilesByPosition[point] = tile
        }
        
        self.computer = computer
        self.currentBoard = tilesByPosition
    }
    
    func beatGame() throws -> Int {
        while true {
            if currentBoard.values.allSatisfy({ $0 != .block }) {
                break
            }
            let direction = self.directionToPointJoystick
            computer.addInput(direction)
            
            try update()
            draw(currentBoard)
            print(currentScore)
        }
        
        return currentScore
    }
    
    private var directionToPointJoystick: Int {
        let positionOfBall = currentBoard.first(where: { $0.value == .ball })!.key
        let positionOfPaddle = currentBoard.first(where: { $0.value == .horizontalPaddle })!.key
        
        if positionOfPaddle.x < positionOfBall.x {
            return 1
        }
        if positionOfPaddle.x > positionOfBall.x {
            return -1
        }
        return 0
    }
    
    private func update() throws {
        while let x = try computer.nextOutput() {
            let y = try computer.nextOutput()!
            let point = Point2D(x: x, y: y)
            let value = try computer.nextOutput()!
            
            if point == Point2D(x: -1, y: 0) {
                currentScore = value
            }
            else {
                currentBoard[point] = Tile(rawValue: value)
            }
        }
    }
    
    private func draw(_ tilesByPosition: [Point2D: Tile]) {
        let allXCoordinates = tilesByPosition.keys.map({ Int($0.x) })
        let minX = allXCoordinates.min()!
        let maxX = allXCoordinates.max()!
        
        let allYCoordinates = tilesByPosition.keys.map({ Int($0.y) })
        let minY = allYCoordinates.min()!
        let maxY = allYCoordinates.max()!
        
        for y in minY ... maxY {
            var line = ""
            for x in minX ... maxX {
                let point = Point2D(x: x, y: y)
                let tile = tilesByPosition[point, default: .empty]
                line.append(tile.character)
            }
            print(line)
        }
        print()
    }
}
