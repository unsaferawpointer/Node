//
//  Tree + NodeTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import XCTest
@testable import Node

final class TreeNodeTests: XCTestCase {

	var sut: Node<ObjectMock>!

	override func setUpWithError() throws {
		sut = Node<ObjectMock>(.init(id: "0"))
	}

	override func tearDownWithError() throws {
		sut = nil
	}

}

// MARK: - Insert test-cases
extension TreeNodeTests {

	func test_append() {
		// Arrange
		let nodes: [Node<ObjectMock>] = [
															.init(.init(id: "0")),
															.init(.init(id: "1")),
															.init(.init(id: "2")),
															.init(.init(id: "3"))
														 ]

		// Act
		sut.appendToChildren(nodes)

		// Assert
		XCTAssertIdentical(sut, nodes[0].parent)
		XCTAssertIdentical(sut, nodes[1].parent)
		XCTAssertIdentical(sut, nodes[2].parent)
		XCTAssertIdentical(sut, nodes[3].parent)
	}

	func test_insert() {
		// Arrange
		let nodes: [Node<ObjectMock>] = [
															.init(.init(id: "0")),
															.init(.init(id: "1")),
															.init(.init(id: "2")),
															.init(.init(id: "3"))
														 ]

		// Act
		sut.insertToChildren(nodes, at: 0)

		// Assert
		XCTAssertIdentical(sut, nodes[0].parent)
		XCTAssertIdentical(sut, nodes[1].parent)
		XCTAssertIdentical(sut, nodes[2].parent)
		XCTAssertIdentical(sut, nodes[3].parent)
	}
}
