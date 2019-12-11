//
//  Parts.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2019-12-09.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import IntCode

// MARK: Part1

final class Part1: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> [Int] {
        let computer = Computer(program: program, inputs: [1])
        let result = try computer.run()
        return result.outputs
    }
}

// MARK: Part2

final class Part2: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> [Int] {
        let computer = Computer(program: program, inputs: [2])
        let result = try computer.run()
        return result.outputs
    }
}
