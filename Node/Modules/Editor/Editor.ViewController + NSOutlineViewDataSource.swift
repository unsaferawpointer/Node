//
//  Editor.ViewController + NSOutlineViewDataSource.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa

// MARK: - NSOutlineViewDataSource
extension Editor.ViewController: NSOutlineViewDataSource {

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		return output.numberOfChildrenOfItem(item: item)
	}

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		return output.child(index: index, ofItem: item)
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return output.isItemExpandable(item: item)
	}
}
