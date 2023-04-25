//
//  Editor.ViewController + NSOutlineViewDelegate.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa

// MARK: - NSOutlineViewDelegate
extension Editor.ViewController: NSOutlineViewDelegate {

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		guard let config = output.viewModel(for: tableColumn?.identifier.rawValue ?? "", item: item) else {
			return nil
		}
		return config.makeField()
	}
}
