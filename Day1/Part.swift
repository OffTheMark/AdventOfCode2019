//
//  Part1.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Part1

final class Part1: Part {
    let parser: Day1.Parser
    
    init(input: String) {
        self.parser = Parser(input: input)
    }
    
    func solve() -> Int {
        let modules = parser.parse()
        let totalFuelRequired = modules.reduce(0, { result, module in
            return result + module.fuelRequired()
        })
        
        return totalFuelRequired
    }
}

// MARK: - Part2

final class Part2: Part {
    let parser: Day1.Parser
    
    init(input: String) {
        self.parser = Parser(input: input)
    }
    
    func solve() -> Int {
        let modules = parser.parse()
        let totalFuelRequired = modules.reduce(0, { result, module in
            return result + module.fuelRequired(accountForMassOfFuel: true)
        })
        
        return totalFuelRequired
    }
}

// MARK: - Module

struct Module {
    let mass: Int
    
    init(mass: Int) {
        self.mass = mass
    }
    
    func fuelRequired(accountForMassOfFuel: Bool = false) -> Mass {
        let fuelForModuleOnly = mass.fuelRequired
        
        if !accountForMassOfFuel {
            return fuelForModuleOnly
        }
        
        var totalFuel = fuelForModuleOnly
        var fuelForCurrentFuel = fuelForModuleOnly.fuelRequired
        
        while fuelForCurrentFuel > 0 {
            totalFuel += fuelForCurrentFuel
            fuelForCurrentFuel = fuelForCurrentFuel.fuelRequired
        }
        
        return totalFuel
    }
}

// MARK: - Mass

typealias Mass = Int

extension Mass {
    var fuelRequired: Mass {
        return self / 3 - 2
    }
}
