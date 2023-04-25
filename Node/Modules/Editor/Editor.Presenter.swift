//
//  Editor.Presenter.swift
//  Node
//
//  Created by Anton Cherkasov on 24.04.2023.
//

import Foundation
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
}

extension Editor {

	/// Presenter of the Editor module
	final class Presenter {

		// MARK: - DI

		weak var view: EditorView?

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
}

// MARK: - EditorPresenter
extension Editor.Presenter: EditorTableAdapter {

	typealias Model = Editor.NodeModel

	func numberOfChildrenOfItem(item: Any?) -> Int {
		return dataProvider.numberOfChildrenOfModel(model: item as? Model)
	}

	func child(index: Int, ofItem item: Any?) -> Any {
		return dataProvider.child(index: index, ofModel: item as? Model)
	}

	func isItemExpandable(item: Any) -> Bool {
		guard let model = item as? Model else {
			fatalError("This type is not supported. Type = \(item)")
		}
		return dataProvider.numberOfChildrenOfModel(model: model) > 0
	}

	func viewModel(for column: String, item: Any) -> (any FieldConfiguration)? {
		guard let model = item as? Model else {
			return nil
		}
		return CheckboxConfiguration(value: model.isDone, title: model.text)
	}
}
