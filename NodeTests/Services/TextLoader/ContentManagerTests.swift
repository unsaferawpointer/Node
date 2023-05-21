//
//  ContentManagerTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 21.05.2023.
//

import XCTest
@testable import Node

final class ContentManagerTests: XCTestCase {

	var sut: ContentManager!

	var dataProvider: DataProviderMock!

	override func setUpWithError() throws {
		self.dataProvider = DataProviderMock()
		sut = ContentManager(dataProvider: dataProvider)
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - Common test-cases
extension ContentManagerTests {

	func test_data_whenTypeNameIsInvalid() {
		// Arrange
		let invalidTypeName = "invalidtypename"

		// Act & Assert
		XCTAssertThrowsError(try sut.data(ofType: invalidTypeName), "Should be throw error") { error in
			XCTAssertEqual(error as? ContentManager.ContentError, .unknownFileFormat)
		}
	}

	func test_data_whenTypeNameIsUnsupported() {
		// Arrange
		let unsupportedTymeName = "public.jpeg"

		// Act & Assert
		XCTAssertThrowsError(try sut.data(ofType: unsupportedTymeName), "Should be throw error") { error in
			XCTAssertEqual(error as? ContentManager.ContentError, .unsupportedUniformTypeIdentifier)
		}
	}

	func test_read() throws {
		// Arrange
		let type = "public.plain-text"
		let text =
		"""
		0
			00
			01
		1
		"""
		let data = try XCTUnwrap(text.data(using: .utf8))

		// Act
		try sut.read(from: data, ofType: type)

		// Assert
		XCTAssertEqual(dataProvider.invocations.count, 5)
	}
}
