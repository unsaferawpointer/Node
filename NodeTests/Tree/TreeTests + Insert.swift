//
//  TreeTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 22.04.2023.
//

import XCTest
@testable import Node

// MARK: - Insert test-cases
extension TreeTests {

	func test_append_to_empty_tree() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node2 = ObjectMock(id: "2")
		let node3 = ObjectMock(id: "3")

		var destination: ObjectMock?
		var indexSet: IndexSet?

		// Act
		sut.insert([node0, node1, node2, node3], to: nil, at: nil) { indexes, object in
			indexSet = indexes
			destination = object
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 4)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}

		XCTAssertNil(sut.parent(of: node0))
		XCTAssertNil(sut.parent(of: node1))
		XCTAssertNil(sut.parent(of: node2))
		XCTAssertNil(sut.parent(of: node3))

		XCTAssertNil(destination)
		XCTAssertEqual(indexSet, .init([0, 1, 2, 3]))
	}

	func test_insert_to_root() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node2 = ObjectMock(id: "2")
		let node3 = ObjectMock(id: "3")

		sut.insert([node0, node1, node2, node3], to: nil, at: nil, handler: { _, _ in })

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		var parent: ObjectMock?
		var indexSet: IndexSet?

		// Act
		sut.insert([inserted0, inserted1], to: nil, at: 2) { indexes, object in
			parent = object
			indexSet = indexes
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "1", "inserted0", "inserted1", "2", "3"])

		XCTAssertNil(sut.parent(of: node0))
		XCTAssertNil(sut.parent(of: node1))
		XCTAssertNil(sut.parent(of: node2))
		XCTAssertNil(sut.parent(of: node3))
		XCTAssertNil(sut.parent(of: inserted0))
		XCTAssertNil(sut.parent(of: inserted1))

		XCTAssertNil(parent)
		XCTAssertEqual(indexSet, IndexSet([2, 3]))
	}

	func test_append_to_destination() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let node000 = ObjectMock(id: "0-0-0")
		let node001 = ObjectMock(id: "0-0-1")

		sut.insert([node0, node1], to: nil, at: nil, handler: { _, _ in })
		sut.insert([node00, node01], to: node0, at: nil, handler: { _, _ in })

		var parent: ObjectMock?
		var indexSet: IndexSet?

		// Act
		sut.insert([node000, node001], to: node00, at: nil) { indexes, object in
			parent = object
			indexSet = indexes
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "0-0-0", "0-0-1", "0-1", "1"])

		XCTAssertNil(sut.parent(of: node0))
		XCTAssertNil(sut.parent(of: node1))
		XCTAssertIdentical(sut.parent(of: node00), node0)
		XCTAssertIdentical(sut.parent(of: node01), node0)
		XCTAssertIdentical(sut.parent(of: node000), node00)
		XCTAssertIdentical(sut.parent(of: node001), node00)

		XCTAssertEqual(indexSet, IndexSet([0, 1]))
		XCTAssertIdentical(parent, node00)

	}

	func test_insert_to_destination() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		sut.insert([node0, node1], to: nil, at: nil, handler: {_, _ in })
		sut.insert([node00, node01], to: node0, at: nil, handler: { _, _ in })

		var parent: ObjectMock?
		var indexSet: IndexSet?

		// Act
		sut.insert([inserted0, inserted1], to: node0, at: 1) { indexes, object in
			parent = object
			indexSet = indexes
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "inserted0", "inserted1", "0-1", "1"])

		XCTAssertNil(sut.parent(of: node0))
		XCTAssertNil(sut.parent(of: node1))
		XCTAssertIdentical(sut.parent(of: node00), node0)
		XCTAssertIdentical(sut.parent(of: node01), node0)
		XCTAssertIdentical(sut.parent(of: inserted0), node0)
		XCTAssertIdentical(sut.parent(of: inserted1), node0)

		XCTAssertEqual(indexSet, IndexSet([1, 2]))
		XCTAssertIdentical(parent, node0)
	}
}
