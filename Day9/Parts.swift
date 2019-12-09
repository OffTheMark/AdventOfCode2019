//
//  Parts.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2019-12-09.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> [Int] {
        let computer = Computer(program: program, inputs: [1])
        return try computer.run()
    }
}
