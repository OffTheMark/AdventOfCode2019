//
//  Pattern.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2019-12-16.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

func multiplier(for outputIndex: Int, at inputIndex: Int) -> Int {
    let basePattern = [0, 1, 0, -1]
    
    let multiplier = outputIndex.advanced(by: 1)
    let effectiveInputIndex = inputIndex.advanced(by: 1)
    let repeatedPatternCount = multiplier * basePattern.count
    
    let indexInBasePattern = (effectiveInputIndex % repeatedPatternCount) / multiplier
    return basePattern[indexInBasePattern]
}
