//
//  Parts.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2019-12-17.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import IntCode
import Geometry

final class Part1: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> Int {
        let computer = Computer(program: program, inputs: [])
        let result = try computer.run()
        let scaffoldView = self.scaffoldView(from: result.outputs)
        draw(scaffoldView)
        
        let directions: [Point2D] = [.up, .down, .left, .right]
        let intersections = scaffoldView.keys.filter({ position in
            guard let character = scaffoldView[position], character == "#" else {
                return false
            }
            
            let isSurroundedByScaffolding = directions.allSatisfy({ direction in
                return scaffoldView[position + direction] == "#"
            })
            
            return isSurroundedByScaffolding
        })
        let alignmentParameters: Int = intersections.reduce(into: 0, { result, position in
            let product = Int(position.x) * Int(position.y)
            result += product
        })
        
        return alignmentParameters
    }
    
    private func scaffoldView(from outputs: [Int]) -> [Point2D: Character] {
        var scaffoldView = [Point2D: Character]()
        
        var x = 0
        var y = 0
        
        for asciiCode in outputs {
            guard let scalar = UnicodeScalar(asciiCode) else {
                continue
            }
            
            let character = Character(scalar)
            if character.isNewline {
                x = 0
                y += 1
                continue
            }
            
            let position = Point2D(x: x, y: y)
            scaffoldView[position] = character
            x += 1
        }
        
        return scaffoldView
    }
    
    private func draw(_ scaffoldView: [Point2D: Character]) {
        let allXCoordinates = scaffoldView.keys.map({ Int($0.x) })
        let minX = allXCoordinates.min()!
        let maxX = allXCoordinates.max()!
        
        let allYCoordinates = scaffoldView.keys.map({ Int($0.y) })
        let minY = allYCoordinates.min()!
        let maxY = allYCoordinates.max()!
        
        var drawnView = ""
        for y in minY ... maxY {
            for x in minX ... maxX {
                let position = Point2D(x: x, y: y)
                let character = scaffoldView[position, default: "."]
                
                drawnView.append(character)
            }
            drawnView.append("\n")
        }
        
        print(drawnView)
    }
}
