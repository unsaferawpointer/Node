//
//  Document.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa
import Hierarchy

class Document: NSDocument {

	let contentManager = ContentManager()

	override init() {
		super.init()
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		let window = NSWindow.makeDefault()
		window.tabbingMode = .preferred
		let windowController = WindowController(window: window)
		windowController.shouldCascadeWindows = true
		windowController.contentViewController = Editor.Assembly.build(contentManager.dataProvider)
		addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		// Insert code here to write your document to data of the specified type, throwing an error in case of failure.
		// Alternatively, you could remove this method and override fileWrapper(ofType:),
		// write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
		// throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		return try contentManager.data(ofType: typeName)
	}

	override func read(from data: Data, ofType typeName: String) throws {
		// Insert code here to read your document from the given data of the specified type,
		// throwing an error in case of failure.
		// Alternatively, you could remove this method and override read(from:ofType:) instead.
		// If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
		// throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		try contentManager.read(from: data, ofType: typeName)
	}

}
