//
//  DequeAccessElementsTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class DequeAccessElementsTests: XCTestCase {
    // MARK: Get Element at Position

    func test_DequeWithOneElement_WhenGettingFirstAndLast_ReturnsElement() {
        let deque: Deque = [0]

        XCTAssertEqual(deque.first, 0)
        XCTAssertEqual(deque.last, 0)
    }

    func test_DequeWithElements_WhenGettingFirst_ReturnsExpectedElement() {
        let deque: Deque = [4, 3, 2, 1, 0]

        XCTAssertEqual(deque.first, 4)
    }

    func test_DequeWithElements_WhenGettingLast_ReturnsExpectedElement() {
        let deque: Deque = [4, 3, 2, 1, 0]

        XCTAssertEqual(deque.last, 0)
    }

    func test_DequeWithElements_WhenGettingElementByIndex_ReturnsExpectedElements() {
        let deque: Deque = [4, 3, 2, 1, 0]

        XCTAssertEqual(deque[0], 4)
        XCTAssertEqual(deque[1], 3)
        XCTAssertEqual(deque[2], 2)
        XCTAssertEqual(deque[3], 1)
        XCTAssertEqual(deque[4], 0)
    }

    // MARK: Set Element at Position

    func test_DequeWithElements_AfterSettingElementAtSubscriptToNewValue_ContainsExistingElementsWithElementAtSubscriptChanged() {
        var deque: Deque = [1, 2, 3, 4, 5]

        deque[2] = 6

        XCTAssertEqual(deque, [1, 2, 6, 4, 5])
    }

    func test_CopyOfDequeWithElements_AfterSettingElementAtSubscriptToNewValue_ContainsExistingElementsWithElementAtSubscriptChangedAndOriginalIsUnchanged() {
        let original: Deque = [1, 2, 3, 4, 5]
        var copy = original

        copy[2] = 6

        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [1, 2, 6, 4, 5])
    }
}
