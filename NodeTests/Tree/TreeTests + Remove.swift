//
//  TreeTests + Remove.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 05.05.2023.
//

import XCTest
@testable import Node

// MARK: - Remove test-cases
extension TreeTests {

	func test_remove_fromRoot() {
		// Arrange

		let object0 = ObjectMock(id: "0")
		let object1 = ObjectMock(id: "1")
		let object2 = ObjectMock(id: "2")
		let object3 = ObjectMock(id: "3")

		var invocations: [Invocation] = []

		sut = Tree {
			object0
			object1
			object2
			object3
		}

		// Act
		sut.remove([object0, object2]) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 2)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}

		XCTAssertEqual(identifiers, ["1", "3"])

		XCTAssertNil(sut.parent(of: object1))
		XCTAssertNil(sut.parent(of: object3))

		XCTAssertEqual(invocations.count, 1)
		XCTAssertNil(invocations[0].object)
		XCTAssertEqual(invocations[0].indexes, .init([0, 2]))
	}

	func test_remove() {
		// Arrange

		let object0 = ObjectMock(id: "0")
		let object01 = ObjectMock(id: "0-1")
		let object001 = ObjectMock(id: "0-0-1")

		sut = Tree {
			Node(object0) {
				Node(ObjectMock(id: "0-0"))
				Node(object01) {
					ObjectMock(id: "0-0-0")
					object001
				}
			}
			Node(ObjectMock(id: "1"))
		}

		var invocations: [Invocation] = []

		// Act
		sut.remove([object01, object001]) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 3)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "1"])

		XCTAssertEqual(invocations.count, 2)
		XCTAssertTrue(invocations.contains {
			$0.indexes == IndexSet(integer: 1) && $0.object === object01
		})

		XCTAssertTrue(invocations.contains {
			$0.indexes == IndexSet(integer: 1) && $0.object === object0
		})
	}

	func test_remove_objectsThatHaveACommonParent() {
		// Arrange

		let object000 = ObjectMock(id: "0-0-0")
		let object001 = ObjectMock(id: "0-0-1")

		sut = Tree {
			Node(ObjectMock(id: "0")) {
				Node(ObjectMock(id: "0-0"))
				Node(ObjectMock(id: "0-1")) {
					object000
					object001
				}
			}
			Node(ObjectMock(id: "1"))
		}

		var invocations: [Invocation] = []

		// Act
		sut.remove([object000, object001]) { indexes, parent in
			let invocation = Invocation(indexes: indexes, object: parent)
			invocations.append(invocation)
		}

		// Assert
		XCTAssertEqual(sut.totalCount, 4)

		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "0-1", "1"])

		XCTAssertEqual(invocations.count, 1)
		XCTAssertEqual(invocations[0].indexes, .init([0, 1]))
	}
}

// MARK: Nested data structs
private extension TreeTests {

	struct Invocation {
		var indexes: IndexSet
		var object: ObjectMock?
	}
}
