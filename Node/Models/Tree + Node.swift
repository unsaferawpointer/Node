//
//  Tree + Node.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

extension Tree {

	/// Representation of a node in a tree
	final class Node<Object> {

		var object: Object

		var children: [Node<Object>]

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - object: Object of the node
		///    - children: Children
		init(_ object: Object, children: [Node<Object>] = []) {
			self.object = object
			self.children = children
		}
	}
}
