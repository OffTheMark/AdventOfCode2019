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
        let chain = NodeChain(sequence)
        
        self.head = chain.head
        self.tail = chain.tail
        self.count = chain.count
    }

    // MARK: Adding Elements

    public mutating func prepend(_ value: Element) {
        replaceSubrange(startIndex..<startIndex, with: [value])
    }
    
    public mutating func prepend<S: Sequence>(contentsOf sequence: S) where S.Element == Element {
        replaceSubrange(startIndex..<startIndex, with: sequence)
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
        guard var currentExistingNode = head else {
            return
        }
        
        var currentIndex = startIndex
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

            if !isKnownUniquelyReferenced(&head) {
                copyNodes()
            }

            let node = self.node(at: position)
            node.value = newValue
        }
    }
}

// MARK: RangeReplaceableCollection

extension LinkedList: RangeReplaceableCollection {
    public mutating func replaceSubrange<S: Sequence>(_ subrange: Range<Int>, with newElements: __owned S) where Element == S.Element {
        precondition(subrange.lowerBound >= startIndex, "Subrange bounds are out of range.")
        precondition(subrange.upperBound <= endIndex, "Subrange bounds are out of range.")
        
        let chain = NodeChain(newElements)
        
        if chain.isEmpty {
            removeElements(at: subrange)
            return
        }
        
        if subrange == indices {
            head = chain.head
            tail = chain.tail
            count = chain.count
            return
        }
        
        if head != nil, !isKnownUniquelyReferenced(&head) {
            copyNodes()
        }
        
        defer {
            count += chain.count - subrange.count
        }
        
        if subrange.upperBound == startIndex {
            head?.previous = chain.tail
            chain.tail?.next = head
            head = chain.head
            return
        }
        
        if subrange.lowerBound == endIndex {
            tail?.next = chain.head
            chain.head?.previous = tail
            tail = chain.tail
            return
        }
        
        if subrange.lowerBound == startIndex {
            let nodeAfterChainTail = node(at: subrange.upperBound)
            nodeAfterChainTail.previous = chain.tail
            
            head = chain.head
            return
        }
        if subrange.upperBound == endIndex {
            let nodeBeforeChainHead = node(at: index(before: subrange.lowerBound))
            nodeBeforeChainHead.next = chain.head
            
            tail = chain.tail
            return
        }
        
        let nodeAtChainHead = node(at: subrange.lowerBound)
        let nodeAfterChainTail = node(at: subrange.upperBound)
        
        nodeAfterChainTail.previous = chain.tail
        nodeAtChainHead.previous?.next = chain.head
    }
    
    private mutating func removeElements(at range: Range<Int>) {
        if range.isEmpty {
            return
        }
        
        if range == indices {
            head = nil
            tail = nil
            count = 0
            return
        }
        
        if !isKnownUniquelyReferenced(&head) {
            copyNodes()
        }
        
        defer {
            count -= range.count
        }
        
        if range.lowerBound == startIndex {
            let newHead = node(at: range.upperBound)
            
            head = newHead
            head?.previous = nil
            return
        }
        
        if range.upperBound == endIndex {
            let nodePastNewTail = node(at: range.lowerBound)
            
            tail = nodePastNewTail.previous
            tail?.next = nil
            return
        }
        
        let nodeAtUpperBound = node(at: range.upperBound)
        let nodeBeforeLowerBound = node(at: index(before: range.lowerBound))
        
        nodeAtUpperBound.previous = nodeBeforeLowerBound
        nodeBeforeLowerBound.next = nodeAtUpperBound
    }
    
    fileprivate struct NodeChain {
        let head: Node?
        let tail: Node?
        var count = 0
        
        var isEmpty: Bool {
            return count == 0
        }
        
        init<S: Sequence>(_ sequence: S) where Element == S.Element {
            var iterator = sequence.makeIterator()
            
            guard let firstValue = iterator.next() else {
                head = nil
                tail = nil
                return
            }
            
            var currentNode = Node(value: firstValue)
            head = currentNode
            count += 1
            
            while let nextValue = iterator.next() {
                let nextNode = Node(value: nextValue)
                currentNode.next = nextNode
                nextNode.previous = currentNode
                currentNode = nextNode
                count += 1
            }
            
            tail = currentNode
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
