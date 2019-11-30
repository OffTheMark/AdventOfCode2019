//
//  LinkedListAddTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-27.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class LinkedListAddTests: XCTestCase {
    // MARK: Adding Elements to an Empty List

    func test_EmptyList_AfterPrependingElement_ContainsOnlyElement() {
        var list = LinkedList<Int>()

        list.prepend(0)
        
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list, [0])
    }
    
    func test_EmptyList_AfterPrependingElements_ContainsOnlyElements() {
        var list = LinkedList<Int>()

        list.prepend(contentsOf: 0...2)
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list, [0, 1, 2])
    }

    func test_EmptyList_AfterAppendingElement_ContainsOnlyElement() {
        var list = LinkedList<Int>()

        list.append(0)
        
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list, [0])
    }

    func test_EmptyList_AfterAppendingElements_ContainsOnlyElements() {
        var list = LinkedList<Int>()

        list.append(contentsOf: 0...2)
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list, [0, 1, 2])
    }

    // MARK: Adding Elements to a Non-Empty List

    func test_ListWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElement() {
        var list: LinkedList = [1]

        list.prepend(0)
        
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list, [0, 1])
    }
    
    func test_ListWithOneElement_AfterPrependingElements_ContainsNewElementsFollowedByExistingElement() {
        var list: LinkedList = [1]
        
        list.prepend(contentsOf: -2...0)
        
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list, [-2, -1, 0, 1])
    }

    func test_ListWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElement() {
        var list: LinkedList = [0]

        list.append(1)
        
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list, [0, 1])
    }

    func test_ListWithOneElement_AfterAppendingNewElements_ContainsExistingElementFollowedByNewElements() {
        var list: LinkedList = [0]

        list.append(contentsOf: 1...3)
        
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list, [0, 1, 2, 3])
    }

    func test_ListWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByElements() {
        var list: LinkedList = [1, 2, 3, 4, 5]

        list.prepend(0)
        
        XCTAssertEqual(list.count, 6)
        XCTAssertEqual(list, [0, 1, 2, 3, 4, 5])
    }

    func test_ListWithElements_AfterPrependingNewElements_ContainsNewElementsFollowedByElements() {
        var list: LinkedList = [1, 2, 3, 4, 5]

        list.prepend(contentsOf: -2...0)
        
        XCTAssertEqual(list.count, 8)
        XCTAssertEqual(list, [-2, -1, 0, 1, 2, 3, 4, 5])
    }

    func test_ListWithElements_AfterAppendingNewElement_ContainsElementsFollowedByNewElement() {
        var list: LinkedList = [0, 1, 2, 3, 4]

        list.append(5)

        XCTAssertEqual(list.count, 6)
        XCTAssertEqual(list, [0, 1, 2, 3, 4, 5])
    }

    func test_ListWithElements_AfterAppendingNewElements_ContainsExistingElementFollowedByNewElements() {
        var list: LinkedList = [0, 1, 2, 3, 4]

        list.append(contentsOf: 5...7)
        
        XCTAssertEqual(list.count, 8)
        XCTAssertEqual(list, [0, 1, 2, 3, 4, 5, 6, 7])
    }

    // MARK: Adding Elements to a Copy of a Non-Empty List (Copy-on-Write)

    func test_CopyOfListWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElementAndOriginalIsUnchanged() {
        let original: LinkedList = [1]
        var copy = original

        copy.prepend(0)

        XCTAssertEqual(original.count, 1)
        XCTAssertEqual(original, [1])
        
        XCTAssertEqual(copy.count, 2)
        XCTAssertEqual(copy, [0, 1])
    }
    
    func test_CopyOfListWithOneElement_AfterPrependingElements_ContainsNewElementsFollowedByExistingElementAndOriginalIsUnchanged() {
        let original: LinkedList = [1]
        var copy = original
        
        copy.prepend(contentsOf: -2...0)
        
        XCTAssertEqual(original.count, 1)
        XCTAssertEqual(original, [1])
        
        XCTAssertEqual(copy.count, 4)
        XCTAssertEqual(copy, [-2, -1, 0, 1])
    }

    func test_CopyOfListWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElementAndOriginalIsUnchanged() {
        let original: LinkedList = [0]
        var copy = original

        copy.append(1)
        
        XCTAssertEqual(original.count, 1)
        XCTAssertEqual(original, [0])
        
        XCTAssertEqual(copy.count, 2)
        XCTAssertEqual(copy, [0, 1])
    }

    func test_CopyOfListWithOneElement_AfterAppendingNewElements_ContainsExistingElementFollowedByNewElementsAndOriginalIsUnchanged() {
        let original: LinkedList = [0]
        var copy = original

        copy.append(contentsOf: 1...3)
        
        XCTAssertEqual(original.count, 1)
        XCTAssertEqual(original, [0])
        
        XCTAssertEqual(copy.count, 4)
        XCTAssertEqual(copy, [0, 1, 2, 3])
    }

    func test_CopyOfListWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByElementsAndOriginalIsUnchanged() {
        let original: LinkedList = [1, 2, 3, 4, 5]
        var copy = original

        copy.prepend(0)
        
        XCTAssertEqual(original.count, 5)
        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        
        XCTAssertEqual(copy.count, 6)
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }

    func test_CopyOfListWithElements_AfterPrependingNewElements_ContainsNewElementsFollowedByElementsAndOriginalIsUnchanged() {
        let original: LinkedList = [1, 2, 3, 4, 5]
        var copy = original
        
        copy.prepend(contentsOf: -2...0)

        XCTAssertEqual(original.count, 5)
        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        
        XCTAssertEqual(copy.count, 8)
        XCTAssertEqual(copy, [-2, -1, 0, 1, 2, 3, 4, 5])
    }

    func test_CopyOfListWithElements_AfterAppendingNewElement_ContainsElementsFollowedByNewElementAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4]
        var copy = original

        copy.append(5)
        
        XCTAssertEqual(original.count, 5)
        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        
        XCTAssertEqual(copy.count, 6)
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }

    func test_CopyOFListWithElements_AfterAppendingNewElements_ContainsExistingElementFollowedByNewElementsAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4]
        var copy = original
        
        copy.append(contentsOf: 5...7)

        XCTAssertEqual(original.count, 5)
        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        
        XCTAssertEqual(copy.count, 8)
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5, 6, 7])
    }
}
