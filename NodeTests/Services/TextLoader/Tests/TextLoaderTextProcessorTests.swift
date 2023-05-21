//
//  TextLoaderTests.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 20.05.2023.
//

import XCTest
@testable import Node

final class TextProcessorTests: XCTestCase {

	var sut: TextProcessor!

	override func setUpWithError() throws {
		sut = TextProcessor()
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

extension TextProcessorTests {

	func test_makeNodes() {
		// Arrange
		let text =
		"""
		0
		    00
			01
		    02
				020		trailing
		        021  @done
			03
		1
			10
		        100
			11
		"""

		// Act
		let nodes = sut.makeNodes(text)

		// Assert
		XCTAssertEqual(nodes.count, 2)

		XCTAssertEqual(nodes[0].children.count, 4)
		XCTAssertEqual(nodes[0].line.value, "0")
		XCTAssertEqual(nodes[0].children[0].line.value, "00")
		XCTAssertEqual(nodes[0].children[1].line.value, "01")
		XCTAssertEqual(nodes[0].children[2].line.value, "02")
		XCTAssertEqual(nodes[0].children[2].children[0].line.value, "020\t\ttrailing")
		XCTAssertEqual(nodes[0].children[2].children[1].line.value, "021")
		XCTAssertEqual(nodes[0].children[2].children[1].line.isDone, true)
		XCTAssertEqual(nodes[0].children[3].line.value, "03")
		XCTAssertEqual(nodes[1].line.value, "1")
		XCTAssertEqual(nodes[1].children[0].line.value, "10")
		XCTAssertEqual(nodes[1].children[0].children[0].line.value, "100")
		XCTAssertEqual(nodes[1].children[1].line.value, "11")
	}

	func test_getLine() {

		// Act
		let line = sut.getLine(4, text: "placeholder")

		// Assert
		XCTAssertEqual(line, "\t\t\t\tplaceholder")
	}
}
