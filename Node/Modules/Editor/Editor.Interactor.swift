//
//  Editor.Interactor.swift
//  Node
//
//  Created by Anton Cherkasov on 22.05.2023.
//

import Hierarchy

/// Interface of the Editor module interactor
protocol EditorInteractor {

	typealias Action = HierarchyDiffAction<NodeModel>

	/// Children of the item
	///
	/// - Parameters:
	///    - item: Parent item
	func children(ofItem item: NodeModel?) -> [NodeModel]

	/// Insert items
	///
	/// - Parameters:
	///    - items: Moving items
	///    - destination: Destination
	///    - completionHandler: Completion closure. Returns diff actions.
	func insertItems(
		_ items: [NodeModel],
		to destination: Destination<NodeModel>,
		completionHandler: ([Action]) -> Void
	)

	/// Remove items
	func removeItems(_ items: [NodeModel], completionHandler: ([Action]) -> Void)

	/// Move items
	func moveItems(
		_ items: [NodeModel],
		to destination: Destination<NodeModel>,
		completionHandler: ([Action]) -> Void
	)

	/// Returns availability of the moving operation
	func canMove(_ items: [NodeModel], to target: NodeModel?) -> Bool
}

extension Editor {

	/// Editor module interactor
	final class Interactor {

		private var textProcessor: TextProcessing

		private var dataProvider: DataProviderProtocol

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - dataProvider: Data provider
		///    - textProcessor: Text processor
		init(
			dataProvider: DataProviderProtocol,
			textProcessor: TextProcessing = TextProcessor()
		) {
			self.dataProvider = dataProvider
			self.textProcessor = textProcessor
		}
	}
}

// MARK: - EditorInteractor
extension Editor.Interactor: EditorInteractor {

	func children(ofItem item: NodeModel?) -> [NodeModel] {
		dataProvider.children(of: item)
	}

	func insertItems(
		_ items: [NodeModel],
		to destination: Destination<NodeModel>,
		completionHandler: ([Action]) -> Void
	) {
		let operations = insertItems(items, to: destination)
		completionHandler(operations)
	}

	func removeItems(_ items: [NodeModel], completionHandler: ([Action]) -> Void) {
		let operations = dataProvider.removeItems(items)
		completionHandler(operations)
	}

	func moveItems(
		_ items: [NodeModel],
		to destination: Destination<NodeModel>,
		completionHandler: ([Action]) -> Void
	) {
		let operations = moveItems(items, to: destination)
		completionHandler(operations)
	}

	func canMove(_ items: [NodeModel], to target: NodeModel?) -> Bool {
		dataProvider.canMove(items, to: target)
	}
}

// MARK: - Helpers
private extension Editor.Interactor {

	func moveItems(_ items: [NodeModel], to destination: Destination<NodeModel>) -> [Action] {
		switch destination {
			case .onRoot:
				return dataProvider.moveItems(items, to: nil)
			case let .intoRoot(index):
				return dataProvider.moveItemsToRoot(items, at: index)
			case let .onTarget(target):
				return dataProvider.moveItems(items, to: target)
			case let .intoTarget(target, index):
				return dataProvider.moveItems(items, to: target, at: index)
		}
	}

	func insertItems(_ items: [NodeModel], to destination: Destination<NodeModel>) -> [Action] {
		switch destination {
			case .onRoot:
				return dataProvider.addItems(items, to: nil)
			case .intoRoot:
				fatalError()
			case let .onTarget(target):
				return dataProvider.addItems(items, to: target)
			case .intoTarget:
				fatalError()
		}
	}
}
