//
//  DequeRotateTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class DequeRotateTests: XCTestCase {
    // MARK: Rotating Elements in an Empty Deque

    func test_EmptyDeque_AfterRotatingLeft_IsEmpty() {
        var empty = Deque<Int>()

        empty.rotateLeft()

        XCTAssertEqual(empty, [])
    }

    func test_EmptyDeque_AfterRotatingRight_IsEmpty() {
        var empty = Deque<Int>()

        empty.rotateRight()

        XCTAssertEqual(empty, [])
    }

    // MARK: Rotating Elements in a Non-Empty Deque

    func test_DequeWithOneElement_AfterRotatingLeft_IsUnchanged() {
        var deque: Deque = [1]

        deque.rotateLeft()

        XCTAssertEqual(deque, [1])
    }

    func test_DequeWithOneElement_AfterRotatingRight_IsUnchanged() {
        var deque: Deque = [1]

        deque.rotateRight()

        XCTAssertEqual(deque, [1])
    }

    func test_DequeWithElements_AfterRotatingLeftTwice_OrderIsChangedAccordingly() {
        var deque: Deque = [0, 1, 2, 3, 4]

        deque.rotateLeft(by: 2)

        XCTAssertEqual(deque, [2, 3, 4, 0, 1])
    }

    func test_DequeWithElements_AfterRotatingRightTwice_OrderIsChangedAccordingly() {
        var deque: Deque = [0, 1, 2, 3, 4]

        deque.rotateRight(by: 2)

        XCTAssertEqual(deque, [3, 4, 0, 1, 2])
    }

    // MARK: Rotating Elements in a Copy of a Non-Empty Deque (Copy-on-Write

    func test_CopyOfDequeWithOneElement_AfterRotatingLeft_IsUnchangedAndOriginalIsUnchanged() {
        let original: Deque = [1]
        var copy = original

        copy.rotateLeft()

        XCTAssertEqual(original, [1])
        XCTAssertEqual(copy, [1])
    }

    func test_CopyOfDequeWithOneElement_AfterRotatingRight_IsUnchangedAndOriginalIsUnchanged() {
        let original: Deque = [1]
        var copy = original

        copy.rotateRight()

        XCTAssertEqual(original, [1])
        XCTAssertEqual(copy, [1])
    }

    func test_CopyOfDequeWithElements_AfterRotatingLeftTwice_OrderIsChangedAccordinglyAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4]
        var copy = original

        copy.rotateLeft(by: 2)

        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        XCTAssertEqual(copy, [2, 3, 4, 0, 1])
    }

    func test_CopyOfDequeWithElements_AfterRotatingRightTwice_OrderIsChangedAccordinglyAndOriginalIsUnchanged() {
        let original: Deque = [0, 1, 2, 3, 4]
        var copy = original

        copy.rotateRight(by: 2)

        XCTAssertEqual(original, [0, 1, 2, 3, 4])
        XCTAssertEqual(copy, [3, 4, 0, 1, 2])
    }
}
