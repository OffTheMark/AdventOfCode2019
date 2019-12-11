//
//  Computer.swift
//  IntCode
//
//  Created by Marc-Antoine Malépart on 2019-12-09.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Computer

public final class Computer {
    // MARK: Properties
    
    private(set) var program: [Int]
    private(set) var instructionPointer: Int
    private(set) var relativeBase: Int
    private(set) var inputs: [Int]

    // MARK: Create a Computer
    
    public init(
        program: [Int],
        instructionPointer: Int = 0,
        relativeBase: Int = 0,
        inputs: [Int]
    ) {
        self.program = program
        self.instructionPointer = instructionPointer
        self.relativeBase = relativeBase
        self.inputs = inputs
    }
    
    public convenience init(state: State, inputs: [Int]) {
        self.init(
            program: state.program,
            instructionPointer: state.instructionPointer,
            relativeBase: state.relativeBase,
            inputs: inputs
        )
    }
    
    // MARK: Get Internal State
    
    public var state: State {
        return State(program: program, instructionPointer: instructionPointer, relativeBase: relativeBase)
    }

    // MARK: Feed Input

    func addInput(_ input: Int) {
        inputs.append(input)
    }
    
    // MARK: Run Program

    public func run() throws -> [Int] {
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

    public func nextOutput() throws -> Int? {
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
    
    // MARK: Execute Instructions

    private func nextInstruction() throws -> Instruction {
        guard program.indices.contains(instructionPointer) else {
            throw Error.invalidPointer
        }

        let fullCode = program[instructionPointer]
        let rawValue = fullCode % 100

        guard let code = Instruction.Code(rawValue: rawValue) else {
            throw Error.invalidOperationCode(rawValue)
        }

        let digitPlaces = 2 ..< (2 + code.parameterCount)
        let parameterModes: [ParameterMode] = digitPlaces.map({ position in
            let rawValue = fullCode.digit(at: position)
            return ParameterMode(rawValue: rawValue) ?? .position
        })

        return Instruction(
            code: code,
            parameterModes: parameterModes,
            startingPosition: instructionPointer
        )
    }

    private func execute(_ instruction: Instruction) -> InstructionResult {
        let offset = instruction.startingPosition + 1
        let rangeOfParameters = offset ..< (offset + instruction.code.parameterCount)
        let parameters = Array(program[rangeOfParameters])

        switch instruction.code {
        case .add:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])
            let address = literalParameter(parameters[2], mode: instruction.parameterModes[2])

            write(firstParameter + secondParameter, to: address)

        case .multiply:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])
            let address = literalParameter(parameters[2], mode: instruction.parameterModes[2])

            write(firstParameter * secondParameter, to: address)

        case .input:
            let address = literalParameter(parameters[0], mode: instruction.parameterModes[0])

            write(inputs.removeFirst(), to: address)

        case .output:
            let output = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])

            instructionPointer += instruction.code.stride
            return .outputAndContinue(output)

        case .jumpIfTrue:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])

            if firstParameter != 0 {
                instructionPointer = secondParameter
                return .continue
            }

        case .jumpIfFalse:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])

            if firstParameter == 0 {
                instructionPointer = secondParameter
                return .continue
            }

        case .lessThan:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = literalParameter(parameters[2], mode: instruction.parameterModes[2])

            if firstParameter < secondParameter {
                write(1, to: outputAddress)
            }
            else {
                write(0, to: outputAddress)
            }

        case .equals:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = interpretedParameter(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = literalParameter(parameters[2], mode: instruction.parameterModes[2])

            if firstParameter == secondParameter {
                write(1, to: outputAddress)
            }
            else {
                write(0, to: outputAddress)
            }

        case .adjustRelativeBase:
            let firstParameter = interpretedParameter(parameters[0], mode: instruction.parameterModes[0])
            relativeBase += firstParameter

        case .halt:
            return .halt
        }

        instructionPointer += instruction.code.stride
        return .continue
    }
    
    // MARK: Read/Write Values in Program

    private func interpretedParameter(_ value: Int, mode: ParameterMode) -> Int {
        switch mode {
        case .position:
            return read(at: value)

        case .immediate:
            return value

        case .relative:
            return read(at: relativeBase + value)
        }
    }

    private func literalParameter(_ value: Int, mode: ParameterMode) -> Int {
        switch mode {
        case .position, .immediate:
            return value

        case .relative:
            return relativeBase + value
        }
    }

    private func write(_ value: Int, to position: Int) {
        precondition(position >= program.startIndex, "Accessing memory at negative index.")

        if !program.indices.contains(position) {
            let countOfZeroesToAppend = position - program.count + 1
            program.append(contentsOf: Array(repeating: 0, count: countOfZeroesToAppend))
        }

        program[position] = value
    }

    private func read(at position: Int) -> Int {
        precondition(position >= program.startIndex, "Accessing memory at negative index.")

        if !program.indices.contains(position) {
            return 0
        }

        return program[position]
    }
    
    // MARK: - Computer.State
    
    public struct State {
        fileprivate let program: [Int]
        fileprivate let instructionPointer: Int
        fileprivate let relativeBase: Int
        
        fileprivate init(program: [Int], instructionPointer: Int, relativeBase: Int) {
            self.program = program
            self.instructionPointer = instructionPointer
            self.relativeBase = relativeBase
        }
        
        public init(program: [Int]) {
            self.init(program: program, instructionPointer: 0, relativeBase: 0)
        }
    }
    
    // MARK: - Computer.ParameterMode

    fileprivate enum ParameterMode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
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

    // MARK: - Computer.Error
    
    public enum Error: Swift.Error {
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
