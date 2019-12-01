//
//  File.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-12-01.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public protocol Parser {
    associatedtype Output
    
    var input: String { get }
    
    func parse() -> Output
}
