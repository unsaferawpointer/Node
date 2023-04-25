//
//  NSOutlineView + Extensions.swift
//  JSON
//
//  Created by Anton Cherkasov on 12.04.2023.
//

import Cocoa

extension NSOutlineView {

	static let `default`: NSOutlineView = {
		let view = NSOutlineView()
		view.style = .inset
		view.focusRingType = .default
		view.selectionHighlightStyle = .regular
		view.rowSizeStyle = .medium
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.usesAutomaticRowHeights = false
		view.allowsColumnResizing = true
		view.autoresizesOutlineColumn = false
		view.usesAlternatingRowBackgroundColors = true
		view.intercellSpacing = .init(width: 0, height: 8)
		view.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
		return view
	}()
}
