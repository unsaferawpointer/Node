//
//  BindableTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import XCTest
@testable import Node

final class BindableTests: XCTestCase {

	var sut: Bindable<String>!

	var spy: BindingSpy!

	override func setUpWithError() throws {
		spy = BindingSpy()
		sut = Bindable()
	}

	override func tearDownWithError() throws {
		spy = nil
		sut = nil
	}

}

// MARK: - `Bind` test-cases
extension BindableTests {

	func test_bind_when_initial_value_is_nil() {
		// Act
		sut.bind(\String.self, to: spy, \.value)

		// Assert
		XCTAssertTrue(spy.invocations.isEmpty)
	}

	func test_bind_when_initial_value_is_not_nil() {
		// Arrange
		let initialValue = UUID().uuidString
		sut = Bindable(initialValue)

		// Act
		sut.bind(\String.self, to: spy, \.value)

		// Assert
		XCTAssertEqual(spy.invocations, [.valueHasBeenChanged(initialValue)])
	}
}

// MARK: - `Update` test-cases
extension BindableTests {

	func test_update() {
		// Arrange
		sut.bind(\String.self, to: spy, \.value)

		let newValue = UUID().uuidString

		// Act
		sut.update(with: newValue)

		// Assert
		XCTAssertEqual(spy.invocations, [.valueHasBeenChanged(newValue)])
	}

}

// MARK: - Nested data structs
extension BindableTests {

	final class BindingSpy {

		var invocations: [Action] = []

		var value: String = "" {
			didSet {
				let action: Action = .valueHasBeenChanged(value)
				invocations.append(action)
			}
		}

	}
}

// MARK: - Actions
extension BindableTests.BindingSpy {

	enum Action: Hashable {
		case valueHasBeenChanged(_ value: String)
	}
}
