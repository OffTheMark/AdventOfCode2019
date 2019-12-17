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
            phasedSignal = phase(phasedSignal)
        }
        
        return firstEightDigits(of: phasedSignal)
    }
    
    private func phase(_ signal: [Int: Int]) -> [Int: Int] {
        var phasedSignal = signal
        
        for outputIndex in phasedSignal.keys {
            let sumOfProducts = phasedSignal.reduce(into: 0, { result, element in
                let (inputIndex, digit) = element
                let multiplierInPattern = multiplier(for: outputIndex, at: inputIndex)
                let product = multiplierInPattern * digit
                result += product
            })
            let newDigit = abs(sumOfProducts) % 10
            phasedSignal[outputIndex] = newDigit
        }
        
        return phasedSignal
        
    }
    
    private func firstEightDigits(of signal: [Int: Int]) -> String {
        return (0..<8).reduce(into: "", { result, index in
            let digit = signal[index]!
            result += String(digit)
        })
    }
}

// MARK: - Part2

final class Part2: Part {
    let duplicatedSignal: [Int]
    let phaseCount: Int
    
    init(inputSignal: [Int], phaseCount: Int) {
        let duplicatedSignal: [Int] = (0..<10_000)
            .reduce(into: [Int](), { result, _ in
                result.append(contentsOf: inputSignal)
            })
        
        self.duplicatedSignal = duplicatedSignal
        self.phaseCount = phaseCount
    }
    
    func solve() -> String {
        let messageOffset = duplicatedSignal[0..<7].enumerated().reduce(into: 0, { result, element in
            let (index, digit) = element
            let exponent = 7 - index - 1
            result += pow(10, exponent).integer * digit
        })
        var relevantElements: [Int] = Array(duplicatedSignal.suffix(from: messageOffset))
        
        for iteration in 0 ..< phaseCount {
            relevantElements = phase(relevantElements)
        }
        
        return firstEightDigits(of: relevantElements)
    }
    
    private func phase(_ signal: [Int]) -> [Int] {
        var output = Array(repeating: 0, count: signal.count)
        
        var sequenceSum = signal.reduce(into: 0, { result, digit in
            result += digit
        })
        for index in signal.indices {
            output[index] = sequenceSum % 10
            sequenceSum -= signal[index]
        }
        
        return output
    }
    
    private func firstEightDigits(of signal: [Int]) -> String {
        return signal[0..<8].reduce(into: "", { result, digit in
            result += String(digit)
        })
    }
}
