//
//  Password.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2019-12-04.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

struct Password: RawRepresentable {
    let rawValue: String
    
    init?(rawValue: String) {
        let digits = rawValue.compactMap({ character in
            return Int(String(character))
        })
        
        guard digits.count == 6 else {
            return nil
        }
        
        let digitPairs = digits.indices
            .dropLast()
            .map({ index in
                return DigitPair(left: digits[index], right: digits[index + 1])
            })
        
        
        var containsDouble = false
        let digitsAreAscending = digitPairs.reduce(into: true, { result, pair in
            if pair.left > pair.right {
                result = false
            }
            
            if pair.left == pair.right {
                containsDouble = true
            }
        })
        
        guard digitsAreAscending, containsDouble else {
            return nil
        }
        
        self.rawValue = rawValue
    }
}

struct StricterPassword: RawRepresentable {
    let rawValue: String
    
    init?(rawValue: String) {
        let digits = rawValue.compactMap({ character in
            return Int(String(character))
        })
        
        guard digits.count == 6 else {
            return nil
        }
        
        let digitPairs = digits.indices
            .dropLast()
            .map({ index in
                return DigitPair(left: digits[index], right: digits[index + 1])
            })
        
        guard digitPairs.allSatisfy({ $0.left <= $0.right }) else {
            return nil
        }
        
        let countsPerDouble: [DigitPair: Int] = digitPairs.reduce(into: [:], { result, pair in
            guard pair.left == pair.right else {
                return
            }
            
            result[pair, default: 0] += 1
        })
        
        guard countsPerDouble.contains(where: { _, count in return count == 1 }) else {
            return nil
        }
        
        self.rawValue = rawValue
    }
}

// MARK: - DigitPair

fileprivate struct DigitPair {
    let left: Int
    let right: Int
}

// MARK: Hashable

extension DigitPair: Hashable {}
