//
//  Wire.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

// MARK: Wire

struct Wire {
    let segments: [Line2D]
    
    init(segments: [Line2D]) {
        self.segments = segments
    }
    
    init(origin: Point2D, moves: [Move]) {
        var segments = [Line2D]()
        var currentPoint = origin
        
        for move in moves {
            let start = currentPoint
            let end = currentPoint.applying(move)
            let segment = Line2D(start: start, end: end)
            
            segments.append(segment)
            currentPoint = end
        }
        
        self.init(segments: segments)
    }
    
    func steps(to point: Point2D) -> Float? {
        guard let firstIndex = segments.firstIndex(where: { $0.intersects(with: point) }) else {
            return nil
        }
        
        let stepsInPreviousSegments = segments[0..<firstIndex]
            .reduce(0, { result, line in
                return result + line.length
            })
        let stepsInIntersectingSegment = segments[firstIndex].start.linearDistance(to: point)
        
        return stepsInPreviousSegments + stepsInIntersectingSegment
    }
}
