//
//  Solver.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2019-12-02.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1Solver: Common.Solver {
    let parser: Day2.Parser

    init(input: String) {
        self.parser = Parser(input: input)
    }

    func solve() throws -> Int {
        var program = parser.parse()
        program[1] = 12
        program[2] = 2

        var opcodeIndex = 0

        while true {
            let opcode = program[opcodeIndex]

            if opcode == 99 {
                break
            }

            let slice = Array(program[opcodeIndex...opcodeIndex + 3])
            let inputs = slice[1...2].map({ program[$0] })
            let outputIndex = slice[3]

            switch opcode {
            case 1:
                program[outputIndex] = inputs.reduce(0, { $0 + $1 })

            case 2:
                program[outputIndex] = inputs.reduce(1, { $0 * $1 })

            default:
                throw InvalidOpcodeError(opcode: opcode)
            }

            opcodeIndex += 4
        }

        return program[0]
    }
}

struct InvalidOpcodeError: LocalizedError {
    let opcode: Int

    // MARK: LocalizedError

    var localizedDescription: String {
        return "Invalid opcode: \(opcode)"
    }
}
