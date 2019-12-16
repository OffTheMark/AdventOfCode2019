//
//  Parts.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2019-12-16.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1: Part {
    let inputSignal: [Int: Int]
    let phaseCount: Int
    
    init(inputSignal: [Int: Int], phaseCount: Int) {
        self.inputSignal = inputSignal
        self.phaseCount = phaseCount
    }
    
    func solve() -> String {
        var phasedSignal = inputSignal
        
        for _ in 0..<phaseCount {
            var workingCopy = phasedSignal
            
            for outputIndex in phasedSignal.keys {
                let sumOfProducts = phasedSignal.reduce(into: 0, { result, element in
                    let (inputIndex, digit) = element
                    let multiplierInPattern = multiplier(for: outputIndex, at: inputIndex)
                    let product = multiplierInPattern * digit
                    result += product
                })
                let newDigit = abs(sumOfProducts) % 10
                workingCopy[outputIndex] = newDigit
            }
            
            phasedSignal = workingCopy
        }
        
        return firstEightDigits(of: phasedSignal)
    }
    
    private func firstEightDigits(of signal: [Int: Int]) -> String {
        return (0..<8).reduce(into: "", { result, index in
            let digit = signal[index]!
            result += String(digit)
        })
    }
}
