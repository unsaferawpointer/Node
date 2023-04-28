//
//  DataProvider.swift
//  Node
//
//  Created by Anton Cherkasov on 24.04.2023.
//

import Foundation

final class DataProvider {

	typealias Model = Editor.NodeModel

	lazy private (set) var tree: Tree<Model> = Tree<Model>()
}

// MARK: - DataProviderProtocol
extension DataProvider: DataProviderProtocol {

	func numberOfChildrenOfModel(model: Model?) -> Int {
		return tree.numberOfChildren(of: model)
	}

	func child(index: Int, ofModel model: Model?) -> Any {
		return tree.object(in: model, at: index)
	}
}

// MARK: - DataProviderOperation
extension DataProvider: DataProviderOperation {

	func insert(
		_ models: [Model],
		to destination: Model?,
		at index: Int?,
		handler: (IndexSet, Model?) -> Void
	) {
		tree.insert(models, to: destination, at: index, handler: handler)
	}
}
