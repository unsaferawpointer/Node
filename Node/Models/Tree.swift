//
//  Tree.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Foundation

/// Representation of a hierarchical data structure
final class Tree<Object> where Object: ReferenceIdentifiable {

	private var nodes: [Node<Object>] = []

	private var cache: [ObjectIdentifier: Node<Object>] = [:]

	init(nodes: [Node<Object>]) {
		self.nodes = nodes
		enumerateNodes(nodes) { cache[$0.refId] = $0 }
	}

	convenience init(@TreeBuilder<Object> _ builder: () -> [Node<Object>]) {
		self.init(nodes: builder())
	}

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
	func insert(_ objects: [Object], to destination: Object?, at index: Int?, handler: (IndexSet, Object?) -> Void) {
		let nodes = objects.map { Node<Object>($0) }
		guard let destination else {
			insert(nodes, to: nil, at: index, handler: handler)
			return
		}
		guard let parent = cache[destination.refId] else {
			fatalError("Tree has no destination object = \(destination)")
		}
		insert(nodes, to: parent, at: index, handler: handler)
	}

	private func insert(
		_ nodes: [Node<Object>],
		to destination: Node<Object>?,
		at index: Int?,
		handler: (IndexSet, Object?) -> Void
	) {
		// Update cache
		insertToCache(nodes)

		switch (destination, index) {
		case (.some(let parent), .some(let index)):
			let indexSet = IndexSet(index..<index + nodes.count)
			parent.insertToChildren(nodes, at: index)
			handler(indexSet, parent.object)
		case (.none, .some(let index)):
			let indexSet = IndexSet(index..<index + nodes.count)
			self.nodes.insert(contentsOf: nodes, at: index)
			handler(indexSet, nil)
		case (.some(let parent), .none):
			let firstIndex = parent.children.count
			let indexSet = IndexSet(firstIndex..<firstIndex + nodes.count)
			parent.appendToChildren(nodes)
			handler(indexSet, parent.object)
		case (.none, .none):
			let firstIndex = self.nodes.count
			let indexSet = IndexSet(firstIndex..<firstIndex + nodes.count)
			self.nodes.append(contentsOf: nodes)
			handler(indexSet, nil)
		}
	}

}

// MARK: - Remove
extension Tree {

	/// Remove objects from the tree
	///
	/// - Parameters:
	///    - objects: Objects to remove
	///    - destination: Source of the deletion
	///    - index: Index of the insertion
	func remove(_ objects: [Object], handler: (IndexSet, Object?) -> Void) {
		let grouped = Dictionary(grouping: objects.map(\.refId)) { objectId -> ObjectIdentifier? in
			guard let node = cache[objectId] else {
				fatalError("Tree has no object with id = \(objectId)")
			}
			return node.parent?.object.refId
		}

		for (parentId, ids) in grouped {
			remove(from: parentId, ids: ids, handler: handler)
		}
		removeFromCache(objects.map(\.refId))
	}

	private func remove(from parentId: ObjectIdentifier?, ids: [ObjectIdentifier], handler: (IndexSet, Object?) -> Void) {
		if let parentId, let parent = cache[parentId] {
			let indexes = ids.compactMap {
				parent.children.firstIndex(where: \.refId, equalsTo: $0)
			}
			parent.remove(ids)
			handler(IndexSet(indexes), parent.object)
		} else {
			let indexes = ids.compactMap {
				nodes.firstIndex(where: \.refId, equalsTo: $0)
			}
			nodes.removeAll { ids.contains($0.refId) }
			handler(IndexSet(indexes), nil)
		}
	}
}

// MARK: - Helpers
private extension Tree {

	func insertToCache(_ nodes: [Node<Object>]) {
		enumerateNodes(nodes) { node in
			let key = node.object.refId
			guard cache[key] == nil else {
				fatalError("Cache already contains key = \(key)")
			}
			cache[key] = node
		}
	}

	func removeFromCache(_ ids: [ObjectIdentifier]) {
		let nodes = ids.compactMap { cache[$0] }
		removeFromCache(nodes)
	}

	func removeFromCache(_ nodes: [Node<Object>]) {
		enumerateNodes(nodes) { node in
			let key = node.object.refId
			cache.removeValue(forKey: key)
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
