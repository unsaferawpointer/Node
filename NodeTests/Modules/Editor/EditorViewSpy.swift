//
//  EditorViewSpy.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

@testable import Node

final class EditorViewSpy {

	var invocations: [Action] = []
}

// MARK: - EditorView
extension EditorViewSpy: EditorView {

	func reloadData() {
		invocations.append(.reloadData)
	}
}

// MARK: - Nested data structs
extension EditorViewSpy {

	enum Action {
		case reloadData
	}
}
