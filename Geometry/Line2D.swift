//
//  Line2D.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-03.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public struct Line2D {
    public var start: Point2D
    public var end: Point2D
    
    public init(start: Point2D, end: Point2D) {
        self.start = start
        self.end = end
    }
    
    public var deltaX: Float {
        return end.x - start.x
    }
    
    public var deltaY: Float {
        return end.y - start.y
    }
    
    public var length: Float {
        return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }
    
    public func intersection(with other: Line2D) -> Point2D? {
        let determinant = self.deltaX * other.deltaY - self.deltaY * other.deltaX
        
        if abs(determinant) < 0.0001 {
            return nil
        }
        
        let ab = ((self.start.y - other.start.y) * other.deltaX - (self.start.x - other.start.x) * other.deltaY) / determinant
        
        guard ab > 0, ab < 1 else {
            return nil
        }
        
        let cd = ((self.start.y - other.start.y) * self.deltaX - (self.start.x - other.start.x) * self.deltaY) / determinant
        
        guard cd > 0, cd < 1 else {
            return nil
        }
        
        return Point2D(
            x: self.start.x + ab * self.deltaX,
            y: self.start.y + ab * self.deltaY
        )
    }

    public func intersects(with other: Line2D) -> Bool {
        return intersection(with: other) != nil
    }

    public func intersects(with point: Point2D) -> Bool {
        let distanceToStart = start.linearDistance(to: point)
        let distanceToEnd = end.linearDistance(to: point)

        return distanceToStart + distanceToEnd - self.length < 0.0001
    }
}
