//
//  Computer.swift
//  IntCode
//
//  Created by Marc-Antoine Malépart on 2019-12-09.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public typealias Program = [Int]

// MARK: Computer

public final class Computer {
    // MARK: Properties
    
    private(set) var program: Program
    private(set) var instructionPointer: Int
    private(set) var relativeBase: Int
    private(set) var inputs: [Int]

    // MARK: Create a Computer
    
    public init(
        program: Program,
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

    public func addInput(_ input: Int) {
        inputs.append(input)
    }
    
    public func addInputs(_ inputs: [Int]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    // MARK: Run Program

    public func run() throws -> Result {
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
                return Result(outputs: outputs, endState: .halted)
                
            case .waitingForInput:
                return Result(outputs: outputs, endState: .waitingForInput)
            }
        }
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
                
            case .halt, .waitingForInput:
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

            if inputs.isEmpty {
                return .waitingForInput
            }
            
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
    
    // MARK: - Computer.InstructionResult

    enum InstructionResult {
        case `continue`
        case halt
        case outputAndContinue(Int)
        case waitingForInput
    }
    
    // MARK: - Computer.Result
    
    public struct Result {
        public let outputs: [Int]
        public let endState: EndState
    }
    
    // MARK: - Computer.EndState
    
    public enum EndState {
        case halted
        case waitingForInput
    }

    // MARK: - Computer.Error
    
    public enum Error: Swift.Error {
        case invalidPointer
        case invalidOperationCode(Int)
    }
}
