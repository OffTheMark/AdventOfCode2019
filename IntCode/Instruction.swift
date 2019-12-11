//
//  Instruction.swift
//  IntCode
//
//  Created by Marc-Antoine Malépart on 2019-12-11.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

struct Instruction {
    let code: Code
    let parameterModes: [ParameterMode]
    let startingPosition: Int

    init(code: Code, parameterModes: [ParameterMode], startingPosition: Int) {
        self.code = code
        self.parameterModes = parameterModes
        self.startingPosition = startingPosition
    }

    enum Code: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
        case halt = 99

        var parameterCount: Int {
            switch self {
            case .halt:
                return 0

            case .add,
                 .multiply,
                 .lessThan,
                 .equals:
                return 3

            case .input,
                 .output,
                 .adjustRelativeBase:
                return 1

            case .jumpIfTrue, .jumpIfFalse:
                return 2
            }
        }

        var stride: Int {
            return parameterCount + 1
        }
    }
}

// MARK: - ParameterMode

enum ParameterMode: Int {
    case position = 0
    case immediate = 1
    case relative = 2
}
