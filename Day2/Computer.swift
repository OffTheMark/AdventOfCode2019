//
//  Computer.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2019-12-02.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Computer

final class Computer {
    let program: [Int]
    let noun: Int
    let verb: Int

    init(program: [Int], noun: Int, verb: Int) {
        self.program = program
        self.noun = noun
        self.verb = verb
    }

    func run() throws -> Int {
        var program = self.program
        program[1] = noun
        program[2] = verb

        var instructionPointer = 0

        while true {
            let opcode = program[instructionPointer]

            if opcode == 99 {
                break
            }

            let instruction = Array(program[instructionPointer...instructionPointer + 3])
            let inputs = instruction[1...2].map({ address in
                return program[address]
            })
            let outputAddress = instruction[3]

            switch opcode {
            case 1:
                let output = inputs.reduce(0, { $0 + $1 })
                program[outputAddress] = output

            case 2:
                let output = inputs.reduce(1, { $0 * $1 })
                program[outputAddress] = output

            default:
                throw InvalidOpcodeError(opcode: opcode)
            }

            instructionPointer += instruction.count
        }

        return program[0]
    }
}

// MARK: - InvalidOpcodeError

struct InvalidOpcodeError: LocalizedError {
    let opcode: Int

    // MARK: LocalizedError

    var localizedDescription: String {
        return "Invalid opcode: \(opcode)"
    }
}

