//
//  Deque.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-11-27.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public struct Deque<Element> {
    private var contents = LinkedList<Element>()

    // MARK: Creating a Deque

    public init() {}

    public init<S: Sequence>(_ sequence: S) where Element == S.Element {
        for element in sequence {
            append(element)
        }
    }

    // MARK: Adding Elements

    public mutating func prepend(_ value: Element) {
        contents.prepend(value)
    }

    public mutating func append(_ value: Element) {
        contents.append(value)
    }

    // MARK: Removing Elements

    @discardableResult public mutating func removeFirst() -> Element {
        return contents.removeFirst()
    }

    @discardableResult public mutating func removeLast() -> Element {
        return contents.removeLast()
    }

    public mutating func removeAll() {
        contents.removeAll()
    }

    // MARK: Moving Elements

    public mutating func rotateRight(by positions: Int = 1) {
        precondition(positions > 0, "Number of positions must be positive.")

        if isEmpty {
            return
        }

        let effectivePositions = positions % count

        if effectivePositions == 0 {
            return
        }

        for _ in 0 ..< effectivePositions {
            let removed = removeLast()
            prepend(removed)
        }
    }

    public mutating func rotateLeft(by positions: Int = 1) {
        precondition(positions > 0, "Number of positions must be positive.")

        if isEmpty {
            return
        }

        let effectivePositions = positions % count

        if effectivePositions == 0 {
            return
        }

        for _ in 0 ..< effectivePositions {
            let removed = removeFirst()
            append(removed)
        }
    }
}

// MARK: Sequence

extension Deque: Sequence {
    // MARK: Creating an Iterator

    public typealias Element = Element

    public typealias Iterator = AnyIterator<Element>

    public func makeIterator() -> AnyIterator<Element> {
        var iterator = contents.makeIterator()

        return AnyIterator({
            return iterator.next()
        })
    }
}

// MARK: Deque

extension Deque: Collection {
    public typealias Index = Int

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

// MARK: BidirectionalCollection

extension Deque: BidirectionalCollection {
    public var last: Element? {
        return contents.last
    }

    public func index(before i: Int) -> Int {
        return contents.index(before: i)
    }
}

// MARK: MutableCollection

extension Deque: MutableCollection {
    // MARK: Accessing a Collection's Elements

    public subscript(position: Int) -> Element {
        get {
            return contents[position]
        }
        set {
            contents[position] = newValue
        }
    }
}

// MARK: Equatable

extension Deque: Equatable where Element: Equatable {
    public static func == (lhs: Deque<Element>, rhs: Deque<Element>) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }

        let elementPairs = zip(lhs, rhs)

        return elementPairs.allSatisfy({ left, right in
            return left == right
        })
    }
}

// MARK: ExpressibleByArrayLiteral

extension Deque: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

// MARK: CustomStringConvertible

extension Deque: CustomStringConvertible {
    public var description: String {
        return "[" + lazy.map({ "\($0)" }).joined(separator: ", ") + "]"
    }
}
