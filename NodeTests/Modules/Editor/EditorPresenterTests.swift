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

	var interactor: EditorInteractorMock!

	var view: EditorViewSpy!

	override func setUpWithError() throws {
		interactor = EditorInteractorMock()
		view = EditorViewSpy()
		sut = Editor.Presenter(interactor: interactor)
		sut.view = view
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
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
		interactor.childrenStub = [.default(), .default()]

		// Act
		let result = sut.numberOfChildrenOfItem(item: model)

		// Assert
		XCTAssertEqual(result, 2)
	}

	func test_child() {
		// Arrange
		let model: NodeModel = .default()
		let child: NodeModel = .default()

		interactor.childrenStub = [child]

		// Act
		let result = sut.child(index: 0, ofItem: model)

		// Assert
		XCTAssertIdentical(result as AnyObject, child)
	}

	func test_isItemExpandable() {
		// Arrange
		let model: NodeModel = .default()
		interactor.childrenStub = [.default(), .default()]

		// Act
		let result = sut.isItemExpandable(item: model)

		// Assert
		XCTAssertTrue(result)
	}

	func test_canMove() {
		// Arrange
		let items: [NodeModel] = [.default(), .default()]
		let destination: NodeModel = .default()

		interactor.canMoveStub = true

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

		interactor.actionsStub = []

		// Act
		sut.moveItems(movingItems, to: .onTarget(destination))

		// Assert

		guard case let .moveItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`moveItems` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(target, .onTarget(destination))

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

		interactor.actionsStub = []

		// Act
		sut.moveItems(movingItems, to: .intoTarget(destination, offset: 0))

		// Assert
		guard case let .moveItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`moveItems` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(target, .intoTarget(destination, offset: 0))

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

		interactor.actionsStub = []

		// Act
		sut.moveItems(movingItems, to: .onRoot)

		// Assert
		guard case let .moveItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`moveItems` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(target, .onRoot)

		guard case .startUpdating  = view.invocations[0] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case .endUpdating  = view.invocations[1] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(view.invocations.count, 2)
	}

	func test_moveItemsToRootAtIndex() {
		// Arrange
		let movingItems: [NodeModel] = [.default(), .default()]

		interactor.actionsStub = []

		// Act
		sut.moveItems(movingItems, to: .intoRoot(offset: 0))

		// Assert
		guard case let .moveItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`moveItems` must be invocked")
		}

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(target, .intoRoot(offset: 0))

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

		interactor.actionsStub = [.updateItem(first), .insertItems(atIndexes: .init(integer: 0), inParent: first)]

		// Act
		sut.userClickedAddMenuItem()

		// Assert
		guard case let .insertItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`insertItems` must be invocked")
		}

		XCTAssertEqual(items.count, 1)
		XCTAssertEqual(target, .onTarget(first))

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

		interactor.actionsStub = [.updateItem(nil), .insertItems(atIndexes: .init(integer: 0), inParent: nil)]

		// Act
		sut.userClickedAddMenuItem()

		// Assert
		guard case let .insertItems(items, target) = interactor.invocations[0] else {
			return XCTFail("`insertItems` must be invocked")
		}

		XCTAssertEqual(items.count, 1)
		XCTAssertEqual(target, .onRoot)

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

		XCTAssertEqual(view.invocations.count, 4)
	}

	func test_userClickedDeleteMenuItem() {
		// Arrange
		let first = NodeModel(isDone: false, text: "0")
		let second = NodeModel(isDone: false, text: "1")
		view.selectionStub = [first, second]

		// Act
		sut.userClickedDeleteMenuItem()

		// Assert
		guard case let .removeItems(items) = interactor.invocations[0] else {
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
