//
//  DataProvider.swift
//  Node
//
//  Created by Anton Cherkasov on 11.05.2023.
//

import Hierarchy

protocol DataProviderProtocol {

	typealias Item = NodeModel

	typealias Action = HierarchyDiffAction<NodeModel>

	/// Number of the children of the node
	///
	/// - Parameters:
	///    - item: Node
	func numberOfChildren(of item: Item?) -> Int

	/// Returns child of the node
	///
	/// - Parameters:
	///    - index: Index of the child
	///    - item: Parent of the child
	/// - Returns: Returns child
	func child(ofItem item: Item?, at index: Int) -> Item

	/// Add new items
	///
	/// - Parameters:
	///    - items: New items
	///    - target: Destination of the insertion
	/// - Returns: Diff actions for operation
	@discardableResult
	func addItems(_ items: [Item], to target: Item?) -> [Action]

	/// Remove items
	///
	/// - Parameters:
	///    - items: Removing items
	/// - Returns: Diff actions for operation
	@discardableResult
	func removeItems(_ items: [Item]) -> [Action]

	/// Move items
	///
	/// - Parameters:
	///    - items: Moving items
	///    - target: Destination of the moving
	/// - Returns: Diff actions for operation
	@discardableResult
	func moveItems(_ items: [Item], to target: Item?) -> [Action]

	/// Move items
	///
	/// - Parameters:
	///    - items: Moving items
	///    - target: Destination of the moving
	///    - index: Index in children array of the target
	/// - Returns: Diff actions for operation
	@discardableResult
	func moveItems(_ items: [Item], to target: Item, at index: Int) -> [Action]

	/// Move items to root at specific index
	///
	/// - Parameters:
	///    - items: Moving items
	///    - index: Index in root array
	/// - Returns: Diff actions for operation
	@discardableResult
	func moveItemsToRoot(_ items: [Item], at index: Int) -> [Action]

	/// Returns availability of the moving items
	///
	/// - Parameters:
	///    - items: Moving items
	///    - target: Destination of the moving
	func canMove(_ items: [Item], to target: Item?) -> Bool
}

/// Data provider for hierarchy data struct
final class DataProvider {

	private (set) var data: HierarchyData<Item> = .init()
}

// MARK: - DataProviderProtocol
extension DataProvider: DataProviderProtocol {

	typealias Item = NodeModel

	typealias Action = HierarchyDiffAction<Item>

	@discardableResult
	func moveItems(_ items: [Item], to target: Item?) -> [Action] {
		data.startUpdating()
		data.move(items, to: target)
		return data.endUpdating()
	}

	@discardableResult
	func moveItems(_ items: [Item], to target: Item, at index: Int) -> [Action] {
		data.startUpdating()
		data.move(items, to: target, at: index)
		return data.endUpdating()
	}

	@discardableResult
	func moveItemsToRoot(_ items: [Item], at index: Int) -> [Action] {
		data.startUpdating()
		data.moveToRoot(items, at: index)
		return data.endUpdating()
	}

	func canMove(_ items: [Item], to target: Item?) -> Bool {
		return data.canMove(items, to: target)
	}

	func numberOfChildren(of item: Item?) -> Int {
		return data.numberOfChildren(of: item)
	}

	func child(ofItem item: Item?, at index: Int) -> Item {
		return data.child(in: item, at: index)
	}

	@discardableResult
	func addItems(_ items: [Item], to target: Item?) -> [Action] {
		data.startUpdating()
		if let target {
			data.insert(items, to: target, at: nil)
		} else {
			data.insert(items, at: nil)
		}
		return data.endUpdating()
	}

	@discardableResult
	func removeItems(_ items: [Item]) -> [Action] {
		data.startUpdating()
		data.remove(items)
		return data.endUpdating()
	}
}
