//
//  Solver.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2019-12-05.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part 1

final class Part1: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws {
        let computer = Computer(program: program, input: 1)
        try computer.run()
    }
}

// MARK: - Part2

final class Part2: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws {
        let computer = Computer(program: program, input: 5)
        try computer.run()
    }
}
