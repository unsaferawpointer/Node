//
//  Tree.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Foundation

/// Representation of a hierarchical data structure
final class Tree<Object> where Object: ReferenceIdentifiable {

	weak var delegate: TreeDelegate?

	private var nodes: [Node<Object>] = []

	private var cache: [ObjectIdentifier: Node<Object>] = [:]

}

extension Tree {

	/// Number of all objects
	var totalCount: Int {
		return cache.count
	}

	func parent(of object: Object) -> Object? {
		guard let node = cache[object.refId] else {
			fatalError("Tree has no object = \(object)")
		}
		return node.parent?.object
	}

	/// Returns object in specific object at specific index
	///
	/// - Parameters:
	///    - parent: Parent object
	///    - index: Offset of the child
	func object(in parent: Object?, at index: Int) -> Object {
		guard let parent else {
			return nodes[index].object
		}
		guard let node = cache[parent.refId] else {
			fatalError("Tree has no object = \(parent)")
		}
		return node.children[index].object
	}

	/// Enumerate all objects in DFT order
	func enumerateObjects(block: @escaping (Object) -> Void) {
		enumerateNodes(nodes) { node in
			block(node.object)
		}
	}

	/// Number of children for specific object
	///
	/// - Parameters:
	///    - object: Parent
	/// - Returns: Number of children
	func numberOfChildren(of object: Object?) -> Int {
		guard let object else {
			return nodes.count
		}
		guard let node = cache[object.refId] else {
			fatalError("Tree has no object = \(object)")
		}
		return node.children.count
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
		// Update cache
		insertToCache(nodes)

		switch (destination, index) {
		case (.some(let parent), .some(let index)):
			let indexSet = IndexSet(index..<index + nodes.count)
			parent.insertToChildren(nodes, at: index)
			delegate?.treeInsertedNewObjects(to: indexSet, in: parent.object)
		case (.none, .some(let index)):
			let indexSet = IndexSet(index..<index + nodes.count)
			self.nodes.insert(contentsOf: nodes, at: index)
			delegate?.treeInsertedNewObjects(to: indexSet, in: nil)
		case (.some(let parent), .none):
			let firstIndex = parent.children.count
			let indexSet = IndexSet(firstIndex..<firstIndex + nodes.count)
			parent.appendToChildren(nodes)
			delegate?.treeInsertedNewObjects(to: indexSet, in: parent.object)
		case (.none, .none):
			let firstIndex = self.nodes.count
			let indexSet = IndexSet(firstIndex..<firstIndex + nodes.count)
			self.nodes.append(contentsOf: nodes)
			delegate?.treeInsertedNewObjects(to: indexSet, in: nil)
		}
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
