//
//  Parser.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2019-12-14.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

final class Parser {
    func reactions(from input: String) -> [Reaction] {
        return input
            .components(separatedBy: .newlines)
            .map({ line in
                return self.reaction(from: line)
            })
    }
    
    private func reaction(from line: String) -> Reaction {
        let parts = line.components(separatedBy: " => ")
        let source = parts[0]
        let result = parts[1]
        
        let output = substance(from: result)
        let ingredients: [Chemical: Int] = source
            .components(separatedBy: ", ")
            .reduce(into: [:], { result, sourceComponent in
                let substance = self.substance(from: sourceComponent)
                result[substance.chemical] = substance.amount
            })
        
        return Reaction(output: output.chemical, amount: output.amount, ingredients: ingredients)
    }
    
    private func substance(from input: String) -> Substance {
        let parts = input.components(separatedBy: " ")
        let amount = Int(parts[0])!
        let chemical = Chemical(rawValue: parts[1])
        
        return Substance(chemical: chemical, amount: amount)
    }
}

struct Reaction {
    let output: Chemical
    let amount: Int
    let ingredients: [Chemical: Int]
}

struct Substance {
    let chemical: Chemical
    let amount: Int
}

struct Chemical {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static var ore: Self {
        return .init(rawValue: "ORE")
    }
    
    static var fuel: Self {
        return .init(rawValue: "FUEL")
    }
}

extension Chemical: Hashable {}
