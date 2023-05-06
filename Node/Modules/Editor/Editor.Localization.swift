//
//  Editor.Localization.swift
//  Node
//
//  Created by Anton Cherkasov on 25.04.2023.
//

/// Interface of the strings localization
protocol EditorLocalization {

	var newObjectMenuItem: String { get }

	var deleteObjectMenuItem: String { get }

	var newObjectPlaceholderTitle: String { get }
}

extension Editor {

	/// Localization of the Editor module
	final class Localization { }
}

// MARK: - EditorLocalization
extension Editor.Localization: EditorLocalization {

	var newObjectMenuItem: String {
		return "New"
	}

	var deleteObjectMenuItem: String {
		return "Delete"
	}

	var newObjectPlaceholderTitle: String {
		return "Todo"
	}
}
