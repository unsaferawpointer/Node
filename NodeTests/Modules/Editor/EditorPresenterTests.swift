//
//  EditorPresenterTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import XCTest
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
		let model: Editor.NodeModel = .default()
		let numberOfChildren = Int.random(in: 0..<100)
		dataProvider.numberOfChildrenOfModelStub = numberOfChildren

		// Act
		let result = sut.numberOfChildrenOfItem(item: model)

		// Assert
		XCTAssertEqual(result, numberOfChildren)
	}

	func test_child() {
		// Arrange
		let model: Editor.NodeModel = .default()
		let child: Editor.NodeModel = .default()

		dataProvider.childStub = child

		// Act
		let result = sut.child(index: 0, ofItem: model)

		// Assert
		XCTAssertIdentical(result as AnyObject, child)
	}

	func test_isItemExpandable() {
		// Arrange
		let model: Editor.NodeModel = .default()
		dataProvider.numberOfChildrenOfModelStub = 2

		// Act
		let result = sut.isItemExpandable(item: model)

		// Assert
		XCTAssertTrue(result)
	}

	func test_viewModel() throws {
		// Arrange
		let model: Editor.NodeModel = .default()

		// Act
		let result = sut.viewModel(for: UUID().uuidString, item: model)

		// Assert
		let configuration = try XCTUnwrap(result as? CheckboxConfiguration)
		XCTAssertIdentical(configuration.value, model.isDone)
		XCTAssertIdentical(configuration.title, model.text)
	}
}

// MARK: - EditorPresenter test-cases
extension EditorPresenterTests {

	func test_userClickedAddMenuItem() {
		// Arrange
		let first = Editor.NodeModel(isDone: false, text: "0")
		view.selectionStub = [first, Editor.NodeModel(isDone: false, text: "1")]

		dataProvider.insertionStub = (IndexSet([0, 2]), first)

		// Act
		sut.userClickedAddMenuItem()

		// Assert
		guard case let .insert(models, destination, index) = dataProvider.invocations.first else {
			return XCTFail("`Insert` must be invocked")
		}

		XCTAssertEqual(models.count, 1)
		XCTAssertIdentical(first, destination)
		XCTAssertNil(index)

		guard case .getSelection = view.invocations[0] else {
			return XCTFail("`getSelection` must be invocked")
		}

		guard case let .insert(insertionIndexes, insertionDestination) = view.invocations[1] else {
			return XCTFail("`Insert` must be invocked")
		}

		XCTAssertEqual(insertionIndexes, IndexSet([0, 2]))
		XCTAssertIdentical(insertionDestination as? AnyObject, first)

		guard case let .expand(expandedObject, animate) = view.invocations[2] else {
			return XCTFail("`expand` must be invocked")
		}

		XCTAssertIdentical(expandedObject, first)
		XCTAssertTrue(animate)
		XCTAssertEqual(view.invocations.count, 3)
	}

	func test_userClickedDeleteMenuItem_whenParentIsNil() {
		// Arrange
		let first = Editor.NodeModel(isDone: false, text: "0")
		let second = Editor.NodeModel(isDone: false, text: "1")
		view.selectionStub = [first, second]

		dataProvider.deletionStub = (IndexSet([0, 1]), nil)

		// Act
		sut.userClickedDeleteMenuItem()

		// Assert
		guard case let .remove(models) = dataProvider.invocations.first else {
			return XCTFail("`Remove` must be invocked")
		}

		XCTAssertEqual(models.count, 2)
		XCTAssertIdentical(models[0], first)
		XCTAssertIdentical(models[1], second)

		guard case .getSelection = view.invocations[0] else {
			return XCTFail("`getSelection` must be invocked")
		}

		guard case .startUpdating = view.invocations[1] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case let .remove(deletionIndexes, parent) = view.invocations[2] else {
			return XCTFail("`Remove` must be invocked")
		}

		XCTAssertEqual(deletionIndexes, IndexSet([0, 1]))
		XCTAssertNil(parent)

		guard case .endUpdating = view.invocations[3] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(view.invocations.count, 4)
	}

	func test_userClickedDeleteMenuItem_whenParentIsNotNil() throws {
		// Arrange
		let source = Editor.NodeModel(isDone: false, text: "0")
		let child = Editor.NodeModel(isDone: false, text: "0-0")
		view.selectionStub = [child]

		dataProvider.deletionStub = (IndexSet([0]), source)

		// Act
		sut.userClickedDeleteMenuItem()

		// Assert
		guard case let .remove(models) = dataProvider.invocations.first else {
			return XCTFail("`Remove` must be invocked")
		}

		XCTAssertEqual(models.count, 1)
		XCTAssertIdentical(models[0], child)

		guard case .getSelection = view.invocations[0] else {
			return XCTFail("`getSelection` must be invocked")
		}

		guard case .startUpdating = view.invocations[1] else {
			return XCTFail("`startUpdating` must be invocked")
		}

		guard case let .remove(deletionIndexes, parent) = view.invocations[2] else {
			return XCTFail("`Remove` must be invocked")
		}

		XCTAssertEqual(deletionIndexes, IndexSet([0]))
		XCTAssertIdentical(parent as? AnyObject, source)

		guard case let .update(object) = view.invocations[3] else {
			return XCTFail("`Update` must be invocked")
		}

		XCTAssertIdentical(object as? AnyObject, source)

		guard case .endUpdating = view.invocations[4] else {
			return XCTFail("`endUpdating` must be invocked")
		}

		XCTAssertEqual(view.invocations.count, 5)
	}
}

private extension Editor.NodeModel {

	static func `default`() -> Editor.NodeModel {
		return .init(isDone: false, text: "")
	}
}
