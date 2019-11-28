//
//  BagRemoveTests.swift
//  DataStructuresTests
//
//  Created by Marc-Antoine Malépart on 2019-11-28.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import XCTest
@testable import DataStructures

final class BagRemoveTests: XCTestCase {
    // MARK: Removing Elements in a Non-Empty List

    func test_BagWithOneOfAnItem_AfterRemovingOneOfItem_IsEmpty() {
        var bag: Bag = ["item"]

        let removed = bag.remove("item")

        XCTAssertEqual(removed, 1)
        XCTAssertEqual(bag, [:])
    }

    func test_BagWithMultiplesOfAnItem_AfterRemovingLessThanCountOfItem_ContainsCorrectNumberOfItems() {
        var bag: Bag = ["item": 5]

        let removed = bag.remove("item", count: 2)

        XCTAssertEqual(removed, 2)
        XCTAssertEqual(bag, ["item": 3])
    }

    func test_BagWithMultiplesOfAnItem_AfterRemovingSameNumberOfItem_IsEmpty() {
        var bag: Bag = ["item": 2]

        let removed = bag.remove("item", count: 2)

        XCTAssertEqual(removed, 2)
        XCTAssertEqual(bag, [:])
    }

    func test_BagWithMultiplesOfAnItem_AfterRemovingAllOfItem_IsEmpty() {
        var bag: Bag = ["item": 2]

        let removed = bag.removeAll(of: "item")

        XCTAssertEqual(removed, 2)
        XCTAssertEqual(bag, [:])
    }

    // MARK: 

}
