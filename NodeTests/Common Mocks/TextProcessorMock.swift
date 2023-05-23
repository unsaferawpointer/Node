//
//  TextProcessorMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 23.05.2023.
//

import Foundation
@testable import Node

final class TextProcessorMock {

	var invocations: [Invocation] = []

	// MARK: - Stubs

	var getLineStub: String = UUID().uuidString

	var makeNodesStub: [TextNode] = []

}

// MARK: - TextProcessing
extension TextProcessorMock: TextProcessing {

	func makeNodes(_ text: String) -> [TextNode] {
		invocations.append(.makeNodes(text))
		return makeNodesStub
	}

	func getLine(_ level: Int, text: String) -> String {
		invocations.append(.getLine(level, text: text))
		return getLineStub
	}
}

// MARK: - Nested data structs
extension TextProcessorMock {

	enum Invocation {
		case makeNodes(_ text: String)
		case getLine(_ level: Int, text: String)
	}
}
