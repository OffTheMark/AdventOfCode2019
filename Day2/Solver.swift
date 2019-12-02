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
    let parser: Day2.Parser

    init(input: String) {
        self.parser = Parser(input: input)
    }

    func solve() throws -> Int {
        let program = parser.parse()
        let computer = Computer(program: program, noun: 12, verb: 2)

        return try computer.run()
    }
}
