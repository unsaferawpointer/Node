//
//  TreeTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 22.04.2023.
//

import XCTest
@testable import Node

final class TreeTests: XCTestCase {

	var sut: Tree<ObjectMock>!

	override func setUpWithError() throws {
		sut = Tree()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

}

// MARK: - Insert test-cases
extension TreeTests {

	func test_append_to_empty_tree() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node2 = ObjectMock(id: "2")
		let node3 = ObjectMock(id: "3")

		// Act
		sut.insert([node0, node1, node2, node3], to: nil, at: nil)

		// Assert
		XCTAssertEqual(sut.totalCount, 4)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "1", "2", "3"])
	}

	func test_insert_to_root() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node2 = ObjectMock(id: "2")
		let node3 = ObjectMock(id: "3")

		sut.insert([node0, node1, node2, node3], to: nil, at: nil)

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		// Act
		sut.insert([inserted0, inserted1], to: nil, at: 2)

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "1", "inserted0", "inserted1", "2", "3"])
	}

	func test_append_to_destination() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let node000 = ObjectMock(id: "0-0-0")
		let node001 = ObjectMock(id: "0-0-1")

		sut.insert([node0, node1], to: nil, at: nil)
		sut.insert([node00, node01], to: node0, at: nil)

		// Act
		sut.insert([node000, node001], to: node00, at: nil)

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "0-0-0", "0-0-1", "0-1", "1"])
	}

	func test_insert_to_destination() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let inserted0 = ObjectMock(id: "inserted0")
		let inserted1 = ObjectMock(id: "inserted1")

		sut.insert([node0, node1], to: nil, at: nil)
		sut.insert([node00, node01], to: node0, at: nil)

		// Act
		sut.insert([inserted0, inserted1], to: node0, at: 1)

		// Assert
		XCTAssertEqual(sut.totalCount, 6)
		var identifiers: [String] = []
		sut.enumerateObjects { object in
			identifiers.append(object.id)
		}
		XCTAssertEqual(identifiers, ["0", "0-0", "inserted0", "inserted1", "0-1", "1"])
	}
}

// MARK: - Nested data structs
extension TreeTests {

	final class ObjectMock: ReferenceIdentifiable {

		var id: String

		init(id: String) {
			self.id = id
		}
	}
}
