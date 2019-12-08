//
//  Parts.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2019-12-08.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1: Part {
    let digits: [Int]
    
    init(digits: [Int]) {
        self.digits = digits
    }
    
    func solve() -> Int  {
        let sizeOfLayer = 25 * 6
        let layers: [Int: [Int]] = digits.enumerated()
            .reduce(into: [:], { result, element in
                let (index, digit) = element
                let row = index / sizeOfLayer
                result[row, default: []].append(digit)
            })
        let countOfDigitsByLayer: [Int: [Int: Int]] = layers
            .mapValues({ layer in
                return layer.reduce(into: [:], { counts, digit in
                    counts[digit, default: 0] += 1
                })
            })
        let layerWithFewestZeroes = countOfDigitsByLayer
            .sorted(by: { first, second in
                let countOfZeroesInFirst = first.value[0, default: 0]
                let countOfZeroesInSecond = second.value[0, default: 0]
                return countOfZeroesInFirst < countOfZeroesInSecond
            })
            .first!
        
        return layerWithFewestZeroes.value[1, default: 0] * layerWithFewestZeroes.value[2, default: 0]
    }
}

