//
//  Node.swift
//  Node
//
//  Created by Anton Cherkasov on 05.05.2023.
//

/// Node representation of the object
final class Node<Object: ReferenceIdentifiable> {

	private (set) var object: Object

	private (set) weak var parent: Node?

	private (set) var children: [Node]

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - object: Object of the node
	///    - parent: Parent of the node
	///    - children: Children
	init(
		_ object: Object,
		parent: Node? = nil,
		children: [Node] = []
	) {
		self.object = object
		self.children = children
		self.parent = parent
		children.forEach { $0.parent = self }
	}

	/// Basic initialization with result builder
	///
	/// - Parameters:
	///    - object: Object of the node
	///    - builder: Result builder, returns children of the node
	init(_ object: Object, @TreeBuilder<Object> _ builder: () -> [Node]) {
		self.object = object
		self.children = builder()
		children.forEach { $0.parent = self }
	}
}

// MARK: - Public interface
extension Node {

	var refId: ObjectIdentifier {
		return object.refId
	}

	func appendToChildren(_ nodes: [Node<Object>]) {
		nodes.forEach { $0.parent = self }
		children.append(contentsOf: nodes)
	}

	func insertToChildren(_ nodes: [Node<Object>], at index: Int) {
		nodes.forEach { $0.parent = self }
		children.insert(contentsOf: nodes, at: index)
	}

	func remove(_ ids: [ObjectIdentifier]) {
		children.removeAll { ids.contains($0.object.refId) }
	}
}
