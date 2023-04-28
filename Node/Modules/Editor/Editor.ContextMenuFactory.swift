//
//  Editor.ContextMenuFactory.swift
//  Node
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import Cocoa

extension Editor {

	/// Factory of the context menu
	final class ContextMenuFactory { }
}

extension Editor.ContextMenuFactory {

	/// Build context menu for table
	///
	/// - Parameters:
	///    - localization: Localization
	/// - Returns: Table context menu
	static func build(localization: EditorLocalization = Editor.Localization()) -> NSMenu {

		let menu: NSMenu = {
			let menu = NSMenu()
			menu.title = ""
			menu.addItem({
				let item = NSMenuItem()
				item.title = localization.newObjectMenuItem
				item.keyEquivalent = "n"
				item.action = #selector(CommonMenuSupportable.newObject(_:))
				return item
			}())
			return menu
		}()

		return menu
	}
}
