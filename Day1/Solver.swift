//
//  Part1Solver.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1Solver: Solver {
    let parser: Day1.Parser
    
    init(input: String) {
        self.parser = Parser(input: input)
    }
    
    func solve() -> Int {
        let massPerModule = parser.parse()
        let totalFuelRequired = massPerModule.reduce(0, { result, mass in
            return result + self.fuelRequired(for: mass)
        })
        
        return totalFuelRequired
    }
    
    private func fuelRequired(for mass: Int) -> Int {
        return (mass / 3) - 2
    }
}

final class Part2Solver: Solver {
    let parser: Day1.Parser
    
    init(input: String) {
        self.parser = Parser(input: input)
    }
    
    func solve() -> Int {
        let massPerModule = parser.parse()
        
        let totalFuelRequired = massPerModule.reduce(0, { result, mass in
            let fuelForModuleOnly = self.fuelRequired(for: mass)
            var totalFuelForModule = fuelForModuleOnly
            
            var fuelForCurrentFuel = self.fuelRequired(for: fuelForModuleOnly)
            while fuelForCurrentFuel > 0 {
                totalFuelForModule += fuelForCurrentFuel
                fuelForCurrentFuel = self.fuelRequired(for: fuelForCurrentFuel)
            }
            
            return result + totalFuelForModule
        })
        
        return totalFuelRequired
    }
    
    private func fuelRequired(for mass: Int) -> Int {
        return (mass / 3) - 2
    }
}
