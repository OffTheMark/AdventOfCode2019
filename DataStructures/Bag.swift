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
    // MARK: Properties

    private var contents: [Element: Int] = [:]

    // MARK: Creating a Bag

    public init() {}

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        for element in sequence {
            add(element)
        }
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Element, value: Int) {
        for (element, count) in sequence {
            add(element, count: count)
        }
    }

    // MARK: Inspecting a Bag

    public var uniqueCount: Int {
        return contents.count
    }

    public func count(of element: Element) -> Int {
        return contents[element, default: 0]
    }

    // MARK: Adding Elements

    public mutating func add(_ member: Element, count: Int = 1) {
        precondition(count > 0, "Count must be positive.")

        contents[member, default: 0] += count
    }

    // MARK: Removing Elements

    public mutating func remove(_ member: Element, count: Int = 1) {
        guard let currentCount = contents[member], currentCount >= count else {
            preconditionFailure("Bag should contain at least \(count) occurence(s) of member \(member).")
        }

        precondition(count > 0, "Count must be positive.")

        if currentCount > count {
            contents[member] = currentCount - count
        }
        else {
            contents.removeValue(forKey: member)
        }
    }

    public mutating func removeAll() {
        contents.removeAll()
    }
}

// MARK: Sequence

extension Bag: Sequence {
    public typealias Element = (element: Element, count: Int)

    public typealias Iterator = AnyIterator<Self.Element>

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

    // MARK: Manipulating Indices

    public var startIndex: Index {
        return BagIndex(contents.startIndex)
    }

    public var endIndex: Index {
        return BagIndex(contents.endIndex)
    }

    public func index(after i: Index) -> Index {
        return Index(contents.index(after: i.index))
    }

    // MARK: Instance Properties

    public var count: Int {
        return contents.values.reduce(0, { result, currentCount in
            return result + currentCount
        })
    }

    var first: Self.Element? {
        let dictionaryElement = contents.first

        return dictionaryElement.map({ key, value in
            return (element: key, count: value)
        })
    }

    public var isEmpty: Bool {
        return contents.isEmpty
    }

    // MARK: Accessing a Collection's Elements

    public subscript(position: Index) -> Self.Element {
        precondition(indices.contains(position), "Index is out of bounds")

        let dictionaryElement = contents[position.index]
        return (element: dictionaryElement.key, count: dictionaryElement.value)
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
