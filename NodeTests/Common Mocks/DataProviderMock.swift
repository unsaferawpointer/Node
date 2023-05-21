//
//  DataProviderMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 13.05.2023.
//

import Foundation
import Hierarchy
@testable import Node

final class DataProviderMock {

	var invocations: [Invocation] = []

	// MARK: - Stubs

	var numberOfChildrenOfItemStub: Int = 0

	var childOfItemStub: NodeModel = .init(isDone: false, text: "")

	var addItemsStub: [Action] = []

	var removeItemsStub: [Action] = []

	var moveItemsToTargetStub: [Action] = []

	var moveItemsToTargetAtIndexStub: [Action] = []

	var moveItemsToRootStub: [Action] = []

	var canMoveStub = false

	var childrenStub: [NodeModel] = []

	var getLevelStub = 0
}

// MARK: - DataProviderProtocol
extension DataProviderMock: DataProviderProtocol {

	typealias Action = HierarchyDiffAction<NodeModel>

	typealias Item = NodeModel

	func numberOfChildren(of item: Item?) -> Int {
		let invocation: Invocation = .numberOfChildrenOfItem(item)
		invocations.append(invocation)
		return numberOfChildrenOfItemStub
	}

	func child(ofItem item: Item?, at index: Int) -> Item {
		let invocation: Invocation = .childOfItem(item, index: index)
		invocations.append(invocation)
		return childOfItemStub
	}

	func addItems(_ items: [Item], to target: Item?) -> [Action] {
		let invocation: Invocation = .addItems(items, target: target)
		invocations.append(invocation)
		return addItemsStub
	}

	func removeItems(_ items: [Item]) -> [Action] {
		let invocation: Invocation = .removeItems(items)
		invocations.append(invocation)
		return removeItemsStub
	}

	func moveItems(_ items: [Item], to target: Item?) -> [Action] {
		let invocation: Invocation = .moveItemsToTarget(items, target: target)
		invocations.append(invocation)
		return moveItemsToTargetStub
	}

	func moveItems(_ items: [Item], to target: Item, at index: Int) -> [Action] {
		let invocation: Invocation = .moveItemsToTargetAtIndex(items, target: target, index: index)
		invocations.append(invocation)
		return moveItemsToTargetAtIndexStub
	}

	func moveItemsToRoot(_ items: [Item], at index: Int) -> [Action] {
		let invocation: Invocation = .moveItemsToRoot(items, index: index)
		invocations.append(invocation)
		return moveItemsToRootStub
	}

	func canMove(_ items: [Item], to target: Item?) -> Bool {
		return canMoveStub
	}

	func children(of item: Item?) -> [Item] {
		childrenStub
	}

	func getLevel(of item: Item) -> Int {
		getLevelStub
	}

	func clearStorage() {
		invocations.append(.clearStorage)
	}
}

extension DataProviderMock {

	enum Invocation {

		case numberOfChildrenOfItem(_ item: Item?)

		case childOfItem(_ item: Item?, index: Int)

		case addItems(_ items: [Item], target: Item?)

		case removeItems(_ items: [Item])

		case moveItemsToTarget(_ items: [Item], target: Item?)

		case moveItemsToTargetAtIndex(_ items: [Item], target: Item, index: Int)

		case moveItemsToRoot(_ items: [Item], index: Int)

		case clearStorage
	}
}
