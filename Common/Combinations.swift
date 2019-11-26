//
//  Combinations.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public extension Array {
    func combinations(ofSize size: Int) -> Array<Array<Element>> {
        guard count >= size else {
            return []
        }

        guard count >= 0 && size > 0 else {
            return [[]]
        }

        if size == 1 {
            return map({ element in
                return [element]
            })
        }

        var allCombinations = Array<Array<Element>>()
        var elementsAfterCurrent = self

        for element in self {
            elementsAfterCurrent.removeFirst()

            let subCombinations = elementsAfterCurrent.combinations(ofSize: size - 1)
            let combinations = subCombinations
                .map({ subCombination in
                    return [element] + subCombination
                })

            allCombinations += combinations
        }

        return allCombinations
    }

    func combinationsWithRepetition(ofSize size: Int) -> Array<Array<Element>> {
        guard count >= 0 && size > 0 else {
            return [[]]
        }

        if size == 1 {
            return map({ element in
                return [element]
            })
        }

        var allCombinations = Array<Array<Element>>()
        var elementsStartingFromCurrent = self

        for element in self {
            let subCombinations = elementsStartingFromCurrent.combinationsWithRepetition(ofSize: size - 1)
            let combinations = subCombinations
                .map({ subCombination in
                    return [element] + subCombination
                })

            allCombinations += combinations

            elementsStartingFromCurrent.removeFirst()
        }

        return allCombinations
    }
}
