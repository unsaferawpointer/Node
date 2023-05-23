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

	/// Returns availability of the moving
	func canMove(_ items: [Any], to target: Any?) -> Bool

	/// Move items to destination without checking availability of the operation
	///
	/// - Parameters:
	///    - items: Moving items
	///    - destination: Destination
	func moveItems(_ items: [Any], to destination: Destination<Any>)
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

		var interactor: EditorInteractor

		var localization: EditorLocalization = Editor.Localization()

		// MARK: - Initialization

		init(interactor: EditorInteractor) {
			self.interactor = interactor
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
		guard let first = view?.getSelection().first as? NodeModel else {
			interactor.insertItems([new], to: .onRoot) { [weak self] actions in
				self?.performAnimation(actions)
			}
			return
		}

		interactor.insertItems([new], to: .onTarget(first)) { [weak self] actions in
			self?.performAnimation(actions)
			self?.view?.expand(first, withAnimation: true)
		}
		return
	}

	func userClickedDeleteMenuItem() {
		guard let selectedItems = view?.getSelection() as? [NodeModel] else {
			return
		}
		interactor.removeItems(selectedItems) { [weak self] actions in
			self?.performAnimation(actions)
		}
	}

}

// MARK: - EditorPresenter
extension Editor.Presenter: EditorTableAdapter {

	typealias Model = NodeModel

	func numberOfChildrenOfItem(item: Any?) -> Int {
		return interactor.children(ofItem: item as? Model).count
	}

	func child(index: Int, ofItem item: Any?) -> Any {
		return interactor.children(ofItem: item as? Model)[index]
	}

	func isItemExpandable(item: Any) -> Bool {
		return !interactor.children(ofItem: item as? Model).isEmpty
	}

	func moveItems(_ items: [Any], to destination: Destination<Any>) {
		guard let items = items as? [Model] else {
			fatalError("This type is not supported. Type = \(items.self)")
		}
		guard let destination = destination.optionalCast(to: Model.self) else {
			fatalError("This type is not supported. Type = \(destination.self)")
		}
		interactor.moveItems(items, to: destination) { [weak self] actions in
			self?.performAnimation(actions)
		}

		switch destination {
			case .onTarget(let parent), .intoTarget(let parent, _):
				view?.expand(parent, withAnimation: true)
			default:
				break
		}
	}

	func canMove(_ items: [Any], to target: Any?) -> Bool {
		guard let items = items as? [Model] else {
			fatalError("This type is not supported. Type = \(items.self)")
		}
		return interactor.canMove(items, to: target as? Model)
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
