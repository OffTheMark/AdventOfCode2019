//
//  Parts.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2019-12-08.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

final class Part1: Part {
    let digits: [Int]
    
    init(digits: [Int]) {
        self.digits = digits
    }
    
    func solve() -> Int  {
        let sizeOfLayer = 25 * 6
        let layers: [Int: [Int]] = digits.enumerated()
            .reduce(into: [:], { result, element in
                let (index, digit) = element
                let row = index / sizeOfLayer
                result[row, default: []].append(digit)
            })
        let countOfDigitsByLayer: [Int: [Int: Int]] = layers
            .mapValues({ layer in
                return layer.reduce(into: [:], { counts, digit in
                    counts[digit, default: 0] += 1
                })
            })
        let layerWithFewestZeroes = countOfDigitsByLayer
            .sorted(by: { first, second in
                let countOfZeroesInFirst = first.value[0, default: 0]
                let countOfZeroesInSecond = second.value[0, default: 0]
                return countOfZeroesInFirst < countOfZeroesInSecond
            })
            .first!
        
        return layerWithFewestZeroes.value[1, default: 0] * layerWithFewestZeroes.value[2, default: 0]
    }
}

// MARK: - Part2

final class Part2: Part {
    let pixels: [Pixel]
    
    init(digits: [Int]) {
        self.pixels = digits.compactMap({ Pixel(rawValue: $0) })
    }
    
    func solve()  {
        let sizeOfLayer = 25 * 6
        let layers: [[Pixel]] = pixels.enumerated()
            .reduce(into: [], { result, element in
                let (index, pixel) = element
                let layerIndex = index / sizeOfLayer
                
                if !result.indices.contains(layerIndex) {
                    result.append([])
                }
                
                var layer = result[layerIndex]
                layer.append(pixel)
                result[layerIndex] = layer
            })
        let renderedPixelByPosition: [Int: Pixel] = layers
            .reduce(into: [:], { result, layer in
                for (index, pixel) in layer.enumerated() {
                    guard let existingPixel = result[index] else {
                        result[index] = pixel
                        continue
                    }
                    
                    switch (existingPixel, pixel) {
                    case (.transparent, .black), (.transparent, .white):
                        result[index] = pixel
                        
                    default:
                        continue
                    }
                }
        })
        let pixelsToRender: [Pixel] = renderedPixelByPosition
            .sorted(by: { first, second in
                return first.key < second.key
            })
            .map({ element in
                return element.value
            })
        
        render(pixelsToRender, size: (25, 6))
    }
    
    private func render(_ pixels: [Pixel], size: (width: Int, height: Int)) {
        let output: [String] = pixels.enumerated()
            .reduce(into: [], { result, element in
                let (index, pixel) = element
                let row = index / size.width
                
                if !result.indices.contains(row) {
                    result.append("")
                }
                
                var line = result[row]
                line.append(pixel.character)
                result[row] = line
            })
        for line in output {
            print(line)
        }
    }
}

// MARK: - Pixel

enum Pixel: Int {
    case black = 0
    case white = 1
    case transparent = 2
    
    var character: Character {
        switch self {
        case .black:
            return "."
        case .white:
            return "#"
        case .transparent:
            return " "
        }
    }
}
