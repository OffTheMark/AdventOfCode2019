//
//  Parts.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2019-12-11.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import IntCode

final class Part1: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> Int {
        var colorByPosition: [Coordinate: Color] = [:]
        var position: Coordinate = .zero
        var direction: Direction = .up
        
        let computer = Computer(program: program, inputs: [Color.black.rawValue])

        while true {
            let result = try computer.run()
            
            if result.endState == .halted {
                break
            }
            
            let outputs = result.outputs
            let colorToPaint = Color(rawValue: outputs[0])!
            let turn = Turn(rawValue: outputs[1])!
            
            colorByPosition[position] = colorToPaint
            direction.makeTurn(turn)
            position += direction.coordinate
            
            let currentColor = colorByPosition[position, default: .black]
            computer.addInput(currentColor.rawValue)
            
        }

        return colorByPosition.count
    }
}


// MARK: - Part2

final class Part2: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> String {
        var position: Coordinate = .zero
        var colorByPosition: [Coordinate: Color] = [:]
        var direction: Direction = .up
        
        let computer = Computer(program: program, inputs: [Color.white.rawValue])

        while true {
            let result = try computer.run()
            
            if result.endState == .halted {
                break
            }
            
            let outputs = result.outputs
            let colorToPaint = Color(rawValue: outputs[0])!
            let turn = Turn(rawValue: outputs[1])!
            
            colorByPosition[position] = colorToPaint
            direction.makeTurn(turn)
            position += direction.coordinate
            
            let currentColor = colorByPosition[position, default: .black]
            computer.addInput(currentColor.rawValue)
        }
        
        return plate(from: colorByPosition)
    }
    
    private func plate(from colorsByPosition: [Coordinate: Color]) -> String {
        let allXs = colorsByPosition.keys.map({ $0.x })
        let minX = allXs.min()!
        let maxX = allXs.max()!
        
        let allYs = colorsByPosition.keys.map({ $0.y })
        let minY = allYs.min()!
        let maxY = allYs.max()!
        
        var lines: [String] = []
        for y in minY ... maxY {
            var line = ""
    
            for x in minX ... maxX {
                let coordinate = Coordinate(x: x, y: y)
                let color = colorsByPosition[coordinate, default: .black]
                line.append(color.emoji)
            }
            
            lines.append(line)
        }
        
        return lines.joined(separator: "\n")
    }
}
