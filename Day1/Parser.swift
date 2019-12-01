//
//  Parser.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2019-12-01.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Parser: Common.Parser {
    let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func parse() -> [Module] {
        return input
            .components(separatedBy: .newlines)
            .compactMap({
                guard let mass = Int($0) else {
                    return nil
                }
                
                return Module(mass: mass)
            })
    }
}
