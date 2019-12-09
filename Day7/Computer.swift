//
//  Computer.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2019-12-07.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Computer

final class Computer {
    private(set) var program: [Int]
    private(set) var instructionPointer: Int
    private(set) var inputs: [Int]
    
    init(
        program: [Int],
        instructionPointer: Int = 0,
        inputs: [Int]
    ) {
        self.program = program
        self.instructionPointer = instructionPointer
        self.inputs = inputs
    }
    
    convenience init(state: State, inputs: [Int]) {
        self.init(
            program: state.program,
            instructionPointer: state.instructionPointer,
            inputs: inputs
        )
    }
    
    var state: State {
        return State(program: program, instructionPointer: instructionPointer)
    }
    
    func run() throws -> [Int] {
        var outputs = [Int]()
        
        while true {
            let instruction = try nextInstruction()
            let result = execute(instruction)
            
            switch result {
            case .continue:
                continue
                
            case .outputAndContinue(let output):
                outputs.append(output)
                
            case .halt:
                return outputs
            }
        }
        
        return outputs
    }
    
    func step() throws -> Int? {
        while true {
            let instruction = try nextInstruction()
            let result = execute(instruction)
            
            switch result {
            case .continue:
                continue
            case .outputAndContinue(let output):
                return output
            case .halt:
                return nil
            }
        }
    }
    
    fileprivate func nextInstruction() throws -> Instruction {
        guard program.indices.contains(instructionPointer) else {
            throw Error.invalidPointer
        }
        
        let fullCode = program[instructionPointer]
        let rawValue = fullCode % 100
        
        guard let code = Instruction.Code(rawValue: rawValue) else {
            throw Error.invalidOperationCode(rawValue)
        }

        let parameterModes = (2...4).map({ fullCode.digit(at: $0) })
        
        return Instruction(
            code: code,
            parameterModes: parameterModes,
            startingPosition: instructionPointer
        )
    }
    
    fileprivate func execute(_ instruction: Instruction) -> InstructionResult {
        let offset = instruction.startingPosition + 1
        let rangeOfParameters = offset ..< (offset + instruction.code.parameterCount)
        let parameters = Array(program[rangeOfParameters])
        
        switch instruction.code {
        case .add:
            let firstParameter: Int = {
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
                    return parameters[1]
                }
                return program[parameters[1]]
            }()
            let outputAddress = parameters[2]
            
            program[outputAddress] = firstParameter + secondParameter
            
        case .multiply:
            let firstParameter: Int = {
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
                    return parameters[1]
                }
                return program[parameters[1]]
            }()
            let outputAddress = parameters[2]
            
            program[outputAddress] = firstParameter * secondParameter
            
        case .input:
            let parameter = parameters[0]
            
            program[parameter] = inputs.removeFirst()
            
        case .output:
            let parameter = parameters[0]
            let output = program[parameter]
            
            instructionPointer += instruction.code.stride
            return .outputAndContinue(output)
            
        case .jumpIfTrue:
            let firstParameter: Int = {
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
                    return parameters[1]
                }
                return program[parameters[1]]
            }()
            
            if firstParameter != 0 {
                instructionPointer = secondParameter
                return .continue
            }
            
        case .jumpIfFalse:
            let firstParameter: Int = {
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
                    return parameters[1]
                }
                return program[parameters[1]]
            }()
            
            if firstParameter == 0 {
                instructionPointer = secondParameter
                return .continue
            }
            
        case .lessThan:
            let firstParameter: Int = {
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
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
                if instruction.parameterModes[0] == 1 {
                    return parameters[0]
                }
                return program[parameters[0]]
            }()
            let secondParameter: Int = {
                if instruction.parameterModes[1] == 1 {
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
            
        case .halt:
            return .halt
        }
        
        instructionPointer += instruction.code.stride
        return .continue
    }
    
    // MARK: - Computer.State
    
    struct State {
        fileprivate let program: [Int]
        fileprivate let instructionPointer: Int
        
        fileprivate init(program: [Int], instructionPointer: Int) {
            self.program = program
            self.instructionPointer = instructionPointer
        }
        
        init(program: [Int]) {
            self.init(program: program, instructionPointer: 0)
        }
    }
    
    // MARK: - Computer.InstructionResult
    
    fileprivate enum InstructionResult {
        case `continue`
        case halt
        case outputAndContinue(Int)
    }
    
    // MARK: - Computer.Instruction
    
    fileprivate struct Instruction {
        let code: Code
        let parameterModes: [Int]
        let startingPosition: Int
        
        init(code: Code, parameterModes: [Int], startingPosition: Int) {
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
                    
                case .input, .output:
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
    
    // MARK: - Computer.Error
    
    enum Error: Swift.Error {
        case invalidPointer
        case invalidOperationCode(Int)
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
