//
//  Tree + Node.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

extension Tree {

	/// Representation of a node in a tree
	final class Node<Object: ReferenceIdentifiable> {

		var object: Object

		private (set) weak var parent: Node<Object>?

		private (set) var children: [Node<Object>]

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - object: Object of the node
		///    - parent: Parent of the node
		///    - children: Children
		init(
			_ object: Object,
			parent: Node<Object>? = nil,
			children: [Node<Object>] = []
		) {
			self.object = object
			self.children = children
			self.parent = parent
			children.forEach { $0.parent = self }
		}
	}
}

// MARK: - Public interface
extension Tree.Node {

	func appendToChildren(_ nodes: [Tree.Node<Object>]) {
		nodes.forEach { $0.parent = self }
		children.append(contentsOf: nodes)
	}

	func insertToChildren(_ nodes: [Tree.Node<Object>], at index: Int) {
		nodes.forEach { $0.parent = self }
		children.insert(contentsOf: nodes, at: index)
	}
}
