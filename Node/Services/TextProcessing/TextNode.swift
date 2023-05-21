//
//  TextNode.swift
//  Node
//
//  Created by Anton Cherkasov on 21.05.2023.
//

/// Hierarchy representation of the text
final class TextNode {

	/// Text line
	var line: TextLine

	/// Sublines
	var children: [TextNode] = []

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - line: Text line
	///    - children: Sublines
	init(_ line: TextLine, children: [TextNode] = []) {
		self.line = line
		self.children = children
	}
}
