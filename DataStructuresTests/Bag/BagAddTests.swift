//
//  BagAddTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class BagAddTests: XCTestCase {
    // MARK: Adding Elements to an Empty Bag

    func test_EmptyBag_AfterAddingItem_ContainsOneOfItem() {
        var bag = Bag<String>()

        bag.add("item")

        XCTAssertEqual(bag, ["item": 1])
    }

    func test_EmptyBag_AfterAddingMultiplesOfItem_ContainsCorrectNumberOfItem() {
        var bag = Bag<String>()

        bag.add("item", count: 5)

        XCTAssertEqual(bag, ["item": 5])
    }

    func test_BagWithMultipleOfItemAndOthers_AfterAddingItem_ContainsCorrectCountOfAddedItemAndSameCountOfOthers() {
        var bag: Bag = ["item": 2, "otherItem": 1]

        bag.add("item")

        XCTAssertEqual(bag, ["item": 3, "otherItem": 1])
    }

    func test_BagWithMultiplesOfItemAndOthers_AfterAddingMultiplesOfItem_ContainsCorrectCountOfAddedItemAndSameCountOfOthers() {
        var bag: Bag = ["item": 2, "otherItem": 1]

        bag.add("item", count: 3)

        XCTAssertEqual(bag, ["item": 5, "otherItem": 1])
    }
}
