//
//  Solver.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2019-12-07.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part1

final class Part1: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> Int {
        let phaseSettings = Array(0...4)
        let phasePermutations = phaseSettings.permutationsWithoutRepetition(ofSize: phaseSettings.count)
        
        var outputByPermutation = [[Int]: Int]()
        
        for permutation in phasePermutations {
            var feedback = 0
            
            for phaseSetting in permutation {
                let computer = Computer(program: program, inputs: [phaseSetting, feedback])
                let outputs = try computer.run()
                feedback = outputs.last!
            }
            
            outputByPermutation[permutation] = feedback
        }
        
        return outputByPermutation.values.max()!
    }
}

// MARK: - Part2

final class Part2: Part {
    let program: [Int]
    
    init(program: [Int]) {
        self.program = program
    }
    
    func solve() throws -> Int {
        let phaseSettings = Array(5...9)
        let phasePermutations = phaseSettings.permutationsWithoutRepetition(ofSize: phaseSettings.count)
        
        var outputByPermutation = [[Int]: Int]()
        
        for permutation in phasePermutations {
            var feedback = 0
            var amplifierIndex = 0
            
            var hasGivenPhaseSettings: [Bool] = .init(repeating: false, count: 5)
            var stateByAmplifier = [Int: Computer.State]()
            
            while true {
                let phaseSetting = permutation[amplifierIndex]
                let inputs: [Int]
                if hasGivenPhaseSettings[amplifierIndex] == false {
                    inputs = [phaseSetting, feedback]
                    hasGivenPhaseSettings[amplifierIndex] = true
                }
                else {
                    inputs = [feedback]
                }
                let state: Computer.State = stateByAmplifier[amplifierIndex] ?? .init(program: program)
                
                let computer = Computer(state: state, inputs: inputs)
                guard let output = try computer.step() else {
                    break
                }
                
                stateByAmplifier[amplifierIndex] = computer.state
                feedback = output
                amplifierIndex = (amplifierIndex + 1) % 5
            }
            
            outputByPermutation[permutation] = feedback
        }
        
        return outputByPermutation.values.max()!
    }
}
