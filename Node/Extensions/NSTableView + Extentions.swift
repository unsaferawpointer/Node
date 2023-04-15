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
}
