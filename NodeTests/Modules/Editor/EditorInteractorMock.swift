//
//  EditorInteractorMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 22.05.2023.
//

import Foundation
import Hierarchy
@testable import Node

final class EditorInteractorMock {

	var invocations: [Invocation] = []

	// MARK: - Stubs

	var childrenStub: [NodeModel] = []

	var actionsStub: [Action] = []

	var canMoveStub: Bool = false
}

// MARK: - EditorInteractor
extension EditorInteractorMock: EditorInteractor {

	func children(ofItem item: NodeModel?) -> [NodeModel] {
		childrenStub
	}

	func insertItems(_ items: [NodeModel], to destination: Destination<NodeModel>, completionHandler: ([Action]) -> Void) {
		invocations.append(.insertItems(items, toDestination: destination))
		completionHandler(actionsStub)
	}

	func removeItems(_ items: [NodeModel], completionHandler: ([Action]) -> Void) {
		invocations.append(.removeItems(items))
		completionHandler(actionsStub)
	}

	func moveItems(_ items: [NodeModel], to destination: Destination<NodeModel>, completionHandler: ([Action]) -> Void) {
		invocations.append(.moveItems(items, toDestination: destination))
		completionHandler(actionsStub)
	}

	func canMove(_ items: [NodeModel], to target: NodeModel?) -> Bool {
		canMoveStub
	}
}

// MARK: - Nested data structs
extension EditorInteractorMock {

	enum Invocation {
		case children(ofItem: NodeModel?)
		case insertItems(_ items: [NodeModel], toDestination: Destination<NodeModel>)
		case removeItems(_ items: [NodeModel])
		case moveItems(_ items: [NodeModel], toDestination: Destination<NodeModel>)
		case canMove(_ items: [NodeModel], toTarget: NodeModel?)
	}
}
