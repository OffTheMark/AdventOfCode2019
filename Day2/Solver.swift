//
//  Solver.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2019-12-02.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part1Solver

final class Part1Solver: Common.Solver {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> Int {
        var program = self.program
        program[1] = 12
        program[2] = 2
        let computer = Computer(program: program)

        return try computer.run()
    }
}

// MARK: - Part2Solver

final class Part2Solver: Common.Solver {
    let expectedOutput = 19690720
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> Int {
        let expectedInputs = try findExpectedInputs()
        return expectedInputs.noun * 100 + expectedInputs.verb
    }

    private func findExpectedInputs() throws -> (noun: Int, verb: Int) {
        for noun in 0...99 {
            for verb in 0...99 {
                var program = self.program
                program[1] = noun
                program[2] = verb
                let computer = Computer(program: program)
                
                do {
                    let result = try computer.run()
                    if result == expectedOutput {
                        return (noun, verb)
                    }
                }
                catch {
                    break
                }
            }
        }

        throw CouldNotFindInputsError()
    }
}

struct CouldNotFindInputsError: Error {}
