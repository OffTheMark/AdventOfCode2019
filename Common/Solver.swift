//
//  Solver.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public protocol Solver {
    associatedtype Solution

    func solve() throws -> Solution
}
