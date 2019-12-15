//
//  Queue.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-12-15.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Queue

public struct Queue<Element> {
    private var contents = LinkedList<Element>()
    
    // MARK: Creating a Queue
    
    public init() {}
    
    public init<S: Sequence>(_ sequence: S) where Element == S.Element {
        for element in sequence {
            enqueue(element)
        }
    }
    
    public func peek() -> Element? {
        return contents.first
    }
    
    // MARK: Adding Elements
    
    public mutating func enqueue(_ value: Element) {
        contents.append(value)
    }
    
    // MARK: Removing Elements
    
    public mutating func dequeue() -> Element? {
        if contents.isEmpty {
            return nil
        }
        
        let first = contents.removeFirst()
        return first
    }
}

// MARK: Sequence

extension Queue: Sequence {
    public typealias Element = Element
    
    public typealias Iterator = AnyIterator<Element>
    
    public func makeIterator() -> AnyIterator<Element> {
        var iterator = contents.makeIterator()
        
        return AnyIterator({
            return iterator.next()
        })
    }
}

// MARK: Collection

extension Queue: Collection {
    public typealias Index = Int
    
    // MARK: Accessing a Collection's Elements
    
    public subscript(position: Int) -> Element {
        return contents[position]
    }
    
    // MARK: Manipulating Indices
    
    public var startIndex: Int {
        return contents.startIndex
    }

    public var endIndex: Int {
        return contents.endIndex
    }

    public var indices: Range<Int> {
        return contents.indices
    }

    public func index(after i: Int) -> Int {
        return contents.index(after: i)
    }

    // MARK: Instance Properties

    public var count: Int {
        return contents.count
    }

    public var first: Element? {
        return contents.first
    }

    public var isEmpty: Bool {
        return contents.isEmpty
    }
}
