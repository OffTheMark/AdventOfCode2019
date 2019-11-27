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

    public mutating func rotate(by numberOfPositions: Int = 1) {
        let effectiveNumberOfPositions = numberOfPositions % count

        if effectiveNumberOfPositions == 0 {
            return
        }

        if effectiveNumberOfPositions < 0 {
            for _ in 0 ..< abs(effectiveNumberOfPositions) {
                let removed = removeFirst()
                append(removed)
            }
        }
        else {
            for _ in 0 ..< effectiveNumberOfPositions {
                let removed = removeLast()
                prepend(removed)
            }
        }
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
}

// MARK: Sequence

extension Deque: Sequence {
    public typealias Element = Element

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

    public var count: Int {
        return contents.count
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
