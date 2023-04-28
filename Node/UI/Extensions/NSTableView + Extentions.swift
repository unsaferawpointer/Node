//
//  NSTableView + Extentions.swift
//  JSON
//
//  Created by Anton Cherkasov on 09.04.2023.
//

import Cocoa

extension NSTableView {

	func addTableColumns(_ columns: [NSTableColumn]) {
		for column in columns {
			addTableColumn(column)
		}
	}

	var effectiveSelection: IndexSet {
		guard clickedRow != -1 else {
			return selectedRowIndexes
		}
		return selectedRowIndexes.contains(clickedRow)
				? selectedRowIndexes
				: IndexSet(integer: clickedRow)
	}
}
