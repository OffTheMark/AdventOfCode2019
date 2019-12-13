//
//  main.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2019-12-12.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

let testInput = """
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
"""

let puzzleInput = """
<x=5, y=-1, z=5>
<x=0, y=-14, z=2>
<x=16, y=4, z=0>
<x=18, y=1, z=16>
"""

let positionOfMoons = puzzleInput
    .components(separatedBy: .newlines)
    .compactMap({ Point3D(string: $0) })

let title = "Day 12"
print(title, String(repeating: "=", count: title.count), separator: "\n", terminator: "\n\n")

let firstSubtitle = "Part 1"
print(firstSubtitle, String(repeating: "-", count: firstSubtitle.count), separator: "\n")
let part1 = Part1(positionOfMoons: positionOfMoons, numberOfSteps: 1000)
let part1Solution = part1.solve()
print(part1Solution)
