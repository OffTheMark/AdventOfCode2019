//
//  DequeAddTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class DequeAddTests: XCTestCase {
    // MARK: Adding Elements to an Empty Deque

    func test_EmptyDeque_AfterPrependingElement_ContainsOnlyElement() {
        var deque = Deque<Int>()

        deque.prepend(0)

        XCTAssertEqual(deque, [0])
    }

    func test_EmptyDeque_AfterAppendingElement_ContainsOnlyElement() {
        var deque = Deque<Int>()

        deque.append(0)

        XCTAssertEqual(deque, [0])
    }

    // MARK: Adding Elements to a Non-Empty Deque

    func test_DequeWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElement() {
        var deque: Deque = [1]

        deque.prepend(0)

        XCTAssertEqual(deque, [0, 1])
    }

    func test_DequeWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElement() {
        var deque: Deque = [1]

        deque.append(2)

        XCTAssertEqual(deque, [1, 2])
    }

    func test_DequeWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElements() {
        var deque: Deque = [1, 2, 3, 4, 5]

        deque.prepend(0)

        XCTAssertEqual(deque, [0, 1, 2, 3, 4, 5])
    }

    func test_DequeWithElements_AfterAppendingNewElement_ContainsExistingElementsFollowedByNewElement() {
        var deque: Deque = [0, 1, 2, 3, 4]

        deque.append(5)

        XCTAssertEqual(deque, [0, 1, 2, 3, 4, 5])
    }

    // MARK: Adding Elements to a Copy of a Non-Empty List (Copy-on-Write)

    func test_CopyOfDequeWithOneElement_AfterPrependingNewElement_ContainsNewElementFollowedByExistingElementAndOriginalIsUnchanged() {
        let original: Deque = [1]
        var copy = original

        copy.prepend(0)

        XCTAssertEqual(original, [1])
        XCTAssertEqual(copy, [0, 1])
    }

    func test_CopyOfDequeWithOneElement_AfterAppendingNewElement_ContainsExistingElementFollowedByNewElementAndOriginalIsUnchanged() {
        let original: Deque = [0]
        var copy = original

        copy.append(1)

        XCTAssertEqual(original, [0])
        XCTAssertEqual(copy, [0, 1])
    }

    func test_CopyOfDequeWithElements_AfterPrependingNewElement_ContainsNewElementFollowedByElementsAndOriginalIsUnchanged() {
        let original: Deque = [1, 2, 3, 4, 5]
        var copy = original

        copy.prepend(0)

        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }

    func test_CopyOfDequeWithElements_AfterAppendingNewElement_ContainsElementsFollowedByNewElementAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4]
        var copy = original

        copy.append(5)

        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4, 5])
    }
}
