//
//  Bag.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Bag

public struct Bag<Element: Hashable> {
    private var contents: [Element: Int] = [:]

    public init() {}

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        for element in sequence {
            add(element)
        }
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Element, value: Int) {
        for (element, count) in sequence {
            add(element, occurences: count)
        }
    }

    public var uniqueCount: Int {
        return contents.count
    }

    public var totalCount: Int {
        return contents.values.reduce(0, { $0 + $1 })
    }

    public mutating func add(_ member: Element, occurences: Int = 1) {
        precondition(occurences > 0, "Occurences must be positive.")

        contents[member, default: 0] += occurences
    }

    public mutating func remove(_ member: Element, occurences: Int = 1) {
        guard let currentCount = contents[member], currentCount >= occurences else {
            preconditionFailure("Bag should contain at least \(occurences) occurence(s) of member \(member).")
        }

        precondition(occurences > 0, "Occurences must be positive.")

        if currentCount > occurences {
            contents[member] = currentCount - occurences
        }
        else {
            contents.removeValue(forKey: member)
        }
    }
}

// MARK: Sequence

extension Bag: Sequence {
    public typealias Iterator = AnyIterator<(element: Element, count: Int)>

    public func makeIterator() -> Iterator {
        var iterator = contents.makeIterator()

        return AnyIterator({
            return iterator.next()
        })
    }
}

// MARK: Collection

extension Bag: Collection {
    public typealias Index = BagIndex<Element>

    public var startIndex: Index {
        return BagIndex(contents.startIndex)
    }

    public var endIndex: Index {
        return BagIndex(contents.endIndex)
    }

    public subscript(position: Index) -> Iterator.Element {
        precondition(indices.contains(position), "Index is out of bounds")

        let dictionaryElement = contents[position.index]
        return (element: dictionaryElement.key, count: dictionaryElement.value)
    }

    public func index(after i: Index) -> Index {
        return Index(contents.index(after: i.index))
    }
}

// MARK: CustomStringConvertible

extension Bag: CustomStringConvertible {
    public var description: String {
        return String(describing: contents)
    }
}

// MARK: ExpressibleByArrayLiteral

extension Bag: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

// MARK: ExpressibleByDictionaryLiteral

extension Bag: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Element, Int)...) {
        let pairs = elements.map({ (key, value) in
            return (key: key, value: value)
        })
        self.init(pairs)
    }
}

// MARK: - BagIndex

public struct BagIndex<Element: Hashable> {
    fileprivate let index: DictionaryIndex<Element, Int>

    fileprivate init(_ dictionaryIndex: DictionaryIndex<Element, Int>) {
        self.index = dictionaryIndex
    }
}

// MARK: Comparable

extension BagIndex: Comparable {
    public static func == (lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index == rhs.index
    }

    public static func <= (lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index <= rhs.index
    }

    public static func >= (lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index >= rhs.index
    }

    public static func < (lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index < rhs.index
    }

    public static func > (lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index > rhs.index
    }
}
