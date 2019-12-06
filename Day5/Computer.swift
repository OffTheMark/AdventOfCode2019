//
//  Computer.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2019-12-05.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Computer

final class Computer {
    let input: Int
    let program: [Int]
    
    init(program: [Int], input: Int) {
        self.program = program
        self.input = input
    }
    
    func run() throws -> Void {
        var program = self.program
        
        var instructionPointer = 0
        
        while true {
            let potentialOperation = program[instructionPointer]
            
            guard let operation = Operation(rawValue: potentialOperation) else {
                throw InvalidOperationError(operation: potentialOperation)
            }
            
            let rangeOfParameters = (instructionPointer + 1)...(instructionPointer + operation.code.parameterCount + 1)
            let parameters = Array(program[rangeOfParameters])
            
            switch operation.code {
            case .halt:
                break
                
            case .add:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                program[outputAddress] = firstParameter + secondParameter
                
            case .multiply:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                program[outputAddress] = firstParameter * secondParameter
                
            case .input:
                let parameter = parameters[0]
                program[parameter] = input
                
            case .output:
                let parameter = parameters[0]
                let outputValue = program[parameter]
                print(outputValue)
            }
            
            instructionPointer += operation.code.parameterCount + 1
        }
    }
    
    // MARK: - Operation
    
    private struct Operation: RawRepresentable {
        let code: Code
        let parameterModes: [Int]
        let rawValue: Int
        
        enum Code {
            case halt
            case add
            case multiply
            case input
            case output
            
            init?(_ integer: Int) {
                switch integer {
                case 1:
                    self = .add
                case 2:
                    self = .multiply
                case 3:
                    self = .input
                case 4:
                    self = .output
                case 99:
                    self = .halt
                default:
                    return nil
                }
            }
            
            var parameterCount: Int {
                switch self {
                case .halt:
                    return 0
                    
                case .add, .multiply:
                    return 3
                    
                case .input, .output:
                    return 1
                }
            }
        }
        
        init?(rawValue: Int) {
            let codeRawValue = rawValue.digit(at: 0) + rawValue.digit(at: 1)
            
            guard let code = Code(codeRawValue) else {
                return nil
            }
            
            let parameterModes = (2...4).map({ rawValue.digit(at: $0) })
            
            self.code = code
            self.parameterModes = parameterModes
            self.rawValue = rawValue
        }
    }
}

// MARK: - ThermalRadiatorComputer

final class ThermalRadiatorComputer {
    let input: Int
    let program: [Int]
    
    init(program: [Int], input: Int) {
        self.program = program
        self.input = input
    }
    
    func run() throws -> Void {
        var program = self.program
        
        var instructionPointer = 0
        
        while true {
            let potentialOperation = program[instructionPointer]
            
            guard let operation = Operation(rawValue: potentialOperation) else {
                throw InvalidOperationError(operation: potentialOperation)
            }
            
            let rangeOfParameters = (instructionPointer + 1)...(instructionPointer + operation.code.parameterCount + 1)
            let parameters = Array(program[rangeOfParameters])
            
            switch operation.code {
            case .halt:
                break
                
            case .add:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                program[outputAddress] = firstParameter + secondParameter
                
            case .multiply:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                program[outputAddress] = firstParameter * secondParameter
                
            case .input:
                let parameter = parameters[0]
                program[parameter] = input
                
            case .output:
                let parameter = parameters[0]
                let outputValue = program[parameter]
                print(outputValue)
                
            case .jumpIfTrue:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                
                if firstParameter != 0 {
                    instructionPointer = secondParameter
                    continue
                }
                
            case .jumpIfFalse:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                
                if firstParameter == 0 {
                    instructionPointer = secondParameter
                    continue
                }
                
            case .lessThan:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                
                if firstParameter < secondParameter {
                    program[outputAddress] = 1
                }
                else {
                    program[outputAddress] = 0
                }
                
            case .equals:
                let firstParameter: Int = {
                    if operation.parameterModes[0] == 1 {
                        return parameters[0]
                    }
                    
                    return program[parameters[0]]
                }()
                let secondParameter: Int = {
                    if operation.parameterModes[1] == 1 {
                        return parameters[1]
                    }
                    
                    return program[parameters[1]]
                }()
                let outputAddress = parameters[2]
                
                
                if firstParameter == secondParameter {
                    program[outputAddress] = 1
                }
                else {
                    program[outputAddress] = 0
                }
            }
            
            instructionPointer += operation.code.parameterCount + 1
        }
    }
    
    // MARK: - Operation
    
    private struct Operation: RawRepresentable {
        let code: Code
        let parameterModes: [Int]
        let rawValue: Int
        
        enum Code {
            case halt
            case add
            case multiply
            case input
            case output
            case jumpIfTrue
            case jumpIfFalse
            case lessThan
            case equals
            
            init?(_ integer: Int) {
                switch integer {
                case 1:
                    self = .add
                case 2:
                    self = .multiply
                case 3:
                    self = .input
                case 4:
                    self = .output
                case 5:
                    self = .jumpIfTrue
                case 6:
                    self = .jumpIfFalse
                case 7:
                    self = .lessThan
                case 8:
                    self = .equals
                case 99:
                    self = .halt
                    
                default:
                    return nil
                }
            }
            
            var parameterCount: Int {
                switch self {
                case .halt:
                    return 0
                    
                case .add,
                     .multiply,
                     .lessThan,
                     .equals:
                    return 3
                    
                case .input, .output:
                    return 1
                    
                case .jumpIfTrue, .jumpIfFalse:
                    return 2
                }
            }
        }
        
        init?(rawValue: Int) {
            let codeRawValue = rawValue.digit(at: 0) + rawValue.digit(at: 1)
            
            guard let code = Code(codeRawValue) else {
                return nil
            }
            
            let parameterModes = (2...4).map({ rawValue.digit(at: $0) })
            
            self.code = code
            self.parameterModes = parameterModes
            self.rawValue = rawValue
        }
    }
}

// MARK: - InvalidOperationError

struct InvalidOperationError: LocalizedError {
    let operation: Int
    
    // MARK: LocalizedError
    
    var localizedDescription: String {
        return "Invalid operation: \(operation)"
    }
}

// MARK: - Int

fileprivate extension Int {
    func digit(at decimalPlace: Int) -> Int {
        let power = pow(10, decimalPlace).integer
        return (self / power) % 10
    }
}

// MARK: - Decimal

fileprivate extension Decimal {
    var integer: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
