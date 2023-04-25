//
//  DataProvider.swift
//  Node
//
//  Created by Anton Cherkasov on 24.04.2023.
//

/// Interface of the data provider
protocol DataProviderProtocol {

	typealias Model = Editor.NodeModel

	/// Number of the children of the node
	///
	/// - Parameters:
	///    - model: Node
	func numberOfChildrenOfModel(model: Model?) -> Int

	/// Returns child of the node
	///
	/// - Parameters:
	///    - index: Index of the child
	///    - model: Parent of the child
	/// - Returns: Returns child
	func child(index: Int, ofModel model: Model?) -> Any
}

final class DataProvider {

	typealias Model = Editor.NodeModel

	lazy var tree: Tree<Model> = Tree<Model>()
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
