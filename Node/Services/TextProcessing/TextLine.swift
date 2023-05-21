//
//  TextLine.swift
//  Node
//
//  Created by Anton Cherkasov on 21.05.2023.
//

/// Representation of text line
struct TextLine {
	/// Indentation of the text in line
	var level: Int
	/// Line contains `@done`
	var isDone: Bool
	/// Trimmed text of line
	var value: String
}
