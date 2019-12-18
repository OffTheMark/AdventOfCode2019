//
//  Point2DExtensions.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2019-12-17.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Geometry

extension Point2D {
    static var up: Self {
        return .init(x: 0, y: -1)
    }
    
    static var down: Self {
        return .init(x: 0, y: 1)
    }
    
    static var left: Self {
        return .init(x: -1, y: 0)
    }
    
    static var right: Self {
        return .init(x: 1, y: 0)
    }
}
