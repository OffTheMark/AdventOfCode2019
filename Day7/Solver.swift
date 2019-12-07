//
//  Solver.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2019-12-07.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1Solver: Solver {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() -> Int {
        let phaseSettings = Array(0...4)
        let phasePermutations = phaseSettings.permutationsWithoutRepetition(ofSize: 5)
        
        var permutationOutputs = [Int]()
        
        for permutation in phasePermutations {
            var outputs = [0]
            
            for element in permutation {
                let inputs = [element, outputs.last!]
                let amplifier = Computer(program: program, inputs: inputs)
                let amplifierOutputs = amplifier.run()
                
                outputs.append(amplifierOutputs.last!)
            }
            
            if let maximum = outputs.max() {
                permutationOutputs.append(maximum)
            }
        }
        
        return permutationOutputs.max()!
    }
}
