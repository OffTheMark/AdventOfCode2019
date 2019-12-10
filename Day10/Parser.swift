//
//  Parser.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2019-12-10.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

final class Parser {
    func asteroids(in input: String) -> Set<Point> {
        return input
            .components(separatedBy: .newlines)
            .enumerated()
            .reduce(into: [], { result, element in
                let (y, line) = element
                let asteroids: [Point] = line
                    .enumerated()
                    .compactMap({ x, character in
                        guard let element = Element(rawValue: character) else {
                            return nil
                        }

                        guard element == .asteroid else {
                            return nil
                        }

                        return Point(x: Float(x), y: Float(y))
                    })
                result.formUnion(asteroids)
            })
    }

    private enum Element: Character {
        case asteroid = "#"
        case void = "."
    }
}

