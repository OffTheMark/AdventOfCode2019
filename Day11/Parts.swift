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
        var currentPosition: Coordinate = .zero
        var direction: Direction = .up
        var currentColor = colorByPosition[currentPosition, default: .black]
        let computer = Computer(program: program, inputs: [currentColor.rawValue])
        var result = try computer.run()

        while result.outputs.count == 2, result.pause != .halted {
            let colorToPaint = Color(rawValue: result.outputs[0])!
            let turn = Turn(rawValue: result.outputs[1])!

            direction.makeTurn(turn)
            colorByPosition[currentPosition] = colorToPaint
            currentPosition += direction.coordinate

            currentColor = colorByPosition[currentPosition, default: .black]
            computer.addInput(currentColor.rawValue)
            result = try computer.run()
        }

        return colorByPosition.count
    }
}
