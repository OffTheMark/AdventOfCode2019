//
//  main.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2019-12-19.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

let puzzleInput = """
109,424,203,1,21101,11,0,0,1105,1,282,21102,1,18,0,1105,1,259,1201,1,0,221,203,1,21102,31,1,0,1106,0,282,21101,38,0,0,1106,0,259,21001,23,0,2,22102,1,1,3,21101,0,1,1,21102,57,1,0,1106,0,303,1202,1,1,222,20102,1,221,3,21002,221,1,2,21101,259,0,1,21102,80,1,0,1106,0,225,21101,0,51,2,21101,0,91,0,1106,0,303,1202,1,1,223,20101,0,222,4,21101,259,0,3,21102,225,1,2,21101,225,0,1,21101,118,0,0,1105,1,225,20102,1,222,3,21102,1,152,2,21102,133,1,0,1105,1,303,21202,1,-1,1,22001,223,1,1,21102,1,148,0,1105,1,259,1202,1,1,223,20101,0,221,4,21002,222,1,3,21102,1,17,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21101,195,0,0,105,1,108,20207,1,223,2,21002,23,1,1,21102,1,-1,3,21102,214,1,0,1105,1,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,1202,-4,1,249,22101,0,-3,1,21202,-2,1,2,22102,1,-1,3,21101,250,0,0,1106,0,225,22101,0,1,-4,109,-5,2105,1,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2106,0,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,22101,0,-2,-2,109,-3,2105,1,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,21201,-2,0,3,21102,1,343,0,1105,1,303,1106,0,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,21202,-4,1,1,21102,1,384,0,1105,1,303,1105,1,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,22102,1,1,-4,109,-5,2105,1,0
"""

let program = puzzleInput.components(separatedBy: ",").compactMap({ Int($0) })

let title = "Day 19"
print(title, String(repeating: "=", count: title.count), separator: "\n", terminator: "\n\n")

let firstSubtitle = "Part 1"
print(firstSubtitle, String(repeating: "-", count: firstSubtitle.count), separator: "\n")

let part1 = Part1(program: program)
do {
    let part1Solution = try part1.solve()
    print(part1Solution)
}
catch {
    print(error)
}

print()

let secondSubtitle = "Part 2"
print(secondSubtitle, String(repeating: "-", count: firstSubtitle.count), separator: "\n")

let part2 = Part2(program: program, statesByPosition: part1.statesByPosition)
do {
    let part2Solution = try part2.solve()
    print(part2Solution)
}
catch {
    print(error)
}
