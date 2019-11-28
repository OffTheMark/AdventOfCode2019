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

        XCTAssertEqual(list, [0])
    }

    func test_EmptyList_AfterAppendingElement_ContainsOnlyElement() {
        var list = LinkedList<Int>()

        list.append(0)

        XCTAssertEqual(list, [0])
    }


    // MARK: Adding Elements to a Non-Empty List

    func test_ListWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElement() {
        var list: LinkedList = [1]

        list.prepend(0)

        XCTAssertEqual(list, [0, 1])
    }

    func test_ListWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElement() {
        var list: LinkedList = [0]

        list.append(1)

        XCTAssertEqual(list, [0, 1])
    }

    func test_ListWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByElements() {
        var list: LinkedList = [1, 2, 3, 4, 5]

        list.prepend(0)

        XCTAssertEqual(list, [0, 1, 2, 3, 4, 5])
    }

    func test_ListWithElements_AfterAppendingNewElement_ContainsElementsFollowedByNewElement() {
        var list: LinkedList = [0, 1, 2, 3, 4]

        list.append(5)

        XCTAssertEqual(list, [0, 1, 2, 3, 4, 5])
    }

    // MARK: Adding Elements to a Copy of a Non-Empty List (Copy-on-Write)

    func test_CopyOfListWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElementAndOriginalIsUnchanged() {
        let original: LinkedList = [1]
        var copy = original

        copy.prepend(0)

        XCTAssertEqual(original, [1])
        XCTAssertEqual(copy, [0, 1])
    }

    func test_CopyOfListWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElementAndOriginalIsUnchanged() {
        let original: LinkedList = [0]
        var copy = original

        copy.append(1)

        XCTAssertEqual(original, [0])
        XCTAssertEqual(copy, [0, 1])
    }

    func test_CopyOfListWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByElementsAndOriginalIsUnchanged() {
        let original: LinkedList = [1, 2, 3, 4, 5]
        var copy = original

        copy.prepend(0)

        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }

    func test_CopyOfListWithElements_AfterAppendingNewElement_ContainsElementsFollowedByNewElementAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4]
        var copy = original

        copy.append(5)

        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }
}
