//
//  Parser.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2019-12-02.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Parser: Common.Parser {
    let input: String

    init(input: String) {
        self.input = input
    }

    func parse() -> [Int] {
        return input
            .components(separatedBy: ",")
            .compactMap({  Int($0) })
    }
}
