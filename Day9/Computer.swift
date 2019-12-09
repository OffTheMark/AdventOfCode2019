//
//  Computer.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2019-12-09.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Computer

final class Computer {
    private(set) var program: [Int]
    private(set) var instructionPointer: Int
    private(set) var relativeBase: Int
    private(set) var inputs: [Int]

    init(
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

        let parameterModes: [ParameterMode] = (2...4).map({ position in
            let rawValue = fullCode.digit(at: position)
            return ParameterMode(rawValue: rawValue) ?? .position
        })

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
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = parameterForWriting(parameters[2], mode: instruction.parameterModes[2])

            write(firstParameter + secondParameter, to: outputAddress)

        case .multiply:
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = parameterForWriting(parameters[2], mode: instruction.parameterModes[2])

            write(firstParameter * secondParameter, to: outputAddress)

        case .input:
            let address = parameterForWriting(parameters[0], mode: instruction.parameterModes[0])

            write(inputs.removeFirst(), to: address)

        case .output:
            let output = parameterForReading(parameters[0], mode: instruction.parameterModes[0])

            instructionPointer += instruction.code.stride
            return .outputAndContinue(output)

        case .jumpIfTrue:
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])

            if firstParameter != 0 {
                instructionPointer = secondParameter
                return .continue
            }

        case .jumpIfFalse:
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])

            if firstParameter == 0 {
                instructionPointer = secondParameter
                return .continue
            }

        case .lessThan:
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = parameterForWriting(parameters[2], mode: instruction.parameterModes[2])

            if firstParameter < secondParameter {
                write(1, to: outputAddress)
            }
            else {
                write(0, to: outputAddress)
            }

        case .equals:
            let firstParameter = parameterForReading(parameters[0], mode: instruction.parameterModes[0])
            let secondParameter = parameterForReading(parameters[1], mode: instruction.parameterModes[1])
            let outputAddress = parameterForWriting(parameters[2], mode: instruction.parameterModes[2])

            if firstParameter == secondParameter {
                write(1, to: outputAddress)
            }
            else {
                write(0, to: outputAddress)
            }

        case .adjustRelativeBase:
            relativeBase += parameters[0]

        case .halt:
            return .halt
        }

        instructionPointer += instruction.code.stride
        return .continue
    }

    private func parameterForReading(_ value: Int, mode: ParameterMode) -> Int {
        switch mode {
        case .position:
            return read(at: value)

        case .immediate:
            return value

        case .relative:
            return read(at: relativeBase + value)
        }
    }

    private func parameterForWriting(_ value: Int, mode: ParameterMode) -> Int {
        switch mode {
        case .position:
            return value

        case .relative:
            return relativeBase + value

        default:
            return value
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

    fileprivate enum Access {
        case read
        case write
    }

    fileprivate enum ParameterMode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
    }

    // MARK: - InstructionResult

    fileprivate enum InstructionResult {
        case `continue`
        case halt
        case outputAndContinue(Int)
    }

    // MARK: - Instruction

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

    enum Error: Swift.Error {
        case invalidPointer
        case invalidOperationCode(Int)
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
