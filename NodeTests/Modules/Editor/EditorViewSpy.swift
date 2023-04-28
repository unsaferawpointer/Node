//
//  EditorViewSpy.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import Foundation
@testable import Node

final class EditorViewSpy {

	var invocations: [Action] = []

	var selectionStub: [Editor.NodeModel] = []
}

// MARK: - EditorView
extension EditorViewSpy: EditorView {

	func getSelection() -> [Node.Editor.NodeModel] {
		invocations.append(.getSelection)
		return selectionStub
	}

	func insert(_ indexes: IndexSet, destination: Any?) {
		invocations.append(.insert(indexes: indexes, destination: destination))
	}

	func expand(_ object: AnyObject?, withAnimation animate: Bool) {
		invocations.append(.expand(object: object, animate: animate))
	}

	func select(_ objects: [AnyObject]) {
		invocations.append(.select(objects))
	}

	func reloadData() {
		invocations.append(.reloadData)
	}
}

// MARK: - Nested data structs
extension EditorViewSpy {

	enum Action {
		case reloadData
		case getSelection
		case insert(indexes: IndexSet, destination: Any?)
		case expand(object: AnyObject?, animate: Bool)
		case select(_ objects: [AnyObject])
	}
}
