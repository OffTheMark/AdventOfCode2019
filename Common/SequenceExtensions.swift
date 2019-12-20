//
//  SequenceExtensions.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-20.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public extension Sequence {
    func count(where isIncluded: (Element) throws -> Bool) rethrows -> Int {
        return try self.reduce(into: 0, { count, element in
                if try isIncluded(element) {
                    count += 1
                }
            })
    }
}
