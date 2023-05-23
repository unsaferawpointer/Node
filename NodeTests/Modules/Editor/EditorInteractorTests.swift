//
//  EditorInteractorTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 23.05.2023.
//

import XCTest
import Hierarchy
@testable import Node

final class EditorInteractorTests: XCTestCase {

	var sut: Editor.Interactor!

	var dataProvider: DataProviderMock!

	var textProcessor: TextProcessorMock!

	override func setUpWithError() throws {
		dataProvider = DataProviderMock()
		textProcessor = TextProcessorMock()
		sut = Editor.Interactor(dataProvider: dataProvider, textProcessor: textProcessor)
	}

	override func tearDownWithError() throws {
		sut = nil
		dataProvider = nil
		textProcessor = nil
	}
}

// MARK: - EditorInteractor test-cases
extension EditorInteractorTests {

	func test_children() {
		// Arrange
		dataProvider.childrenStub = [.default(), .default()]

		// Act
		let items = sut.children(ofItem: nil)

		// Assert
		XCTAssertEqual(items, dataProvider.childrenStub)
	}

	func test_insertItems_whenDestinationIsRoot() {
		// Arrange
		let insertingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		var hasBeenInvoked = false

		// Act
		sut.insertItems(insertingItems, to: .onRoot) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .addItems(items, target) = dataProvider.invocations[0] else {
			return XCTFail("`addItems` should be invoked")
		}

		XCTAssertEqual(items, insertingItems)
		XCTAssertNil(target)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_removeItems() {
		// Arrange
		let removingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		var hasBeenInvoked = false

		// Act
		sut.removeItems(removingItems) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .removeItems(items) = dataProvider.invocations[0] else {
			return XCTFail("`removeItems` should be invoked")
		}

		XCTAssertEqual(items, removingItems)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_moveItems_whenDestinationIsRoot() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		var hasBeenInvoked = false

		// Act
		sut.moveItems(movingItems, to: .onRoot) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .moveItemsToTarget(items, target) = dataProvider.invocations[0] else {
			return XCTFail("`moveItemsToTarget` should be invoked")
		}

		XCTAssertEqual(items, movingItems)
		XCTAssertNil(target)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_moveItemsIntoRootAtIndex() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		var hasBeenInvoked = false

		// Act
		sut.moveItems(movingItems, to: .intoRoot(offset: 1)) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .moveItemsToRoot(items, index) = dataProvider.invocations[0] else {
			return XCTFail("`moveItemsToRoot` should be invoked")
		}

		XCTAssertEqual(items, movingItems)
		XCTAssertEqual(index, 1)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_moveItemsOnTarget() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		let destination: NodeModel = .default()

		var hasBeenInvoked = false

		// Act
		sut.moveItems(movingItems, to: .onTarget(destination)) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .moveItemsToTarget(items, target) = dataProvider.invocations[0] else {
			return XCTFail("`moveItemsToTarget` should be invoked")
		}

		XCTAssertEqual(items, movingItems)
		XCTAssertEqual(destination, target)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_moveItemsIntoTarget() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]
		dataProvider.addItemsStub = []

		let destination: NodeModel = .default()

		var hasBeenInvoked = false

		// Act
		sut.moveItems(movingItems, to: .intoTarget(destination, offset: 1)) { _ in
			hasBeenInvoked = true
		}

		// Assert
		guard case let .moveItemsToTargetAtIndex(items, target, index) = dataProvider.invocations[0] else {
			return XCTFail("`moveItemsToTargetAtIndex` should be invoked")
		}

		XCTAssertEqual(items, movingItems)
		XCTAssertEqual(destination, target)
		XCTAssertEqual(index, 1)
		XCTAssertTrue(hasBeenInvoked)
	}

	func test_canMove() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]
		dataProvider.canMoveStub = true

		let destination: NodeModel = .default()

		// Act
		let result = sut.canMove(movingItems, to: destination)

		// Assert
		XCTAssertTrue(result)
	}
}

// MARK: - Helpers
private extension NodeModel {

	static func `default`() -> NodeModel {
		return .init(isDone: false, text: "")
	}
}
