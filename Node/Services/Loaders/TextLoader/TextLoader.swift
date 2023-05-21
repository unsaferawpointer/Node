//
//  TextLoader.Loader.swift
//  Node
//
//  Created by Anton Cherkasov on 20.05.2023.
//

import Foundation

/// Loader data from text
final class TextLoader {

	private let processor: TextProcessing

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - processor: Text processing class
	init(processor: TextProcessing = TextProcessor()) {
		self.processor = processor
	}
}

// MARK: - DataLoaderProtocol
extension TextLoader: DataLoaderProtocol {

	func load(data: Data, to dataProvider: DataProviderProtocol) throws {
		guard let text = String(data: data, encoding: .utf8) else {
			throw ContentManager.ContentError.unknownFileFormat
		}
		let nodes = processor.makeNodes(text)
		load(nodes, to: dataProvider)
	}

	func getData(from dataProvider: DataProviderProtocol) throws -> Data {
		let text = getText(from: dataProvider)
		return text.data(using: .utf8) ?? Data()
	}
}

// MARK: - Helpers
private extension TextLoader {

	func load(_ nodes: [TextNode], to dataProvider: DataProviderProtocol) {
		nodes.forEach { load($0, to: dataProvider, parent: nil) }
	}

	func load(_ node: TextNode, to dataProvider: DataProviderProtocol, parent: NodeModel?) {
		let model = NodeModel(isDone: node.line.isDone, text: node.line.value)
		dataProvider.addItems([model], to: parent)
		for child in node.children {
			load(child, to: dataProvider, parent: model)
		}
	}

	func appendLine(from item: NodeModel, in dataProvider: DataProviderProtocol, result: inout [String]) {

		let level = dataProvider.getLevel(of: item)
		let line = processor.getLine(level, text: item.text.lastValue ?? "Empty line")

		result.append(line)

		for child in dataProvider.children(of: item) {
			appendLine(from: child, in: dataProvider, result: &result)
		}
	}

	func getText(from dataProvider: DataProviderProtocol) -> String {
		let items = dataProvider.children(of: nil)
		var result: [String] = []
		items.forEach { appendLine(from: $0, in: dataProvider, result: &result) }
		return result.joined(separator: "\n")
	}
}
