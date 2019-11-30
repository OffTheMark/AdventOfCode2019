//
//  LinkedListRemoveTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-27.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class LinkedListRemoveTests: XCTestCase {
    // MARK: Removing Elements in an Empty List
    
    func test_EmptyList_AfterRemovingAll_isEmpty() {
        var list = LinkedList<Int>()
        
        list.removeAll()
        
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }
    
    // MARK: Removing Elements in Non-Empty List

    func test_ListWithOneElement_AfterRemovingFirst_IsEmpty() {
        var list: LinkedList = [0]

        let removed = list.removeFirst()

        XCTAssertEqual(removed, 0)
        
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }

    func test_ListWithOneElement_AfterRemovingLast_IsEmpty() {
        var list: LinkedList = [0]

        let removed = list.removeLast()

        XCTAssertEqual(removed, 0)
        
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }

    func test_ListWithElements_AfterRemovingFirst_ContainsElementsExceptFirst() {
        var list: LinkedList = [0, 1, 2, 3, 4, 5]

        let removed = list.removeFirst()

        XCTAssertEqual(removed, 0)
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list, [1, 2, 3, 4, 5])
    }

    func test_ListWithElements_AfterRemovingLast_ContainsElementsExceptLast() {
        var list: LinkedList = [0, 1, 2, 3, 4, 5]

        let removed = list.removeLast()

        XCTAssertEqual(removed, 5)
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list, [0, 1, 2, 3, 4])
    }

    func test_ListWithElements_AfterRemovingAll_IsEmpty() {
        var list: LinkedList = [0, 1, 2, 3, 4, 5]

        list.removeAll()

        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }

    // MARK: Removing Elements in a Copy of a Non-Empty List (Copy-on-Write)

    func test_CopyOfListWithOneElement_AfterRemovingFirst_IsEmptyAndOriginalIsUnchanged() {
        let original: LinkedList = [0]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
        XCTAssertEqual(original, [0])
    }

    func test_CopyOfListWithOneElement_AfterRemovingLast_IsEmptyAndOriginalIsUnchanged() {
        let original: LinkedList = [0]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 0)
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
        XCTAssertEqual(original, [0])
    }

    func test_CopyOfListWithElements_AfterRemovingFirst_CopyContainsElementsExceptFirstAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4, 5]
        var copy = original

        let removed = copy.removeFirst()

        XCTAssertEqual(removed, 0)
        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [1, 2, 3, 4, 5])
    }

    func test_CopyOfListWithElements_AfterRemovingLast_CopyContainsElementsExceptLastAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4, 5]
        var copy = original

        let removed = copy.removeLast()

        XCTAssertEqual(removed, 5)
        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [0, 1, 2, 3, 4])
    }

    func test_CopyOfListWithElements_AfterRemovingAll_IsEmptyAndOriginalIsUnchanged() {
        let original: LinkedList = [0, 1, 2, 3, 4, 5]
        var copy = original

        copy.removeAll()

        XCTAssertEqual(original, [0, 1, 2, 3, 4, 5])
        XCTAssertTrue(copy.isEmpty)
        XCTAssertEqual(copy, [])
    }
}
