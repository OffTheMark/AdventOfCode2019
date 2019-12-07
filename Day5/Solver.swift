//
//  Solver.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2019-12-05.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1Solver: Solver {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws {
        let computer = Computer(program: program, input: 1)
        try computer.run()
    }
}

final class Part2Solver: Solver {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws {
        let computer = Computer(program: program, input: 5)
        try computer.run()
    }
}
