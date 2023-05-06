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
		let object0 = ObjectMock(id: "0")
		let object1 = ObjectMock(id: "1")
		let object2 = ObjectMock(id: "2")
		let object3 = ObjectMock(id: "3")

		var invocations: [Invocation] = []

		// Act
		sut.insert([object0, object1, object2, object3], to: nil, at: nil) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 4)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}

		XCTAssertNil(sut.parent(of: object0))
		XCTAssertNil(sut.parent(of: object1))
		XCTAssertNil(sut.parent(of: object2))
		XCTAssertNil(sut.parent(of: object3))

		XCTAssertEqual(invocations[0].indexes, IndexSet([0, 1, 2, 3]))
		XCTAssertNil(invocations[0].object)
	}

	func test_insert_to_root() {
		// Arrange
		let object0 = ObjectMock(id: "0")
		let object1 = ObjectMock(id: "1")
		let object2 = ObjectMock(id: "2")
		let object3 = ObjectMock(id: "3")

		sut = Tree {
			object0
			object1
			object2
			object3
		}

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		var invocations: [Invocation] = []

		// Act
		sut.insert([inserted0, inserted1], to: nil, at: 2) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "1", "inserted0", "inserted1", "2", "3"])

		XCTAssertNil(sut.parent(of: object0))
		XCTAssertNil(sut.parent(of: object1))
		XCTAssertNil(sut.parent(of: object2))
		XCTAssertNil(sut.parent(of: object3))
		XCTAssertNil(sut.parent(of: inserted0))
		XCTAssertNil(sut.parent(of: inserted1))

		XCTAssertNil(invocations[0].object)
		XCTAssertEqual(invocations[0].indexes, IndexSet([2, 3]))
	}

	func test_append_to_destination() {
		// Arrange

		let object0 = ObjectMock(id: "0")
		let object00 = ObjectMock(id: "0-0")
		let object000 = ObjectMock(id: "0-0-0")
		let object001 = ObjectMock(id: "0-0-1")
		let object01 = ObjectMock(id: "0-1")
		let object1 = ObjectMock(id: "1")

		sut = Tree {
			Node(object0) {
				Node(object00)
				Node(object01)
			}
			Node(object1)
		}

		var invocations: [Invocation] = []

		// Act
		sut.insert([object000, object001], to: object00, at: nil) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "0-0-0", "0-0-1", "0-1", "1"])

		XCTAssertNil(sut.parent(of: object0))
		XCTAssertNil(sut.parent(of: object1))
		XCTAssertIdentical(sut.parent(of: object00), object0)
		XCTAssertIdentical(sut.parent(of: object01), object0)
		XCTAssertIdentical(sut.parent(of: object000), object00)
		XCTAssertIdentical(sut.parent(of: object001), object00)

		XCTAssertEqual(invocations[0].indexes, IndexSet([0, 1]))
		XCTAssertIdentical(invocations[0].object, object00)
	}

	func test_insert_to_destination() {
		// Arrange

		let object0 = ObjectMock(id: "0")
		let object00 = ObjectMock(id: "0-0")
		let object01 = ObjectMock(id: "0-1")
		let object1 = ObjectMock(id: "1")

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		var invocations: [Invocation] = []

		sut = Tree {
			Node(object0) {
				object00
				object01
			}
			Node(object1)
		}

		// Act
		sut.insert([inserted0, inserted1], to: object0, at: 1) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "inserted0", "inserted1", "0-1", "1"])

		XCTAssertNil(sut.parent(of: object0))
		XCTAssertNil(sut.parent(of: object1))
		XCTAssertIdentical(sut.parent(of: object00), object0)
		XCTAssertIdentical(sut.parent(of: object01), object0)
		XCTAssertIdentical(sut.parent(of: inserted0), object0)
		XCTAssertIdentical(sut.parent(of: inserted1), object0)

		XCTAssertEqual(invocations[0].indexes, IndexSet([1, 2]))
		XCTAssertIdentical(invocations[0].object, object0)
	}
}

// MARK: Nested data structs
private extension TreeTests {

	struct Invocation {
		var indexes: IndexSet
		var object: ObjectMock?
	}
}
