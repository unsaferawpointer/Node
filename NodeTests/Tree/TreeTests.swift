//
//  TreeTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 24.04.2023.
//

import XCTest
@testable import Node

final class TreeTests: XCTestCase {

	var sut: Tree<ObjectMock>!

	var delegate: TreeDelegateSpy!

	override func setUpWithError() throws {
		delegate = TreeDelegateSpy()
		sut = Tree()
		sut.delegate = delegate
	}

	override func tearDownWithError() throws {
		sut = nil
		delegate = nil
	}

}

// MARK: - NumberOfChildren test-cases
extension TreeTests {

	func test_numberOfChildren() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let node000 = ObjectMock(id: "0-0-0")
		let node001 = ObjectMock(id: "0-0-1")

		sut.insert([node0, node1], to: nil, at: nil)
		sut.insert([node00, node01], to: node0, at: nil)
		sut.insert([node000, node001], to: node00, at: nil)

		// Act
		let result = sut.numberOfChildren(of: node00)

		// Assert
		XCTAssertEqual(result, 2)
	}

	func test_numberOfChildren_when_children_is_root_elements() {
		// Arrange
		let node0 = ObjectMock(id: "0")
		let node1 = ObjectMock(id: "1")
		let node00 = ObjectMock(id: "0-0")
		let node01 = ObjectMock(id: "0-1")

		let node000 = ObjectMock(id: "0-0-0")
		let node001 = ObjectMock(id: "0-0-1")

		sut.insert([node0, node1], to: nil, at: nil)
		sut.insert([node00, node01], to: node0, at: nil)
		sut.insert([node000, node001], to: node00, at: nil)

		// Act
		let result = sut.numberOfChildren(of: nil)

		// Assert
		XCTAssertEqual(result, 2)
	}
}

// MARK: - Nested data structs
extension TreeTests {


}

final class TreeDelegateSpy: TreeDelegate {

	var invocations: [Action] = []

	enum Action {
		case treeInsertedNewObjects(indexSet: IndexSet, parent: AnyObject?)
	}

	func treeInsertedNewObjects(to indexSet: IndexSet, in parent: AnyObject?) {
		let action: Action = .treeInsertedNewObjects(indexSet: indexSet, parent: parent)
		invocations.append(action)
	}
}
