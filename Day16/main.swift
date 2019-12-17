//
//  main.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2019-12-16.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

let testInput = "80871224585914546619083218645595"

let puzzleInput = """
59756772370948995765943195844952640015210703313486295362653878290009098923609769261473534009395188480864325959786470084762607666312503091505466258796062230652769633818282653497853018108281567627899722548602257463608530331299936274116326038606007040084159138769832784921878333830514041948066594667152593945159170816779820264758715101494739244533095696039336070510975612190417391067896410262310835830006544632083421447385542256916141256383813360662952845638955872442636455511906111157861890394133454959320174572270568292972621253460895625862616228998147301670850340831993043617316938748361984714845874270986989103792418940945322846146634931990046966552
"""

let inputSignal: [Int: Int] = puzzleInput.enumerated().reduce(into: [:], { result, element in
    let (index, rawValue) = element
    guard let digit = Int(String(rawValue)) else {
        return
    }
    result[index] = digit
})

let inputList: [Int] = puzzleInput.reduce(into: [], { result, digit in
    guard let digit = Int(String(digit)) else {
        return
    }
    result.append(digit)
})

let title = "Day 16"
print(title, String(repeating: "=", count: title.count), separator: "\n", terminator: "\n\n")

let firstSubtitle = "Part 1"
print(firstSubtitle, String(repeating: "-", count: firstSubtitle.count), separator: "\n")

//let part1 = Part1(inputSignal: inputSignal, phaseCount: 100)
//let part1Solution = part1.solve()
//print(part1Solution, terminator: "\n\n")

let secondSubtitle = "Part 2"
print(secondSubtitle, String(repeating: "-", count: secondSubtitle.count), separator: "\n")

let part2 = Part2(inputSignal: inputList, phaseCount: 100)
let part2Solution = part2.solve()
print(part2Solution)
