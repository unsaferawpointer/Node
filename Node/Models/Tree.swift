//
//  Tree.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

/// Representation of a hierarchical data structure
final class Tree<Object> where Object: ReferenceIdentifiable {

	private var nodes: [Node<Object>] = []

	private var cache: [ObjectIdentifier: Node<Object>] = [:]

}

extension Tree {

	/// Number of all objects
	var totalCount: Int {
		return cache.count
	}

	/// Enumerate all objects in DFT order
	func enumerateObjects(block: @escaping (Object) -> Void) {
		enumerateNodes(nodes) { node in
			block(node.object)
		}
	}
}

// MARK: Insert
extension Tree {

	/// Insert objects
	///
	/// - Parameters:
	///    - objects: Objects to insert
	///    - destination: Destination of the insertion
	///    - index: Index of the insertion
	func insert(_ objects: [Object], to destination: Object?, at index: Int?) {
		let nodes = objects.map { Node($0) }
		guard let destination else {
			insert(nodes, to: nil, at: index)
			return
		}
		guard let parent = cache[destination.refId] else {
			fatalError("Tree has no destination object = \(destination)")
		}
		insert(nodes, to: parent, at: index)
	}

	private func insert(_ nodes: [Node<Object>], to destination: Node<Object>?, at index: Int?) {
		switch (destination, index) {
		case (.some(let parent), .some(let index)):
			parent.children.insert(contentsOf: nodes, at: index)
		case (.none, .some(let index)):
			self.nodes.insert(contentsOf: nodes, at: index)
		case (.some(let parent), .none):
			parent.children.append(contentsOf: nodes)
		case (.none, .none):
			self.nodes.append(contentsOf: nodes)
		}
		// Update cache
		insertToCache(nodes)
	}

}

// MARK: - Helpers
private extension Tree {

	func insertToCache(_ nodes: [Node<Object>]) {
		enumerateNodes(nodes) { node in
			let key = node.object.refId
			cache[key] = node
		}
	}

	func enumerateNodes(_ nodes: [Node<Object>], block: (Node<Object>) -> Void) {
		nodes.forEach { visit($0, block: block) }
	}

	func visit(_ node: Node<Object>, block: (Node<Object>) -> Void) {
		block(node)
		for child in node.children {
			visit(child, block: block)
		}
	}
}
