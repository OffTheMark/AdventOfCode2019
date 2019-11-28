//
//  DequeRemoveTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class DequeRemoveTests: XCTestCase {
    // MARK: Removing Elements in a Non-Empty Deque

    func test_DequeWithOneElement_AfterRemovingFirst_IsEmpty() {
        var deque: Deque = [0]

        let removed = deque.removeFirst()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(deque.isEmpty)
        XCTAssertEqual(deque, [])
    }

    func test_DequeWithOneElement_AfterRemovingLast_IsEmpty() {
        var deque: Deque = [0]

        let removed = deque.removeLast()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(deque.isEmpty)
        XCTAssertEqual(deque, [])
    }

    func test_DequeWithElements_AfterRemovingFirst_ContainsElementsExceptFirst() {
        var deque: Deque = [0, 1, 2, 3, 4, 5]

        let removed = deque.removeFirst()

        XCTAssertEqual(removed, 0)
        XCTAssertEqual(deque, [1, 2, 3, 4, 5])
    }

    func test_DequeWithElements_AfterRemovingLast_ContainsElementsExceptLast() {
        var deque: Deque = [0, 1, 2, 3, 4, 5]

        let removed = deque.removeLast()

        XCTAssertEqual(removed, 5)
        XCTAssertEqual(deque, [0, 1, 2, 3, 4])
    }

    func test_DequeWithElements_AfterRemovingAll_IsEmpty() {
        var deque: Deque = [0, 1, 2, 3, 4, 5]

        deque.removeAll()

        XCTAssertTrue(deque.isEmpty)
        XCTAssertEqual(deque, [])
    }

    // MARK: Removing Elements in a Copy of a Non-Empty Deque (Copy-on-Write)

    func test_CopyOfDequeWithOneElement_AfterRemovingFirst_IsEmptyAndOriginalIsUnchanged() {
        let original: Deque = [0]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
        XCTAssertEqual(original, [0])
    }

    func test_CopyOfDequeWithOneElement_AfterRemovingLast_IsEmptyAndOriginalIsUnchanged() {
        let original: Deque = [0]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
        XCTAssertEqual(original, [0])
    }

    func test_CopyOfDequeWithElements_AfterRemovingFirst_CopyContainsElementsExceptFirstAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4, 5]
        var copy = original

        let removed = copy.removeFirst()

        XCTAssertEqual(removed, 0)
        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [1, 2, 3, 4, 5])
    }

    func test_CopyOfDequeWithElements_AfterRemovingLast_CopyContainsElementsExceptLastAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4, 5]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 5)
        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4])
    }

    func test_CopyOfDequeWithElements_AfterRemovingAll_IsEmptyAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4, 5]
        var copy = original

        copy.removeAll()

        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
    }
}
