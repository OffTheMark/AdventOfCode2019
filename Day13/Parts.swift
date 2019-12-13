//
//  Parts.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2019-12-13.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import Geometry
import IntCode

// MARK: Part1

final class Part1: Part {
    let program: [Int]

    init(program: [Int]) {
        self.program = program
    }

    func solve() throws -> Int {
        let computer = Computer(program: program, inputs: [])
        let result = try computer.run()
        var tilesByPosition = [Point2D: Tile]()

        for startIndex in stride(from: 0, to: result.outputs.count - 2, by: 3) {
            let x = result.outputs[startIndex]
            let y =  result.outputs[startIndex + 1]
            let tile = Tile(rawValue: result.outputs[startIndex + 2])!

            let point = Point2D(x: Float(x), y: Float(y))
            tilesByPosition[point] = tile
        }

        return tilesByPosition
            .filter({ position, tile in
                return tile == .block
            })
            .count
    }
}
