//
//  LinkedList.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-11-27.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public struct LinkedList<Element> {
    private var head: Node? = nil
    private var tail: Node? = nil
    public private(set) var count = 0

    // MARK: Creating a LinkedList

    public init() {}

    public init<S: Sequence>(_ sequence: S) where Element == S.Element {
        for element in sequence {
            append(element)
        }
    }

    // MARK: Adding Elements

    public mutating func append(_ value: Element) {
        let newNode = Node(value: value)

        if tail != nil {
            if !isKnownUniquelyReferenced(&tail) {
                copyNodes()
            }

            newNode.previous = tail
            tail?.next = newNode
        }
        else {
            head = newNode
        }

        tail = newNode
        count += 1
    }

    public mutating func prepend(_ value: Element) {
        let newNode = Node(value: value)

        if head != nil {
            if !isKnownUniquelyReferenced(&head) {
                copyNodes()
            }

            newNode.next = head
            head?.previous = newNode
        }
        else {
            tail = newNode
        }

        head = newNode
        count += 1
    }

    // MARK: Removing Elements

    @discardableResult public mutating func removeFirst() -> Element {
        precondition(head != nil, "List is empty.")

        if !isKnownUniquelyReferenced(&head) {
            copyNodes()
        }

        let headNode = self.head!
        let next = headNode.next

        if let next = next {
            next.previous = nil
        }
        else {
            tail = nil
        }

        head = next
        count -= 1

        return headNode.value
    }

    @discardableResult public mutating func removeLast() -> Element {
        precondition(tail != nil, "List is empty.")

        if !isKnownUniquelyReferenced(&tail) {
            copyNodes()
        }

        let tailNode = tail!
        let previous = tailNode.previous

        if let previous = previous {
            previous.next = nil
        }
        else {
            head = nil
        }

        tail = previous
        count -= 1

        return tailNode.value
    }

    public mutating func removeAll() {
        head = nil
        tail = nil
        count = 0
    }

    // MARK: Private Methods

    private func node(at index: Int) -> Node {
        precondition(indices.contains(index), "Index out of range.")

        var currentNode = head!
        var currentIndex = 0

        while currentIndex < index {
            currentNode = currentNode.next!
            currentIndex += 1
        }

        return currentNode
    }

    private mutating func copyNodes() {
        var currentIndex = startIndex
        var currentExistingNode = head!
        var currentNewNode = Node(value: currentExistingNode.value)
        let newHeadNode = currentNewNode
        currentIndex = index(after: currentIndex)

        while currentIndex < endIndex {
            currentExistingNode = currentExistingNode.next!

            let nextNode = Node(value: currentExistingNode.value)
            currentNewNode.next = nextNode
            nextNode.previous = currentNewNode
            currentNewNode = nextNode
            currentIndex = index(after: currentIndex)
        }

        head = newHeadNode
        tail = currentNewNode
    }

    private mutating func copyNodes(settingNodeAt index: Index, to value: Element) {
        var currentIndex = startIndex
        var currentExistingNode = head!
        var currentNewNode = Node(value: currentIndex == index ? value : currentExistingNode.value)
        let newHeadNode = currentNewNode
        currentIndex = self.index(after: currentIndex)

        while currentIndex < endIndex {
            currentExistingNode = currentExistingNode.next!

            let nextNode = Node(value: currentIndex == index ? value : currentExistingNode.value)
            currentNewNode.next = nextNode
            nextNode.previous = currentNewNode
            currentNewNode = nextNode
            currentIndex = self.index(after: currentIndex)
        }

        head = newHeadNode
        tail = currentNewNode
    }

    // MARK: - LinkedList.Node

    fileprivate class Node {
        public var value: Element
        public var next: Node? = nil
        public weak var previous: Node? = nil

        public init(value: Element) {
            self.value = value
        }
    }
}

// MARK: Sequence

extension LinkedList: Sequence {
    // MARK: Creating an Iterator

    public typealias Element = Element

    public typealias Iterator = Iterator

    public func makeIterator() -> Iterator {
        return Iterator(node: head)
    }

    public struct Iterator: IteratorProtocol {
        private var currentNode: Node?

        fileprivate init(node: Node?) {
            currentNode = node
        }

        public mutating func next() -> Element? {
            guard let currentNode = currentNode else {
                return nil
            }

            self.currentNode = currentNode.next
            return currentNode.value
        }
    }
}

// MARK: Collection

extension LinkedList: Collection {
    public typealias Index = Int

    // MARK: Manipulating Indices

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public var indices: Range<Int> {
        return startIndex ..< endIndex
    }

    public func index(after i: Int) -> Int {
        precondition(indices.contains(i), "Index out of range.")
        return i + 1
    }

    // MARK: Instance Properties

    /// The first element of the collection.
    public var first: Element? {
        return head?.value
    }

    public var isEmpty: Bool {
        return count == 0
    }
}

// MARK: BidirectionalCollection

extension LinkedList: BidirectionalCollection {
    /// The last element of the collection.
    ///
    /// - complexity: O(1)
    public var last: Element? {
        return tail?.value
    }

    public func index(before i: Int) -> Int {
        precondition(i > startIndex && i <= endIndex, "Index out of range.")
        return i - 1
    }
}

// MARK: MutableCollection

extension LinkedList: MutableCollection {
    // MARK: Accessing a Collection's Elements

    public subscript(position: Int) -> Element {
        get {
            precondition(indices.contains(position), "Index out of range.")

            let node = self.node(at: position)
            return node.value
        }
        set {
            precondition(indices.contains(position), "Index out of range.")

            guard isKnownUniquelyReferenced(&head) else {
                copyNodes(settingNodeAt: position, to: newValue)
                return
            }

            let node = self.node(at: position)
            node.value = newValue
        }
    }
}

// MARK: Equatable

extension LinkedList: Equatable where Element: Equatable {
    public static func == (lhs: LinkedList<Element>, rhs: LinkedList<Element>) -> Bool {
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

extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

// MARK: CustomStringConvertible

extension LinkedList: CustomStringConvertible {
    public var description: String {
        return "[" + lazy.map({ "\($0)" }).joined(separator: ", ") + "]"
    }
}
