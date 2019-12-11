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
        var computer = Computer(program: program, inputs: [currentColor.rawValue])
        var output = try computer.run()

        while output.count == 2 {
            let colorToPaint = Color(rawValue: output[0])!
            let turn = Turn(rawValue: output[1])!

            direction.makeTurn(turn)
            colorByPosition[currentPosition] = colorToPaint
            currentPosition += direction.coordinate

            currentColor = colorByPosition[currentPosition, default: .black]
            let previousState = computer.state
            computer = Computer(state: previousState, inputs: [currentColor.rawValue])
        }

        return colorByPosition.count
    }
}
