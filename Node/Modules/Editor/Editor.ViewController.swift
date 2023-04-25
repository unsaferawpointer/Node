//
//  Editor.ViewController.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa

/// Interface of the editor view
protocol EditorView: AnyObject {
	/// Reload all data
	func reloadData()
}

extension Editor {

	/// ViewController of the Editor module
	final class ViewController: NSViewController {

		// MARK: - DI

		var output: (EditorTableAdapter & ViewControllerOutput)!

		// MARK: - UI-Properties

		lazy var scrollview: NSScrollView	 = .default

		lazy var table: NSOutlineView		 = .default

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - configure: Configuration closure. Setup module here.
		init(_ configure: (Editor.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureUserInterface()
			configureConstraints()
		}

		@available(*, unavailable, message: "Use init()")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - NSViewController life-cycle
extension Editor.ViewController {

	override func loadView() {
		view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		output?.viewControllerDidChangeState(.didLoad)
	}
}

// MARK: - EditorView
extension Editor.ViewController: EditorView {

	func reloadData() {
		table.reloadData()
	}
}

// MARK: - Helpers
private extension Editor.ViewController {

	func configureUserInterface() {
		let column = NSTableColumn(identifier: .mainColumn)
		column.resizingMask = [.autoresizingMask, .userResizingMask]
		table.addTableColumn(column)

		table.delegate = self
		table.dataSource = self
	}

	func configureConstraints() {
		scrollview.documentView = table

		view.addSubview(scrollview)
		scrollview.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		)
	}
}

private extension NSUserInterfaceItemIdentifier {
	static let mainColumn = NSUserInterfaceItemIdentifier(rawValue: "main")
}
