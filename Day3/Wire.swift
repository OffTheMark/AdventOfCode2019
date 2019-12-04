//
//  Wire.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common

// MARK: Wire

struct Wire {
    let segments: [Segment]

    init(segments: [Segment]) {
        self.segments = segments
    }

    init(origin: Point, moves: [Move]) {
        var segments = [Segment]()
        var currentPoint = origin

        for move in moves {
            let segment = Segment(start: currentPoint, move: move)
            segments.append(segment)

            currentPoint.apply(move)
        }

        self.init(segments: segments)
    }
    
    var points: [Point] {
        var points = [Point]()
        
        guard let firstSegment = segments.first else {
            return points
        }
        
        points.append(contentsOf: firstSegment.points)
        
        for segment in segments.dropFirst() {
            points.append(contentsOf: segment.points.dropFirst())
        }
        
        return points
    }
}

// MARK: - Segment

struct Segment {
    let points: [Point]

    init(start: Point, move: Move) {
        var points = [start]
        
        if move.distance > 0 {
            let partialMoves = (1...Int(move.distance)).map({
                return Move(direction: move.direction, distance: Float($0))
            })
            let otherPoints = partialMoves.map({ start.applying($0) })
            points.append(contentsOf: otherPoints)
        }

        self.points = points
    }
}
