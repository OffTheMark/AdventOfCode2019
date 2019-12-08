//
//  main.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2019-12-04.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

let puzzleInput = "272091-815432"
let bounds = puzzleInput
    .components(separatedBy: "-")
    .compactMap({ Int($0) })
let validRange = bounds[0]...bounds[1]

print("Part 1")
let part1 = Part1(validRange: validRange)
let part1Solution = part1.solve()
print(part1Solution)

print()

print("Part 2")
let part2 = Part2(validRange: validRange)
let part2Solution = part2.solve()
print(part2Solution)
