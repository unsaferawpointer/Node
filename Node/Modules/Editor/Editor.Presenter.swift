//
//  Editor.Presenter.swift
//  Node
//
//  Created by Anton Cherkasov on 24.04.2023.
//

import Hierarchy
import Cocoa

/// Interface of Editor Table
protocol EditorTableAdapter: AnyObject {

	/// Number of the children of the node
	///
	/// - Parameters:
	///    - item: Node
	func numberOfChildrenOfItem(item: Any?) -> Int

	/// Returns child of the node
	///
	/// - Parameters:
	///    - index: Index of the child
	///    - item: Parent of the child
	/// - Returns: Returns child
	func child(index: Int, ofItem item: Any?) -> Any

	/// Returns ability tobe expanded
	///
	/// - Parameters:
	///    - item: Node
	func isItemExpandable(item: Any) -> Bool

	/// Returns view-model
	///
	/// - Parameters:
	///    - column: Table column identifier
	///    - item: Node
	/// - Returns: View-Model
	func viewModel(for column: String, item: Any) -> (any FieldConfiguration)?

	func moveItems(_ items: [Any], to target: Any?)

	func moveItems(_ items: [Any], to target: Any, at index: Int)

	func moveItemsToRoot(_ items: [Any], at index: Int)

	func canMove(_ items: [Any], to target: Any?) -> Bool
}

/// Common interface of Editor module presenter
protocol EditorPresenter: AnyObject {

	/// User clicked add menu item
	func userClickedAddMenuItem()

	/// User clicked `Delete` menu item
	func userClickedDeleteMenuItem()
}

extension Editor {

	/// Presenter of the Editor module
	final class Presenter {

		// MARK: - DI

		weak var view: EditorView?

		var localization: EditorLocalization = Editor.Localization()

		var dataProvider: DataProviderProtocol

		init(dataProvider: DataProviderProtocol) {
			self.dataProvider = dataProvider
		}

	}
}

// MARK: - ViewControllerOutput
extension Editor.Presenter: ViewControllerOutput {

	func viewControllerDidChangeState(_ state: ViewLifeCycle) {
		guard case .didLoad = state else {
			return
		}
		view?.reloadData()
	}

	func validateMenuItem(selector: Selector) -> Bool {
		return true
	}
}

// MARK: - EditorPresenter
extension Editor.Presenter: EditorPresenter {

	func userClickedAddMenuItem() {
		let new = NodeModel(isDone: false, text: localization.newObjectPlaceholderTitle)
		let first = view?.getSelection().first as? NodeModel

		let operations = dataProvider.addItems([new], to: first)
		performAnimation(operations)

		view?.expand(first, withAnimation: true)
	}

	func userClickedDeleteMenuItem() {
		let selectedItems = view?.getSelection() as? [NodeModel]
		let operations = dataProvider.removeItems(selectedItems ?? [])
		performAnimation(operations)
	}

}

// MARK: - EditorPresenter
extension Editor.Presenter: EditorTableAdapter {

	typealias Model = NodeModel

	func numberOfChildrenOfItem(item: Any?) -> Int {
		return dataProvider.numberOfChildren(of: item as? Model)
	}

	func child(index: Int, ofItem item: Any?) -> Any {
		return dataProvider.child(ofItem: item as? Model, at: index)
	}

	func isItemExpandable(item: Any) -> Bool {
		guard let model = item as? Model else {
			fatalError("This type is not supported. Type = \(item.self)")
		}
		return dataProvider.numberOfChildren(of: model) > 0
	}

	func moveItems(_ items: [Any], to target: Any?) {
		guard let items = items as? [Model] else {
			fatalError("This type is not supported. Type = \(items.self)")
		}
		let target = target as? Model
		let operations = dataProvider.moveItems(items, to: target)
		performAnimation(operations)
		view?.expand(target, withAnimation: true)
	}

	func moveItems(_ items: [Any], to target: Any, at index: Int) {
		guard let items = items as? [Model], let target = target as? Model else {
			return
		}
		let operations = dataProvider.moveItems(items, to: target, at: index)
		performAnimation(operations)
		view?.expand(target, withAnimation: true)
	}

	func moveItemsToRoot(_ items: [Any], at index: Int) {
		guard let items = items as? [Model] else {
			fatalError("This type is not supported. Type = \(items.self)")
		}
		let operations = dataProvider.moveItemsToRoot(items, at: index)
		performAnimation(operations)
	}

	func canMove(_ items: [Any], to target: Any?) -> Bool {
		guard let items = items as? [Model] else {
			fatalError("This type is not supported. Type = \(items.self)")
		}
		let target = target as? Model
		return dataProvider.canMove(items, to: target)
	}

	func viewModel(for column: String, item: Any) -> (any FieldConfiguration)? {
		guard let model = item as? Model else {
			fatalError("This type is not supported. Type = \(item.self)")
		}
		return CheckboxConfiguration(value: model.isDone, title: model.text)
	}
}

// MARK: - Helpers
private extension Editor.Presenter {

	func performAnimation(_ operations: [HierarchyDiffAction<Model>]) {
		view?.startUpdating()
		for operation in operations {
			switch operation {
				case .updateItem(let item):
					if let item { view?.update(item) }
				case .removeItems(let indexes, let parent):
					view?.remove(indexes, parent: parent)
				case .insertItems(let indexes, let parent):
					view?.insert(indexes, destination: parent)
			}
		}
		view?.endUpdating()
	}
}
