//
//  Editor.ViewController.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa

extension Editor {

	/// ViewController of the Editor module
	final class ViewController: NSViewController {

		// MARK: - UI-Properties

		lazy var scrollview: NSScrollView	 = .default

		lazy var table: NSOutlineView		 = .default

		// MARK: - Initialization

		init() {
			super.init(nibName: nil, bundle: nil)
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
	}
}

// MARK: - Helpers
private extension Editor.ViewController {

	func configureUserInterface() {
		table.headerView = nil
		table.addTableColumn(.init(identifier: .mainColumn))
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
