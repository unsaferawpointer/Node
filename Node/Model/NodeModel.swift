//
//  NodeModel.swift
//  Node
//
//  Created by Anton Cherkasov on 13.05.2023.
//

import Hierarchy

/// View-model of the node
final class NodeModel {

	/// Status of the node
	var isDone: Bindable<Bool>

	/// Text of the node
	var text: Bindable<String>

	/// Basic initialization
	///
	/// - Parameters:
	///    - isDone: Status of the node
	///    - text: Text of the node
	init(isDone: Bool, text: String) {
		self.isDone = .init(isDone)
		self.text = .init(text)
	}
}

// MARK: - ReferenceIdentifiable
extension NodeModel: ReferenceIdentifiable { }

// MARK: - Equatable
extension NodeModel: Equatable {

	static func == (lhs: NodeModel, rhs: NodeModel) -> Bool {
		return lhs.id == rhs.id
	}
}
