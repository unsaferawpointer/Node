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
		XCTAssertEqual(view.invocations, [.reloadData])
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

private extension Editor.NodeModel {

	static func `default`() -> Editor.NodeModel {
		return .init(isDone: false, text: "")
	}
}
