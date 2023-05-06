//
//  TreeBuilder.swift
//  Node
//
//  Created by Anton Cherkasov on 05.05.2023.
//

@resultBuilder
struct TreeBuilder<Object: ReferenceIdentifiable> {

	static func buildBlock(_ components: Node<Object>...) -> [Node<Object>] {
		return components
	}

	static func buildBlock(_ components: Object...) -> [Node<Object>] {
		return components.map { Node<Object>($0) }
	}

	static func buildOptional(_ component: [Node<Object>]?) -> [Node<Object>] {
		return component ?? []
	}
}
