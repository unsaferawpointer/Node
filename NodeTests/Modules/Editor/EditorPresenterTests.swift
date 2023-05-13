//
//  EditorPresenterTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import XCTest
import Hierarchy
@testable import Node

final class EditorPresenterTests: XCTestCase {

	var sut: Editor.Presenter!

	var dataProvider: DataProviderMock!

	var view: EditorViewSpy!

	override func setUpWithError() throws {
		dataProvider = DataProviderMock()
		view = EditorViewSpy()
		sut = Editor.Presenter(dataProvider: dataProvider)
		sut.view = view
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		dataProvider = nil
	}
}

// MARK: - ViewControllerOutput test-cases
extension EditorPresenterTests {

	func test_viewControllerDidChangeState_whenStateIsDidLoad() {
		// Act
		sut.viewControllerDidChangeState(.didLoad)

		// Assert
		guard case .reloadData = view.invocations.first else {
			return XCTFail("`reloadData must be invocked`")
		}
		XCTAssertEqual(view.invocations.count, 1)
	}

	func test_viewControllerDidChangeState_whenStateIsNotDidLoad() {
		// Act
		sut.viewControllerDidChangeState(.willAppear)

		// Assert
		XCTAssertTrue(view.invocations.isEmpty)
	}
}

// MARK: - EditorTableAdapter test-cases
extension EditorPresenterTests {

	func test_numberOfChildrenOfItem() {
		// Arrange
		let model: NodeModel = .default()
		let numberOfChildren = Int.random(in: 0..<100)
		dataProvider.numberOfChildrenOfItemStub = numberOfChildren

		// Act
		let result = sut.numberOfChildrenOfItem(item: model)

		// Assert
		XCTAssertEqual(result, numberOfChildren)
	}

	func test_child() {
		// Arrange
		let model: NodeModel = .default()
		let child: NodeModel = .default()

		dataProvider.childOfItemStub = child

		// Act
		let result = sut.child(index: 0, ofItem: model)

		// Assert
		XCTAssertIdentical(result as AnyObject, child)
	}

	func test_isItemExpandable() {
		// Arrange
		let model: NodeModel = .default()
		dataProvider.numberOfChildrenOfItemStub = 2

		// Act
		let result = sut.isItemExpandable(item: model)

		// Assert
		XCTAssertTrue(result)
	}

	func test_canMove() {
		// Arrange
		let items: [NodeModel] = [.default(), .default()]
		let destination: NodeModel = .default()

		dataProvider.canMoveStub = true

		// Act
		let result = sut.canMove(items, to: destination)

		// Assert
		XCTAssertTrue(result)
	}

	func test_viewModel() throws {
		// Arrange
		let model: NodeModel = .default()

		// Act
		let result = sut.viewModel(for: UUID().uuidString, item: model)

		// Assert
		let configuration = try XCTUnwrap(result as? CheckboxConfiguration)
		XCTAssertIdentical(configuration.value, model.isDone)
		XCTAssertIdentical(configuration.title, model.text)
	}

	func test_moveItemsToTarget() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]

		let destination: NodeModel = .default()

		dataProvider.moveItemsToTargetStub = []

		// Act
		sut.moveItems(movingItems, to: destination)

		// Assert
		guard case let .moveItemsToTarget(items, target) = dataProvider.invocations.first else {
			return XCTFail("`moveItemsToTarget` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertIdentical(target, destination)

		guard case .startUpdating  = view.invocations[0] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case .endUpdating  = view.invocations[1] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		guard case let .expand(expandedObject, animate) = view.invocations[2] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertIdentical(expandedObject, destination)
		XCTAssertTrue(animate)

		XCTAssertEqual(view.invocations.count, 3)
	}

	func test_moveItemsToTargetAtIndex() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]

		let destination: NodeModel = .default()

		dataProvider.moveItemsToTargetStub = []

		// Act
		sut.moveItems(movingItems, to: destination, at: 0)

		// Assert
		guard case let .moveItemsToTargetAtIndex(items, target, index) = dataProvider.invocations.first else {
			return XCTFail("`moveItemsToTarget` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertIdentical(target, destination)
		XCTAssertEqual(index, 0)

		guard case .startUpdating  = view.invocations[0] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case .endUpdating  = view.invocations[1] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		guard case let .expand(expandedObject, animate) = view.invocations[2] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertIdentical(expandedObject, destination)
		XCTAssertTrue(animate)

		XCTAssertEqual(view.invocations.count, 3)
	}

	func test_moveItemsToRoot() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]

		dataProvider.moveItemsToTargetStub = []

		// Act
		sut.moveItems(movingItems, to: nil)

		// Assert
		guard case let .moveItemsToTarget(items, target) = dataProvider.invocations.first else {
			return XCTFail("`moveItemsToTarget` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertNil(target)

		guard case .startUpdating  = view.invocations[0] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case .endUpdating  = view.invocations[1] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		guard case let .expand(expandedObject, animate) = view.invocations[2] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertNil(expandedObject)
		XCTAssertTrue(animate)

		XCTAssertEqual(view.invocations.count, 3)
	}

	func test_moveItemsToRootAtIndex() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]

		dataProvider.moveItemsToRootStub = []

		// Act
		sut.moveItemsToRoot(movingItems, at: 0)

		// Assert
		guard case let .moveItemsToRoot(items, index) = dataProvider.invocations.first else {
			return XCTFail("`moveItemsToTarget` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(index, 0)

		guard case .startUpdating  = view.invocations[0] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case .endUpdating  = view.invocations[1] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(view.invocations.count, 2)
	}
}

// MARK: - EditorPresenter test-cases
extension EditorPresenterTests {

	func test_userClickedAddMenuItem_whenSelectionIsNotEmpty() {
		// Arrange
		let first = NodeModel(isDone: false, text: "0")
		view.selectionStub = [first, NodeModel(isDone: false, text: "1")]

		dataProvider.addItemsStub = [.updateItem(first), .insertItems(atIndexes: .init(integer: 0), inParent: first)]

		// Act
		sut.userClickedAddMenuItem()

		// Assert
		guard case let .addItems(items, target) = dataProvider.invocations.first else {
			return XCTFail("`addItems` must be invocked")
		}

		XCTAssertEqual(items.count, 1)
		XCTAssertIdentical(first, target)

		guard case .getSelection = view.invocations[0] else {
			return XCTFail("`getSelection` must be invocked")
		}

		guard case .startUpdating  = view.invocations[1] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case let .update(updatedItem) = view.invocations[2] else {
			return XCTFail("`update` must be invocked")
		}

		XCTAssertIdentical(updatedItem as? AnyObject, first)

		guard case let .insert(insertionIndexes, insertionDestination) = view.invocations[3] else {
			return XCTFail("`Insert` must be invocked")
		}

		guard case .endUpdating  = view.invocations[4] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(insertionIndexes, .init(integer: 0))
		XCTAssertIdentical(insertionDestination as? AnyObject, first)

		guard case let .expand(expandedObject, animate) = view.invocations[5] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertIdentical(expandedObject, first)
		XCTAssertTrue(animate)
		XCTAssertEqual(view.invocations.count, 6)
	}

	func test_userClickedAddMenuItem_whenSelectionIsEmpty() {
		// Arrange
		view.selectionStub = []

		dataProvider.addItemsStub = [.updateItem(nil), .insertItems(atIndexes: .init(integer: 0), inParent: nil)]

		// Act
		sut.userClickedAddMenuItem()

		// Assert
		guard case let .addItems(items, target) = dataProvider.invocations.first else {
			return XCTFail("`addItems` must be invocked")
		}

		XCTAssertEqual(items.count, 1)
		XCTAssertNil(target)

		guard case .getSelection = view.invocations[0] else {
			return XCTFail("`getSelection` must be invocked")
		}

		guard case .startUpdating  = view.invocations[1] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case let .insert(insertionIndexes, insertionDestination) = view.invocations[2] else {
			return XCTFail("`Insert` must be invocked")
		}

		guard case .endUpdating  = view.invocations[3] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(insertionIndexes, .init(integer: 0))
		XCTAssertNil(insertionDestination)

		guard case let .expand(expandedObject, animate) = view.invocations[4] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertNil(expandedObject)
		XCTAssertTrue(animate)
		XCTAssertEqual(view.invocations.count, 5)
	}

	func test_userClickedDeleteMenuItem() {
		// Arrange
		let first = NodeModel(isDone: false, text: "0")
		let second = NodeModel(isDone: false, text: "1")
		view.selectionStub = [first, second]

		// Act
		sut.userClickedDeleteMenuItem()

		// Assert
		guard case let .removeItems(items) = dataProvider.invocations.first else {
			return XCTFail("`removeItems` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertIdentical(items[0], first)
		XCTAssertIdentical(items[1], second)
	}
}

private extension NodeModel {

	static func `default`() -> NodeModel {
		return .init(isDone: false, text: "")
	}
}
