//
//  Bag.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: Bag

public struct Bag<Item: Hashable> {
    // MARK: Properties

    private var contents: [Item: Int] = [:]

    // MARK: Creating a Bag

    public init() {}

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Item {
        for element in sequence {
            add(element)
        }
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Item, value: Int) {
        for (element, count) in sequence {
            add(element, count: count)
        }
    }

    // MARK: Inspecting a Bag

    public var uniqueCount: Int {
        return contents.count
    }

    public func count(of element: Item) -> Int {
        return contents[element, default: 0]
    }

    // MARK: Adding Elements

    public mutating func add(_ item: Item, count: Int = 1) {
        precondition(count > 0, "Count must be positive.")

        contents[item, default: 0] += count
    }

    // MARK: Removing Elements

    @discardableResult public mutating func remove(_ item: Item, count: Int = 1) -> Self.Element {
        guard let currentCount = contents[item] else {
            preconditionFailure("Bag should already contain item \(item).")
        }

        guard currentCount >= count else {
            preconditionFailure("Bag should contain at least \(count) occurence(s) of item \(item).")
        }

        precondition(count > 0, "Count must be positive.")

        if currentCount > count {
            contents[item] = currentCount - count
        }
        else {
            contents.removeValue(forKey: item)
        }

        return (item, count)
    }

    @discardableResult public mutating func removeAll(of item: Item) -> Self.Element {
        let removedCount = contents.removeValue(forKey: item) ?? 0
        return (item, removedCount)
    }

    public mutating func removeAll() {
        contents.removeAll()
    }
}

// MARK: Sequence

extension Bag: Sequence {
    public typealias Element = (item: Item, count: Int)

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
    public typealias Index = BagIndex<Item>

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
        return (dictionaryElement.key, dictionaryElement.value)
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
    public init(arrayLiteral elements: Item...) {
        self.init(elements)
    }
}

// MARK: ExpressibleByDictionaryLiteral

extension Bag: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Item, Int)...) {
        let pairs = elements.map({ (key, value) in
            return (key: key, value: value)
        })
        self.init(pairs)
    }
}

// MARK: Equatable

extension Bag: Equatable where Item: Equatable {
    public static func == (lhs: Bag<Item>, rhs: Bag<Item>) -> Bool {
        return lhs.contents == rhs.contents
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
