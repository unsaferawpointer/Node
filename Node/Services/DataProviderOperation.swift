//
//  DataProviderOperation.swift
//  Node
//
//  Created by Anton Cherkasov on 27.04.2023.
//

import Foundation

/// Data Provider operations interface
protocol DataProviderOperation {

	/// Insert new nodes
	///
	/// - Parameters:
	///    - models: New nodes
	///    - destination: Destination of the insertion
	///    - index: Index of the insertion
	///    - handler: Completion callback
	func insert(
		_ models: [Editor.NodeModel],
		to destination: Editor.NodeModel?,
		at index: Int?,
		handler: (IndexSet, Editor.NodeModel?) -> Void
	)

	func remove(
		_ models: [Editor.NodeModel],
		handler: (IndexSet, Editor.NodeModel?) -> Void
	)
}
