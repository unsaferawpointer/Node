//
//  DataProviderProtocol.swift
//  Node
//
//  Created by Anton Cherkasov on 27.04.2023.
//

import Foundation

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
