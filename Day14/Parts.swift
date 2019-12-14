//
//  Parts.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2019-12-14.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1: Part {
    let reactionsByOutput: [Chemical: Reaction]
    
    init(reactionsByOutput: [Chemical: Reaction]) {
        self.reactionsByOutput = reactionsByOutput
    }
    
    func solve() -> Int {
        var substancesNeeded: [Substance] = [Substance(chemical: .fuel, amount: 1)]
        var surplus = [Chemical: Int]()
        var amountOfOreNeeded = 0
        
        while !substancesNeeded.isEmpty {
            let substance = substancesNeeded.removeLast()
            
            var componentsNeeded = reduce(substance, surplus: &surplus)
            if let amountOfOre = componentsNeeded[.ore] {
                componentsNeeded.removeValue(forKey: .ore)
                amountOfOreNeeded += amountOfOre
            }
            
            for (chemical, amount) in componentsNeeded {
                if let index = substancesNeeded.firstIndex(where: { $0.chemical == chemical }) {
                    let existingSubstance = substancesNeeded[index]
                    let substance = Substance(chemical: chemical, amount: existingSubstance.amount + amount)
                    substancesNeeded[index] = substance
                }
                else {
                    let substance = Substance(chemical: chemical, amount: amount)
                    substancesNeeded.append(substance)
                }
            }
            
        }
        
        return amountOfOreNeeded
    }
    
    private func reduce(_ substance: Substance, surplus: inout [Chemical: Int]) -> [Chemical: Int] {
        let reaction = reactionsByOutput[substance.chemical]!
        
        let multiples = Int((Float(substance.amount) / Float(reaction.amount)).rounded(.up))
        surplus[substance.chemical, default: 0] += multiples * reaction.amount - substance.amount
        
        var componentsNeeded = [Chemical: Int]()
        
        for (chemical, amount) in reaction.ingredients {
            var totalNeeded = amount * multiples
            let usableSurplus = min(totalNeeded, surplus[chemical, default: 0])
            totalNeeded -= usableSurplus
            surplus[chemical, default: 0] -= usableSurplus
            componentsNeeded[chemical] = totalNeeded
        }
        
        return componentsNeeded
    }
}
