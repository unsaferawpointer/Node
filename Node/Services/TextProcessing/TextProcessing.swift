//
//  TextLoader.TextProcessing.swift
//  Node
//
//  Created by Anton Cherkasov on 20.05.2023.
//

/// Interface of text processing
protocol TextProcessing {

	/// Returns text hierarchy
	///
	/// - Parameters:
	///    - text: Source text
	func makeNodes(_ text: String) -> [TextNode]

	/// Returns text line with indentation prefix
	///
	/// - Parameters:
	///    - level: Indendation
	///    - text: Trimmed text
	func getLine(_ level: Int, text: String) -> String
}

/// Text processing class
final class TextProcessor {

	private let widthOfCharacters: [Character: Int] = ["\u{0009}": 4, "\u{0020}": 1]
}

// MARK: - TextProcessing
extension TextProcessor: TextProcessing {

	func makeNodes(_ text: String) -> [TextNode] {

		let lines = makeLines(from: text)
		let normalizedLines = normalizeLines(lines)

		var result: [TextNode] = []

		var cache: [Int: TextNode] = [:]

		for line in normalizedLines {
			let node = TextNode(line)
			cache[line.level] = node
			guard let parent = cache[line.level - 1] else {
				result.append(node)
				continue
			}
			parent.children.append(node)
		}
		return result
	}

	func getLine(_ level: Int, text: String) -> String {
		let prefix = Array(repeating: "\t", count: level).joined()
		return prefix + text
	}
}

// MARK: - Helpers
extension TextProcessor {

	func makeLines(from text: String) -> [TextLine] {
		var result = [TextLine]()
		text.enumerateLines { [weak self] substring, _ in
			guard let self else {
				return
			}
			let level = self.getLevel(from: substring)
			let isDone = substring.contains("@done")
			let replaced = substring.replacing("@done", with: "")
			let trimmedSubstring = replaced.trimmingCharacters(in: .whitespacesAndNewlines)
			let line = TextLine(level: level, isDone: isDone, value: trimmedSubstring)
			result.append(line)
		}
		return result
	}

	func getLevel(from line: String) -> Int {
		var totalWidth = 0
		for char in line {
			guard let width = widthOfCharacters[char] else {
				break
			}
			totalWidth += width
		}
		return (totalWidth % 4) == 0
					? totalWidth / 4
					: totalWidth / 4 + 1
	}

	func normalizeLines(_ lines: [TextLine]) -> [TextLine] {
		var buffer = lines
		guard !buffer.isEmpty else {
			return []
		}

		buffer[0].level = 0
		for index in 1..<buffer.count {
			let previous = buffer[index - 1].level
			if buffer[index].level > previous, buffer[index].level - previous != 1 {
				buffer[index].level = previous + 1
			}
		}

		return buffer
	}
}
