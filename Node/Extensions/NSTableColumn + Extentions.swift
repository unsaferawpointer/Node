//
//  NSTableColumn + Extentions.swift
//  JSON
//
//  Created by Anton Cherkasov on 09.04.2023.
//

import Cocoa

extension NSTableColumn {

	convenience init(_ identifier: String, title: String = "") {
		self.init(identifier: .init(rawValue: identifier))
		self.title = title
	}
}
