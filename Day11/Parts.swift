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
