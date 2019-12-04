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

    var points: Set<Point> {
        return segments.reduce(into: Set(), { result, segment in
            result.formUnion(segment.points)
        })
    }
}

// MARK: - Segment

struct Segment {
    let points: [Point]

    init(start: Point, move: Move) {
        let partialMoves = (0..<move.distance).map({
            return Move(direction: move.direction, distance: $0)
        })

        let points = partialMoves.map({ return start.applying($0) })

        self.points = points
    }
}
