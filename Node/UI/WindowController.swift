//
//  WindowController.swift
//  JSON-OK
//
//  Created by Anton Cherkasov on 14.04.2023.
//

import Cocoa

/// WindowController of the document
class WindowController: NSWindowController {

	lazy private var toolbar: NSToolbar = {
		let toolbar = NSToolbar(identifier: "toolbar")
		toolbar.sizeMode = .regular
		toolbar.displayMode = .default
		toolbar.delegate = self
		return toolbar
	}()

	private (set) var toolbarFactory: ToolbarFactoryProtocol = ToolbarFactory()

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - window: Window
	override init(window: NSWindow?) {
		super.init(window: window)
		window?.toolbar = toolbar
	}

	@available(*, unavailable, message: "Use init(window:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

// MARK: - NSWindowController life-cycle
extension WindowController {

	override func windowDidLoad() {
		super.windowDidLoad()
	}
}

// MARK: - NSToolbarDelegate
extension WindowController: NSToolbarDelegate {

	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarFactory.defaultItemIdentifiers
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarFactory.allowedItemIdentifiers
	}

	func toolbar(
		_ toolbar: NSToolbar,
		itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		willBeInsertedIntoToolbar flag: Bool
	) -> NSToolbarItem? {
		return toolbarFactory.makeItem(itemIdentifier)
	}
}
