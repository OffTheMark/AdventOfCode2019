//
//  LinkedListSubscriptTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-27.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class LinkedListSubscriptTests: XCTestCase {
    // MARK:

    func test_ListWithElements_AfterSettingElementAtSubscriptToNewValue_ContainsExistingElementsWithElementAtSubscriptChanged() {
        var list: LinkedList = [1, 2, 3, 4, 5]

        list[2] = 6

        XCTAssertEqual(list, [1, 2, 6, 4, 5])
    }

    func test_CopyOfListWithElements_AfterSettingElementAtSubscriptToNewValue_ContainsExistingElementsWithElementAtSubscriptChangedAndOriginalIsUnchanged() {
        let original: LinkedList = [1, 2, 3, 4, 5]
        var copy = original

        copy[2] = 6

        XCTAssertEqual(original, [1, 2, 3, 4, 5])
        XCTAssertEqual(copy, [1, 2, 6, 4, 5])
    }

}
