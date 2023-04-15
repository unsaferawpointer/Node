//
//  WindowController.swift
//  JSON-OK
//
//  Created by Anton Cherkasov on 14.04.2023.
//

import Cocoa

/// WindowController of the document
class WindowController: NSWindowController {

	lazy var toolbar: NSToolbar = {
		let toolbar = NSToolbar(identifier: "toolbar")
		toolbar.sizeMode = .regular
		toolbar.displayMode = .iconOnly
		return toolbar
	}()

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
